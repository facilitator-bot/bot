package facilitator_bot.infra.slack.vo

import io.circe.generic.JsonCodec

@JsonCodec
final case class SlackMessage(text: String)
