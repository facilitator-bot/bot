package facilitator_bot.infra.slack.vo

import java.net.URL
import hammock._

import hammock.Uri

final case class SlackConfig(incomingWebHook: URL) {
  def toURI: Uri = uri"${incomingWebHook.toString}"
}
