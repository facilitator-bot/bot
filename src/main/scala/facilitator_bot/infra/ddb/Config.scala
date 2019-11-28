package facilitator_bot.infra.ddb

import java.net.URI

final case class Config(candidatesTable: String, endpoint: Option[URI])
