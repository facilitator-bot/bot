package facilitator_bot.usecase

import java.time.Instant

import cats.effect.Effect
import cats.implicits._
import facilitator_bot.domain.candidate.{
  Candidate,
  CandidateRepository,
  NoCandidateFoundError
}
import facilitator_bot.domain.reminder.{FacilitatorRemind, ReminderRepository}

import scala.language.higherKinds

class ChooseFacilitator[F[_]: Effect](
    implicit candidateRepository: CandidateRepository[F],
    reminderRepository: ReminderRepository[F]) {

  def run: F[Candidate] =
    for {
      candidates <- candidateRepository.list
      nextOne <- Effect[F].fromEither(
        candidates.chooseNextOne.toRight(new NoCandidateFoundError))
      _ <- candidateRepository.put(
        nextOne.copy(lastActAt = Instant.now().getEpochSecond))
      _ <- reminderRepository.notify(FacilitatorRemind(nextOne))
    } yield nextOne

}
