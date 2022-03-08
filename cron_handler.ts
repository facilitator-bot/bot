import { App } from '@slack/bolt'
import * as usecase from './usecase'
const app = new App({
  token: usecase.slackConfig.botToken,
  signingSecret: usecase.slackConfig.signingSecret,
  processBeforeResponse: true
})

export async function handler(_event: any, _context: any) {
  await usecase.notifyFacilitator(async (msg) => {
    await app.client.chat.postMessage(msg)
  })
}