import { ReminderRepository } from '../domain/repository'
import * as models from '../domain/models'
import { App, MessageAttachment } from '@slack/bolt'

export type SlackMessage = MessageAttachment


type SlackConfig = {
  botToken: string
  reminderChannel: string
  skipButtonBlockActionId: string,
  signingSecret: string,
}

export function buildMessage(config: SlackConfig, remind: models.FacilitatorRemind): MessageAttachment {
  return {
    text: models.reminderMessage(remind.candidate),
    blocks: [
      {
        type: "section",
        text: {
          type: "mrkdwn",
          text: models.reminderMessage(remind.candidate)
        }
      },
      {
        type: "actions",
        elements: [
          {
            type: "button",
            text: {
              type: "plain_text",
              text: "Skip"
            },
            style: "primary",
            action_id: config.skipButtonBlockActionId
          }
        ]
      }
    ]
  }
}