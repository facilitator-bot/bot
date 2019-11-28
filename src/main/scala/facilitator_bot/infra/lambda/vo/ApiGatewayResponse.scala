package facilitator_bot.infra.lambda.vo

import scala.beans.BeanProperty
@SuppressWarnings(Array("org.wartremover.warts.DefaultArguments"))
final case class ApiGatewayResponse(
    @BeanProperty statusCode: Integer,
    @BeanProperty body: String,
    @BeanProperty headers: java.util.Map[String, Object],
    @BeanProperty base64Encoded: Boolean = false)
