package facilitator_bot
import com.slack.api.bolt.aws_lambda.SlackApiLambdaHandler
import com.slack.api.bolt.aws_lambda.request.ApiGatewayRequest
import facilitator_bot.usecase.SlackCommands
import monix.eval.Task
import monix.execution.Scheduler.Implicits.global

class CommandHandler
    extends SlackApiLambdaHandler(
      SlackCommands.skipCommand(new Components[Task], global)
    ) {
  override def isWarmupRequest(awsReq: ApiGatewayRequest): Boolean =
    false //no warm up requests
}
