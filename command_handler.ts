import { App, AwsLambdaReceiver } from '@slack/bolt'
import { AwsCallback, AwsEvent } from '@slack/bolt/dist/receivers/AwsLambdaReceiver'
import * as usecase from './usecase'


const receiver = new AwsLambdaReceiver({
  signingSecret: usecase.slackConfig.signingSecret
})

const app = new App({
  token: usecase.slackConfig.botToken,
  receiver,
  processBeforeResponse: true
})


app.action('skip-button', async ({ ack, say }) => {
  await ack()
  await usecase.notifyFacilitator(async (msg) => {
    await app.client.chat.postMessage(msg)
  })
})

export async function handler(event: AwsEvent, context: any, callback: AwsCallback) {
  const handler = await receiver.start();
  return handler(event, context, callback);
}