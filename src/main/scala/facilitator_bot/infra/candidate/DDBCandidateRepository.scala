package facilitator_bot.infra.candidate

import java.util.concurrent.CompletionException
import cats.effect.{Effect, IO}
import cats.implicits._
import com.github.j5ik2o.reactive.aws.dynamodb.DynamoDbAsyncClient
import com.github.j5ik2o.reactive.aws.dynamodb.cats.DynamoDbCatsIOClient
import com.github.j5ik2o.reactive.aws.dynamodb.implicits._
import facilitator_bot.domain.candidate.{
  Candidate,
  CandidateList,
  CandidateRepository
}
import facilitator_bot.infra.ddb.Config
import software.amazon.awssdk.services.dynamodb.model.{
  AttributeValue,
  ConditionalCheckFailedException,
  PutItemRequest,
  ScanRequest
}
import software.amazon.awssdk.services.dynamodb.{
  DynamoDbAsyncClient => JavaDynamoDbAsyncClient
}

import scala.concurrent.ExecutionContext

class DDBCandidateRepository[F[_]: Effect](implicit config: Config,
                                           ec: ExecutionContext)
    extends CandidateRepository[F] {

  private val client = DynamoDbCatsIOClient(
    DynamoDbAsyncClient(
      config.endpoint
        .map(endpoint =>
          JavaDynamoDbAsyncClient.builder().endpointOverride(endpoint))
        .getOrElse(JavaDynamoDbAsyncClient.builder)
        .build()))

  override def put(candidate: Candidate): F[Unit] =
    client
      .putItem(putItemRequest(candidate).build())
      .map(_ => ())
      .to[F]

  private def putItemRequest(candidate: Candidate): PutItemRequest.Builder =
    PutItemRequest
      .builder()
      .tableName(config.candidatesTable)
      .itemAsScala(
        Map[String, AttributeValue](
          "name" -> AttributeValue.builder().s(candidate.name).build(),
          "lastActAt" -> AttributeValue
            .builder()
            .n(candidate.lastActAt.toString)
            .build(),
          "slackUserId" -> AttributeValue
            .builder()
            .s(candidate.slackUserId)
            .build()
        )
      )

  override def list: F[CandidateList] =
    client
      .scan(
        ScanRequest.builder().tableName(config.candidatesTable).build()
      )
      .map(
        r =>
          r.itemsAsScala
            .map(items =>
              items.map { item =>
                Candidate(
                  item("name").s(),
                  item("lastActAt").n().toLong,
                  item("slackUserId").s()
                )
              }.toList)
            .fold(List.empty[Candidate])(identity)
      )
      .map(CandidateList.apply)
      .to[F]

  override def putIfAbsent(candidate: Candidate): F[Unit] =
    client
      .putItem(
        putItemRequest(candidate)
          .conditionExpressionAsScala("attribute_not_exists(#n)".some)
          .expressionAttributeNamesAsScala(Map("#n" -> "name").some)
          .build()
      )
      .map(_ => ())
      .recoverWith {
        case e: CompletionException =>
          Option(e.getCause).fold(IO.raiseError[Unit](e)) {
            case _: ConditionalCheckFailedException => IO.unit
            case c                                  => IO.raiseError(c)
          }
      }
      .to[F]

}

object DDBCandidateRepository {
  implicit def onDDB[F[_]: Effect](
      implicit config: Config,
      ec: ExecutionContext): CandidateRepository[F] =
    new DDBCandidateRepository[F]
}
