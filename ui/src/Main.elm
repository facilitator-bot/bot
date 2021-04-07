port module Main exposing (receiveUpdateCandidateResponse, sendUpdateCandidateRequest)

import Browser
import Html exposing (Html, a, div, h1, input, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, disabled, href, scope, type_, value)
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
    , infoMsg: Maybe String
    }

type alias HasInfoMsg a = { a | infoMsg: Maybe String }

init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { candidates = List.sortBy .lastActAt flags
      , selectedCandidate = Nothing
      , infoMsg = Nothing
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
    | ShowUpdatedCandidateList CandidateList
    | DismissInfoMsg


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
            ( { model | candidates = sortCandidateList cs }, Cmd.none )
        -- 更新完了
        ShowUpdatedCandidateList cs -> ( { model | candidates = sortCandidateList cs, infoMsg = Just "Saved!!" }, Cmd.none )
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
        -- メッセージ非表示
        DismissInfoMsg -> ({model | infoMsg = Nothing}, Cmd.none)

editCandidate : EditingCandidate -> String -> EditingCandidate
editCandidate candidate newLastActAt =
    case String.toInt newLastActAt of
        Just c ->
            { candidate | newLastActAt = c }

        Nothing ->
            candidate

sortCandidateList: CandidateList -> CandidateList
sortCandidateList cs = List.sortBy .lastActAt cs


---- VIEW ----


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "jumbotron jumbotron-fluid" ]
            [ div [ class "container" ]
                [ h1 [ class "display-4" ] [ text "facilitator bot admin UI" ]
                ]
            ]
        , candidatesTable model.candidates
        , infoAlert model
        , editCandidateForm model.selectedCandidate
        ]


candidatesTable : CandidateList -> Html Msg
candidatesTable candidates =
    div [ class "table-responsive" ]
        [ table [ class "table table-bordered table-hover table-sm" ]
            [ thead []
                [ th [ scope "col" ] [ text "name" ]
                , th [ scope "col" ] [ text "slackUserId" ]
                , th [ scope "col" ] [ text "lastActAt" ]
                ]
            , tbody [] <| List.map candidateTableRow candidates
            ]
        ]


candidateTableRow : Candidate -> Html Msg
candidateTableRow candidate =
    tr []
        [ th [ scope "row" ] [ a [ href "#", onClick (SelectCandidate candidate) ] [ text candidate.name ] ]
        , td [] [ text candidate.slackUserId ]
        , td [] [ text <| String.fromInt <| candidate.lastActAt ]
        ]


editCandidateForm : Maybe EditingCandidate -> Html Msg
editCandidateForm candidate =
    case candidate of
        Just c ->
            formCard <|
                Html.form []
                    [ div [ class "form-row" ]
                        [ div [ class "col-sm-3" ] [ input [ value c.selectedCandidate.name, disabled True, class "form-control" ] [] ]
                        , div [ class "col-sm-3" ] [ input [ class "form-control", value c.selectedCandidate.slackUserId, disabled True ] [] ]
                        , div [ class "col-sm-3" ] [ input [ class "form-control", onInput (\s -> EditLastActAt c s), value <| String.fromInt <| c.newLastActAt, type_ "number" ] [] ]
                        , div [ class "col-sm-3" ] [ input [ type_ "button", onClick (SaveSelectedCandidate c.selectedCandidate), class "btn btn-primary", value "Save" ] [] ]
                        ]
                    ]

        Nothing ->
            formCard <| text "Choose user from the table above."


formCard : Html a -> Html a
formCard elm =
    div [ class "card" ]
        [ div [ class "card-body" ]
            [ Html.h5 [ class "card-title" ] [ text "Edit users" ]
            , elm
            ]
        ]

infoAlert : HasInfoMsg a -> Html Msg
infoAlert msg = case msg.infoMsg of
   Just m -> div [class "alert alert-success alert-dismissable"] [
       Html.strong [] [text m]
       , Html.button [onClick DismissInfoMsg ,type_ "button", class "close"] [Html.span [] [text "×"]]
       ]
   Nothing-> div [] []



---- PORTS ----
-- Update Candidate


port sendUpdateCandidateRequest : Candidate -> Cmd msg


port receiveUpdateCandidateResponse : (CandidateList -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions _ =
    receiveUpdateCandidateResponse ShowUpdatedCandidateList



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
