import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';
import { fromCognitoIdentityPool } from '@aws-sdk/credential-provider-cognito-identity';
import { CognitoIdentityClient } from '@aws-sdk/client-cognito-identity';
import * as AWS from '@aws-sdk/client-dynamodb';

// authorize, then get access token
gapi.load('client:auth2', async function () {
  await gapi.client.init({
    'apiKey': process.env.ELM_APP_GOOGLE_API_KEY,
    'clientId': process.env.ELM_APP_GOOGLE_CLIENT_ID,
    'scope': 'openid'
  });
  const auth = gapi.auth2.getAuthInstance();
  const result = await auth.signIn();
  // Initialize the Amazon Cognito credentials provider
  const credentials = fromCognitoIdentityPool({
    identityPoolId: process.env.ELM_APP_COGNITO_ID_POOL_ID,
    logins: {
      'accounts.google.com': result.getAuthResponse().id_token
    },
    client: new CognitoIdentityClient({
      region: process.env.ELM_APP_COGNITO_REGION,
    })
  });

  async function getCandidates() {
    const response = await client.scan({
      TableName: process.env.ELM_APP_DDB_TABLE_NAME,
      ConsistentRead: true
    });
    return response.Items.map(item =>
      Object.fromEntries(
        Object.entries(item).map(([k, v]) => 
          [
            k,
            v['N'] ? parseInt(v['N']): v['S']
          ]
         )
      )
    );
  }

  async function updateCandidate(candidate) {
   return await client.putItem({
      TableName: process.env.ELM_APP_DDB_TABLE_NAME,
      Item: {
        'name': { S: candidate.name },
        'lastActAt': { N: String(candidate.lastActAt) },
        'slackUserId': { S: candidate.slackUserId },
      }
    });
  }

  //create ddb client
  const client = new AWS.DynamoDB({
    region: process.env.ELM_APP_COGNITO_REGION, credentials
  });
  // start elm app with candidates as initial values
  const app = Elm.Main.init({
    node: document.getElementById('root'),
    flags: await getCandidates()
  });

  //setup ports

  //update candidate
  app.ports.sendUpdateCandidateRequest.subscribe(async function (candidate) {
    try {
      await updateCandidate(candidate)
      const candidates = await getCandidates()
      //then send it back to app
      app.ports.receiveUpdateCandidateResponse.send({ candidates, error: null });
    } catch (e) {
      app.ports.receiveUpdateCandidateResponse.send({ candidates: null, error: e.message });
     }
  });

});


// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
