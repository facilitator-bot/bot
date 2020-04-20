package facilitator_bot.infra.slack

import com.slack.api.model.block.ActionsBlock.ActionsBlockBuilder
import com.slack.api.model.block.Blocks.{actions, asBlocks, section}
import com.slack.api.model.block.LayoutBlock
import com.slack.api.model.block.composition.BlockCompositions.{
  plainText,
  markdownText
}
import com.slack.api.model.block.element.BlockElements.{asElements, button}
import facilitator_bot.domain.reminder.FacilitatorRemind

package object syntax {
  implicit class ToSlackLayoutBlock(remind: FacilitatorRemind) {
    def toSlackLayoutBlock(
        implicit slackConfig: SlackConfig
    ): java.util.List[LayoutBlock] =
      asBlocks(
        section(_.text(markdownText(remind.reminderMessage))),
        actions(
          (builder: ActionsBlockBuilder) =>
            builder.elements(
              asElements(
                button(
                  b =>
                    b.text(plainText("Skip"))
                      .style("primary")
                      .actionId(slackConfig.skipButtonBlockActionId)
                )
              )
          )
        )
      )
  }
}
