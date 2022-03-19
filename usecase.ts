import { newRepository } from './infra/candidate'
import { chooseNextOne, Candidate } from './domain/models'
import { buildMessage } from './infra/slack'
import { ChatPostMessageArguments } from '@slack/web-api/dist/methods'

export const slackConfig = {
  botToken: process.env.SLACK_BOT_TOKEN || '',
  reminderChannel: process.env.REMINDER_CHANNEL || '',
  skipButtonBlockActionId: 'skip-button',
  signingSecret: process.env.SLACK_SIGNING_SECRET || ''
}

const ddbConfig = {
  candidatesTable: process.env.ddb_candidates_table || ''
}

type SendMessageFn = (msg: ChatPostMessageArguments) => Promise<void>

export async function notifyFacilitator(fn: SendMessageFn) {
  const repo = newRepository(ddbConfig)
  const candidate = chooseNextOne(await repo.list())
  const { blocks, text } = await buildMessage(slackConfig, { candidate })
  const update = {
    lastActAt: Math.floor(Date.now() / 1000),
    name: candidate.name,
    slackUserId: candidate.slackUserId
  }
  await fn({
    text,
    channel: slackConfig.reminderChannel,
    blocks,
  })
  await repo.put(update)
}
