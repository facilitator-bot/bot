package facilitator_bot.usecase

import com.slack.api.bolt.App
import facilitator_bot.Components
import facilitator_bot.infra.slack.syntax._
import facilitator_bot.domain.reminder.FacilitatorRemind
import monix.eval.Task
import monix.execution.Scheduler

object SlackCommands {
  def skipCommand(implicit components: Components[Task],
                  scheduler: Scheduler): App =
    new App()
      .blockAction(
        components.slackConfig.skipButtonBlockActionId,
        (_, ctx) =>
          (for {
            res <- Task(ctx.ack())
            _ <- components.populateSeed.run
            next <- components.chooseFacilitator.run
            _ <- Task(
              ctx.say(
                b =>
                  b.channel(components.slackConfig.reminderChannel)
                    blocks (FacilitatorRemind(next).toSlackLayoutBlock(
                      components.slackConfig))
              )
            )
          } yield res)
            .runSyncUnsafe()
      )
}
