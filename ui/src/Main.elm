port module Main exposing (..)

import Browser
import Html exposing (Html, div, table, tr, th, text, thead, tbody, td, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Html.Events exposing (onClick)


-- MAIN


main =
  Browser.element
  {
    init = init,
    update = update,
    view = view,
    subscriptions = sub
  }


-- Ports

port sendMessage : () -> Cmd msg
port messageReceiver : (UserList -> msg) -> Sub msg


-- MODEL

type alias User =
  {
    name: String,
    lastAccAt:String,
    slackId:String
  }

type alias UserList = List User


type Model
  = BeforeLogin
  | LoggdedIn UserList

init : () -> (Model, Cmd Msg)
init _ = (BeforeLogin, Cmd.none)


-- UPDATE

type Msg =
  Login
  | GetUserList UserList


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Login -> (BeforeLogin, sendMessage () )
    GetUserList users -> (LoggdedIn users, Cmd.none)

-- Subscription

sub : Model -> Sub Msg
sub _ =
  messageReceiver GetUserList
-- VIEW

view : Model -> Html Msg
view model =
  case model of
    BeforeLogin ->
      div [class "form-signin"]
        [
          Html.h2 [] [text "Please sign in"],
          button [class "btn", onClick Login] [
            Html.img [Html.Attributes.src "img/btn_google_signin_light_normal_web.png"] []
          ]
        ]
    LoggdedIn users ->
      div []
        [
          table []
            [
              thead [] [
                th [] [text "Name"],
                th [] [text "LastAccAt"],
                th [] [text "slackId"]
              ],
              tbody [] (List.map ( \u -> tr [] [
                td [] [text u.name],
                td [] [text u.lastAccAt],
                td [] [text u.slackId]
              ]) users)
            ]
        ]
