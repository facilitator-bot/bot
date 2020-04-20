package facilitator_bot.domain.candidate

import io.circe.generic.JsonCodec

@JsonCodec
case class Candidate(name: String, lastActAt: Long, slackUserId: String)
