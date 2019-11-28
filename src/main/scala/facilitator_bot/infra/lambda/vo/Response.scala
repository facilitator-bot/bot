package facilitator_bot.infra.lambda.vo

import scala.beans.BeanProperty

case class Response(@BeanProperty message: String,
                    @BeanProperty request: Request)
