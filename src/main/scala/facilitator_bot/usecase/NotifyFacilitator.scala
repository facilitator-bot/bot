package facilitator_bot.usecase

import cats.effect.Effect
import facilitator_bot.domain.reminder.{FacilitatorRemind, ReminderRepository}

class NotifyFacilitator[F[_]: Effect](
    implicit facilitatorRepository: ReminderRepository[F]
) {
  def run(remind: FacilitatorRemind): F[Unit] =
    facilitatorRepository.notify(remind)
}
