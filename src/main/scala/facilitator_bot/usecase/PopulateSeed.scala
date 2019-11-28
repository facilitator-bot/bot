package facilitator_bot.usecase

import cats.effect.Effect
import cats.implicits._
import facilitator_bot.domain.candidate.{Candidate, CandidateRepository}
import io.circe.parser._

import scala.io.Source
import scala.language.higherKinds

class PopulateSeed[F[_]: Effect](
    implicit candidateRepository: CandidateRepository[F]) {

  def run: F[Unit] =
    for {
      json <- Effect[F].delay(Source.fromResource("seeds.json").mkString)
      records <- Effect[F].fromEither(
        parse(json).flatMap(_.as[List[Candidate]]))
      _ <- records
        .map(r => candidateRepository.putIfAbsent(r))
        .sequence
    } yield ()

}
