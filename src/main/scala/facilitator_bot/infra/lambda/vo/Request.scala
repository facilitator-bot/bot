package facilitator_bot.infra.lambda.vo

import scala.beans.BeanProperty

@SuppressWarnings(Array("org.wartremover.warts.Var"))
class Request(@BeanProperty var key1: String,
              @BeanProperty var key2: String,
              @BeanProperty var key3: String) {
  def this() = this("", "", "")
}
