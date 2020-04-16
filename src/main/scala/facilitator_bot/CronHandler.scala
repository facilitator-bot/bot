package facilitator_bot

import com.amazonaws.services.lambda.runtime.{Context, RequestHandler}
import com.typesafe.scalalogging.LazyLogging
import facilitator_bot.domain.reminder.FacilitatorRemind
import facilitator_bot.infra.lambda.vo._
import monix.eval.Task
import monix.execution.Scheduler.Implicits.global

class CronHandler extends RequestHandler[Request, Response] with LazyLogging {
  private val components: Components[Task] = new Components[Task]

  def handleRequest(input: Request, context: Context): Response = {
    (for {
      _ <- components.populateSeed.run
      candidate <- components.chooseFacilitator.run
      _ <- components.notifyFacilitator.run(FacilitatorRemind(candidate))
    } yield candidate)
      .onErrorRestart(5)
      .map(_ => Response())
      .runSyncUnsafe()
  }
}

@SuppressWarnings(
  Array("org.wartremover.warts.NonUnitStatements", "org.wartremover.warts.Null")
)
object CronHandler extends App {
  new CronHandler().handleRequest(Request(), null)
}
