import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';
gapi.load('client:auth2', async function () {
  await gapi.client.init({
    'apiKey': process.env.ELM_APP_GOOGLE_API_KEY,
    'clientId': process.env.ELM_APP_GOOGLE_CLIENT_ID,
    'scope': 'openid'
  });
  const auth = gapi.auth2.getAuthInstance();
  const result = await auth.signIn();
  result.getAuthResponse().access_token;
  Elm.Main.init({
    node: document.getElementById('root')
  });
});





// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
