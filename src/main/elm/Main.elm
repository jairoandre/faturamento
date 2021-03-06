module Main exposing (..)

import Html exposing (Html, div, text, img)
import Html.Attributes exposing (class, style, src)
import UrlParser exposing (Parser, (</>), format, int, oneOf, s, string)
import Time exposing (Time)
import Window exposing (Size)
import View.TempoMedio exposing (..)
import View.SemRemessa exposing (..)
import View.Faturamento exposing (..)
import View.Paciente exposing (..)
import Model.TempoMedio exposing (..)
import Model.SemRemessa exposing (..)
import Model.Faturamento exposing (..)
import Model.Paciente exposing (..)
import Model.Utils exposing (tickTimer, tickScrollableBag)
import Api exposing (getTempoMedio, getSemRemessa, getFaturamento, getPacientes)
import Navigation
import String
import Window
import Debug
import Http
import Task


main : Program Never
main =
    Navigation.program
        (Navigation.makeParser hasParser)
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }


type alias Model =
    { page : Page
    , tempoMedio : Maybe SetorTempoMedio
    , semRemessa : Maybe SemRemessa
    , faturamento : Maybe Faturamento
    , paciente : Maybe Paciente
    , scale : Float
    , size : Window.Size
    , tick : Int
    , refreshCount : Int
    , showFaturamento : Bool
    }


type Page
    = Home
    | FaturamentoView
    | PorSetorView


type Msg
    = Resize Page Size
    | Refresh Time
    | TickTime Time
    | FetchFail Http.Error
    | FetchSuccessTempoMedio SetorTempoMedio
    | FetchSuccessSemRemessa SemRemessa
    | FetchSuccessFaturamento Faturamento
    | FetchSuccessPaciente Paciente


init : Result String Page -> ( Model, Cmd Msg )
init result =
    let
        t =
            Debug.log (toString result) 0
    in
        urlUpdate result (Model Home Nothing Nothing Nothing Nothing 1 { width = 0, height = 0 } 0 0 True)


urlUpdate : Result String Page -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    case result of
        Err _ ->
            ( model, Navigation.modifyUrl (toUrl model.page) )

        Ok (Home as page) ->
            ( { model | page = Home }, setScale Home )

        Ok (FaturamentoView as page) ->
            ( { model | page = FaturamentoView }, setScale FaturamentoView )

        Ok (PorSetorView as page) ->
            ( { model | page = PorSetorView }, setScale PorSetorView )


toUrl : Page -> String
toUrl page =
    case page of
        Home ->
            "#home"

        FaturamentoView ->
            "#fat"

        PorSetorView ->
            "#porSetor"


hasParser : Navigation.Location -> Result String Page
hasParser location =
    let
        page =
            String.dropLeft 1 location.hash
    in
        UrlParser.parse identity pageParser page


pageParser : Parser (Page -> a) a
pageParser =
    oneOf
        [ format Home (s "")
        , format Home (s "home")
        , format FaturamentoView (s "fat")
        , format PorSetorView (s "porSetor")
        ]



-- VIEW


view : Model -> Html Msg
view model =
    let
        content =
            case model.page of
                Home ->
                    text ("Redirecionando em " ++ (toString (2 - model.tick)) ++ "...")

                FaturamentoView ->
                    if model.showFaturamento then
                        let
                            faturamento =
                                case model.faturamento of
                                    Nothing ->
                                        text "Carregando..."

                                    Just f ->
                                        faturamentoHtml f model.refreshCount
                        in
                            div [] [ faturamento ]
                    else
                        let
                            paciente =
                                case model.paciente of
                                    Nothing ->
                                        text "Carregando..."

                                    Just p ->
                                        pacienteToHtml p model.refreshCount
                        in
                            div [] [ paciente ]

                PorSetorView ->
                    let
                        tempoMedio =
                            case model.tempoMedio of
                                Nothing ->
                                    text "Carregando..."

                                Just tm ->
                                    setorTempoMedioToHtml tm

                        semRemessa =
                            case model.semRemessa of
                                Nothing ->
                                    text "Carregando..."

                                Just sr ->
                                    semRemessaToHtml sr

                        elems =
                            [ tempoMedio, semRemessa ]
                    in
                        div [] elems
    in
        div
            [ class "app--wrapper"
            , style
                [ ( "transform", "scale(" ++ (toString model.scale) ++ ")" )
                ]
            ]
            [ content ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Resize page newSize ->
            case page of
                Home ->
                    resizeCmd model newSize Cmd.none

                FaturamentoView ->
                    resizeCmd model newSize (Cmd.batch [ fetchFaturamento, fetchPacientes ])

                PorSetorView ->
                    resizeCmd model newSize (Cmd.batch [ fetchSemRemessa, fetchTempoMedio ])

        Refresh newTime ->
            ( model, Cmd.batch [ fetchFaturamento, fetchPacientes ] )

        TickTime newTime ->
            case model.page of
                Home ->
                    if model.tick < 2 then
                        ( { model | tick = model.tick + 1 }, Cmd.none )
                    else
                        ( { model | tick = 0, page = FaturamentoView }, Navigation.newUrl (toUrl FaturamentoView) )

                FaturamentoView ->
                    if model.showFaturamento then
                        let
                            ( newFaturamento, showFaturamento ) =
                                case model.faturamento of
                                    Just faturamento ->
                                        let
                                            tickedFaturamento =
                                                tickScrollableBag faturamento 20 10
                                        in
                                            ( Just tickedFaturamento, tickedFaturamento.cycles == faturamento.cycles )

                                    Nothing ->
                                        ( Nothing, model.showFaturamento )
                        in
                            ( { model
                                | faturamento = newFaturamento
                                , refreshCount = model.refreshCount - 1
                                , showFaturamento = showFaturamento
                              }
                            , Cmd.none
                            )
                    else
                        let
                            ( paciente, showFaturamento ) =
                                case model.paciente of
                                    Just p ->
                                        let
                                            newPaciente =
                                                tickTimer p 20 10
                                        in
                                            ( Just newPaciente, newPaciente.cycles /= p.cycles )

                                    Nothing ->
                                        ( Nothing, model.showFaturamento )
                        in
                            ( { model
                                | paciente = paciente
                                , showFaturamento = showFaturamento
                                , refreshCount = model.refreshCount - 1
                              }
                            , Cmd.none
                            )

                PorSetorView ->
                    let
                        newSemRemessa =
                            case model.semRemessa of
                                Just semRemessa ->
                                    Just (tickTimer semRemessa 20 20)

                                Nothing ->
                                    Nothing

                        newTempoMedio =
                            case model.tempoMedio of
                                Just tempoMedio ->
                                    Just (tickScrollableBag tempoMedio 20 20)

                                Nothing ->
                                    Nothing
                    in
                        ( { model | semRemessa = newSemRemessa, tempoMedio = newTempoMedio }, Cmd.none )

        FetchFail e ->
            let
                t =
                    Debug.log (toString e) 0
            in
                ( model, Cmd.none )

        FetchSuccessTempoMedio tempoMedio ->
            ( { model | tempoMedio = Just tempoMedio }, Cmd.none )

        FetchSuccessSemRemessa semRemessa ->
            ( { model | semRemessa = Just semRemessa }, Cmd.none )

        FetchSuccessFaturamento faturamento ->
            ( { model | faturamento = Just faturamento, refreshCount = 300 }, Cmd.none )

        FetchSuccessPaciente paciente ->
            ( { model | paciente = Just paciente }, Cmd.none )


setScale : Page -> Cmd Msg
setScale page =
    Task.perform (\_ -> Debug.crash "Oopss!!!") (Resize page) Window.size


resizeCmd : Model -> Size -> Cmd Msg -> ( Model, Cmd Msg )
resizeCmd model newSize cmd =
    let
        scale =
            (toFloat newSize.width) / 1200.0
    in
        ( { model | scale = scale, size = newSize }, cmd )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Window.resizes (Resize model.page)
        , Time.every Time.second TickTime
        , Time.every (5 * Time.minute) Refresh
        ]



-- FETCHS


fetchTempoMedio : Cmd Msg
fetchTempoMedio =
    getTempoMedio FetchFail FetchSuccessTempoMedio


fetchSemRemessa : Cmd Msg
fetchSemRemessa =
    getSemRemessa FetchFail FetchSuccessSemRemessa


fetchFaturamento : Cmd Msg
fetchFaturamento =
    getFaturamento FetchFail FetchSuccessFaturamento


fetchPacientes : Cmd Msg
fetchPacientes =
    getPacientes FetchFail FetchSuccessPaciente
