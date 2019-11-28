package facilitator_bot.domain.reminder

trait ReminderRepository[F[_]] {

  def notify(facilitatorRemind: FacilitatorRemind): F[Unit]

}

object ReminderRepository {
  implicit def repository[F[_]](
      implicit r: ReminderRepository[F]): ReminderRepository[F] = r
}
