module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, img, table, thead, th, tr, td, form, label, input, p, button, a)
import Html.Attributes exposing (src, value, type_, class, readonly, href)
import Html.Events exposing (onClick)

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
    ( {candidates = [{name = "ニャン助", slackUserId = "1234", lastActAt = 1234}
    ,{name = "てんこ", slackUserId = "5678", lastActAt = 1234}
    ,{name = "カヌレ", slackUserId = "9999", lastActAt = 1234}
    ,{name = "あん", slackUserId = "1111", lastActAt = 1234}
    ,{name = "つぶ", slackUserId = "333", lastActAt = 1234}
    ,{name = "パトラ", slackUserId = "4444", lastActAt = 1234}], selectedCandidate = Nothing }, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp
    | SelectCandidate Candidate


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
    case msg of 
        NoOp -> (model, Cmd.none)
        SelectCandidate c -> ({model | selectedCandidate = Just c} , Cmd.none)



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        , candidatesTable model.candidates
        , editCandidateForm model.selectedCandidate
        ]

candidatesTable: CandidateList -> Html Msg
candidatesTable candidates = 
    table [class "table"]
        (List.concat [
            [
                thead []
                    [
                        th [] [text "name"]
                        ,th [] [text "slackUserId"]
                        ,th [] [text "lastActAt"]
                    ]
            ]
            , List.map candidateTableRow candidates
        ])

candidateTableRow: Candidate -> Html Msg
candidateTableRow candidate = tr []
    [
        td [] [a [href "#", onClick (SelectCandidate candidate)] [text candidate.name]]
        ,td [] [text candidate.slackUserId]
        ,td [] [text <| String.fromInt <| candidate.lastActAt]
    ]

editCandidateForm: Maybe Candidate -> Html Msg
editCandidateForm candidate = 
    case candidate of 
        Just c ->form [class "form"] [
            p [] [
                label [] [text "Name"]
                ,input [value c.name, readonly True] []
            ]
            ,p [] [
                label [] [text "lastActAt"]
                ,input [value <| String.fromInt <| c.lastActAt, type_ "number"] [] 
                ]
            ,p [] [
                label [] [text "slackUserId"]
                ,input [value c.slackUserId, readonly True] []
                ]
            ,button [class "btn btn-primary"] [text "Save"]
            ]
        Nothing -> div [] [text "Empty"]

---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
