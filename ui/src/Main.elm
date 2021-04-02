port module Main exposing (receiveUpdateCandidateResponse, sendUpdateCandidateRequest)

import Browser
import Html exposing (Html, a, button, div, form, h1, img, input, label, p, table, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, readonly, src, type_, value)
import Html.Events exposing (onClick, onInput)



---- MODEL ----


type alias Flags =
    CandidateList


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
    ( { candidates = List.sortBy .lastActAt flags
      , selectedCandidate = Nothing
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = NoOp
    | SelectCandidate Candidate
    | SaveSelectedCandidate Candidate
    | EditLastActAt EditingCandidate String
    | SetCandidateList CandidateList


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        -- リストからユーザー選択
        SelectCandidate c ->
            ( { model | selectedCandidate = Just { selectedCandidate = c, newLastActAt = c.lastActAt } }, Cmd.none )

        -- 編集操作
        EditLastActAt editing newLastActAt ->
            ( { model | selectedCandidate = Just <| editCandidate editing newLastActAt }
            , Cmd.none
            )

        -- 一覧更新
        SetCandidateList cs ->
            ( { model | candidates = List.sortBy .lastActAt cs }, Cmd.none )

        -- 保存
        SaveSelectedCandidate _ ->
            case model.selectedCandidate of
                -- 手元のリストを更新して、更新リクエストを送信する
                Just c ->
                    ( model
                    , sendUpdateCandidateRequest
                        { name = c.selectedCandidate.name
                        , slackUserId = c.selectedCandidate.slackUserId
                        , lastActAt = c.newLastActAt
                        }
                    )

                Nothing ->
                    ( model, Cmd.none )


editCandidate : EditingCandidate -> String -> EditingCandidate
editCandidate candidate newLastActAt =
    case String.toInt newLastActAt of
        Just c ->
            { candidate | newLastActAt = c }

        Nothing ->
            candidate



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
                    , input [ onInput (\s -> EditLastActAt c s), value <| String.fromInt <| c.newLastActAt, type_ "number" ] []
                    ]
                , p []
                    [ label [] [ text "slackUserId" ]
                    , input [ value c.selectedCandidate.slackUserId, readonly True ] []
                    ]
                , button [ onClick (SaveSelectedCandidate c.selectedCandidate), class "btn btn-primary" ] [ text "Save" ]
                ]

        Nothing ->
            div [] [ text "Empty" ]



---- PORTS ----
-- Update Candidate


port sendUpdateCandidateRequest : Candidate -> Cmd msg


port receiveUpdateCandidateResponse : (CandidateList -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions _ =
    receiveUpdateCandidateResponse SetCandidateList



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
