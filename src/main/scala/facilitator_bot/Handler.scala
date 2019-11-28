package facilitator_bot

import cats.effect.IO
import com.amazonaws.services.lambda.runtime.{Context, RequestHandler}
import facilitator_bot.infra.lambda.vo._
import monix.eval.Task
import monix.execution.Scheduler.Implicits.global

class Handler extends RequestHandler[Request, Response] {

  def handleRequest(input: Request, context: Context): Response = {
    new Main[Task].run
      .onErrorRestart(5)
      .map(next => Response(s"facilitator is ${next.name}", input))
      .to[IO]
      .unsafeRunSync()
  }
}
