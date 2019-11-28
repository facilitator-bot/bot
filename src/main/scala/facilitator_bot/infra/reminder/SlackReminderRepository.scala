package facilitator_bot.infra.reminder

import cats.effect.Effect
import cats.implicits._
import facilitator_bot.domain.reminder.{FacilitatorRemind, ReminderRepository}
import facilitator_bot.infra.slack.vo.{SlackConfig, SlackMessage}
import hammock.circe.implicits._
import hammock.hi.Opts
import hammock._

import scala.language.higherKinds

class SlackReminderRepository[F[_]: Effect](
    implicit interpTrans: InterpTrans[F],
    config: SlackConfig)
    extends ReminderRepository[F] {
  override def notify(facilitatorRemind: FacilitatorRemind): F[Unit] =
    Hammock
      .postWithOpts(config.toURI,
                    Opts.empty,
                    SlackMessage(facilitatorRemind.reminderMessage).some)
      .map(_ => ())
      .exec[F]
}

object SlackReminderRepository {
  implicit def onSlack[F[_]: Effect](
      implicit interpTrans: InterpTrans[F],
      config: SlackConfig): ReminderRepository[F] =
    new SlackReminderRepository[F]
}
