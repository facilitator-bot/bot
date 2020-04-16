package facilitator_bot.infra.slack

import cats.effect.Effect
import cats.implicits._
import com.slack.api.Slack
import com.slack.api.methods.request.chat.ChatPostMessageRequest.ChatPostMessageRequestBuilder
import facilitator_bot.domain.reminder.{FacilitatorRemind, ReminderRepository}
import facilitator_bot.infra.slack.syntax._

class SlackReminderRepository[F[_]: Effect](implicit config: SlackConfig)
    extends ReminderRepository[F] {
  @Override
  def notify(facilitatorRemind: FacilitatorRemind): F[Unit] =
    Effect[F]
      .delay {
        Slack
          .getInstance()
          .methods(config.botToken)
          .chatPostMessage(
            (builder: ChatPostMessageRequestBuilder) =>
              builder
                .channel(config.reminderChannel)
                .blocks(facilitatorRemind.toSlackLayoutBlock)
          )
      }
      .flatMap(
        res =>
          if (res.isOk) Effect[F].unit
          else Effect[F].raiseError(new RuntimeException(res.getError))
      )
}
