module Main exposing (..)

import Browser
import Html exposing (Html, a, button, div, form, h1, img, input, label, p, table, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, readonly, src, type_, value)
import Html.Events exposing (onClick)
import Html.Events exposing (onInput)



---- MODEL ----

type alias Flags = CandidateList

type alias Candidate =
    { lastActAt : Int
    , name : String
    , slackUserId : String
    }


type alias EditingCandidate =
    { selectedCandidate : Candidate
    , newLastActAt : Int
    }


type alias CandidateList =
    List Candidate


type alias Model =
    { candidates : CandidateList
    , selectedCandidate : Maybe EditingCandidate
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { candidates = flags
            -- [ { name = "ニャン助", slackUserId = "1234", lastActAt = 1234 }
            -- , { name = "てんこ", slackUserId = "5678", lastActAt = 1234 }
            -- , { name = "カヌレ", slackUserId = "9999", lastActAt = 1234 }
            -- , { name = "あん", slackUserId = "1111", lastActAt = 1234 }
            -- , { name = "つぶ", slackUserId = "333", lastActAt = 1234 }
            -- , { name = "パトラ", slackUserId = "4444", lastActAt = 1234 }
            -- ]
      , selectedCandidate = Nothing
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = NoOp
    | SelectCandidate Candidate
    | SaveSelectedCandidate
    | EditLastActAt EditingCandidate String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SelectCandidate c ->
            ( { model | selectedCandidate = Just { selectedCandidate = c, newLastActAt = c.lastActAt } }, Cmd.none )

        EditLastActAt editing newLastActAt -> ({model | selectedCandidate = Just <| editCandidate editing newLastActAt}, Cmd.none)
        SaveSelectedCandidate ->
            ( updateCandidate model, Cmd.none )

editCandidate: EditingCandidate -> String -> EditingCandidate
editCandidate candidate newLastActAt = case String.toInt newLastActAt of 
    Just c -> {candidate | newLastActAt = c}
    Nothing -> candidate

updateCandidate : Model -> Model
updateCandidate model =
    case model.selectedCandidate of
        Just candidate ->
            { model | candidates = updateLastActAt model.candidates candidate }

        _ ->
            model


updateLastActAt : CandidateList -> EditingCandidate -> CandidateList
updateLastActAt candidates editing =
    List.foldl
        (\c cs ->
            if c.name == editing.selectedCandidate.name then
                cs ++ [{ c | lastActAt = editing.newLastActAt }]

            else
                cs ++ [c]
        )
        []
        candidates



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        , candidatesTable model.candidates
        , editCandidateForm model.selectedCandidate
        ]


candidatesTable : CandidateList -> Html Msg
candidatesTable candidates =
    table [ class "table" ]
        (List.concat
            [ [ thead []
                    [ th [] [ text "name" ]
                    , th [] [ text "slackUserId" ]
                    , th [] [ text "lastActAt" ]
                    ]
              ]
            , List.map candidateTableRow candidates
            ]
        )


candidateTableRow : Candidate -> Html Msg
candidateTableRow candidate =
    tr []
        [ td [] [ a [ href "#", onClick (SelectCandidate candidate) ] [ text candidate.name ] ]
        , td [] [ text candidate.slackUserId ]
        , td [] [ text <| String.fromInt <| candidate.lastActAt ]
        ]


editCandidateForm : Maybe EditingCandidate -> Html Msg
editCandidateForm candidate =
    case candidate of
        Just c ->
            div [ class "form" ]
                [ p []
                    [ label [] [ text "Name" ]
                    , input [ value c.selectedCandidate.name, readonly True ] []
                    ]
                , p []
                    [ label [] [ text "lastActAt" ]
                    , input [ onInput (\s -> EditLastActAt c s) , value <| String.fromInt <| c.newLastActAt, type_ "number" ] []
                    ]
                , p []
                    [ label [] [ text "slackUserId" ]
                    , input [ value c.selectedCandidate.slackUserId, readonly True ] []
                    ]
                , button [ onClick SaveSelectedCandidate, class "btn btn-primary" ] [ text "Save" ]
                ]

        Nothing ->
            div [] [ text "Empty" ]



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
