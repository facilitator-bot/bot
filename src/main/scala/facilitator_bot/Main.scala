package facilitator_bot

import cats.effect.Effect
import cats.implicits._
import com.typesafe.scalalogging.LazyLogging
import facilitator_bot.domain.candidate.{Candidate, CandidateRepository}
import facilitator_bot.domain.reminder.ReminderRepository
import facilitator_bot.infra.candidate.DDBCandidateRepository
import facilitator_bot.usecase.{ChooseFacilitator, PopulateSeed}
import facilitator_bot.infra.ddb.Config
import facilitator_bot.infra.reminder.SlackReminderRepository
import facilitator_bot.infra.slack.vo.SlackConfig
import hammock.apache.ApacheInterpreter
import pureconfig.ConfigSource
import pureconfig.generic.auto._

import scala.language.higherKinds

class Main[F[_]: Effect] extends LazyLogging {
  implicit val interpreter = ApacheInterpreter.instance[F]
  implicit val slackConfig: SlackConfig =
    ConfigSource.default.at("slack").loadOrThrow[SlackConfig]
  implicit val ddbConfig: Config =
    ConfigSource.default.at("ddb").loadOrThrow[Config]

  implicit val candidateRepository: CandidateRepository[F] =
    new DDBCandidateRepository[F]
  implicit val reminderRepository: ReminderRepository[F] =
    new SlackReminderRepository[F]

  def run: F[Candidate] =
    for {
      _ <- Effect[F].delay(logger.info("Start"))
      _ <- new PopulateSeed[F].run
      _ <- Effect[F].delay(logger.info("PopulateSeed done"))
      candidate <- new ChooseFacilitator[F]().run
      _ <- Effect[F].delay(logger.info(s"Candidate is ${candidate.name}"))
    } yield candidate

}
