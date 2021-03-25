module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, img, table, thead, th, tr, td)
import Html.Attributes exposing (src)


---- MODEL ----

type alias Candidate = 
    {lastActAt:Int
    ,name:String
    ,slackUserId:String
    }

type alias CandidateList = List Candidate

type alias Model =
    {candidates: CandidateList
    ,selectedCandidate:Maybe Candidate}


init : ( Model, Cmd Msg )
init =
    ( {candidates = [{name = "hoge", slackUserId = "1234", lastActAt = 1234}
    ,{name = "hoge", slackUserId = "1234", lastActAt = 1234}
    ,{name = "hoge", slackUserId = "1234", lastActAt = 1234}
    ,{name = "hoge", slackUserId = "1234", lastActAt = 1234}
    ,{name = "hoge", slackUserId = "1234", lastActAt = 1234}
    ,{name = "hoge", slackUserId = "1234", lastActAt = 1234}], selectedCandidate = Nothing}, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        , candidatesTable model.candidates
        ]

candidatesTable: CandidateList -> Html Msg
candidatesTable candidates = 
    table []
        (List.concat [
            [
                thead []
                    [
                        th [] [text "name"]
                        ,th [] [text "slackUserId"]
                        ,th [] [text "lastAccAt"]
                    ]
            ]
            , List.map candidateTableRow candidates 
        ])

candidateTableRow: Candidate -> Html Msg
candidateTableRow candidate = tr []
    [
        td [] [text candidate.name]
        ,td [] [text candidate.slackUserId]
        ,td [] [text <| String.fromInt <| candidate.lastActAt]
    ]


---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
