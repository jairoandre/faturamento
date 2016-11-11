module Main exposing (..)

import Html exposing (Html, div, text, img)
import Html.Attributes exposing (class, style, src)
import UrlParser exposing (Parser, (</>), format, int, oneOf, s, string)
import Time exposing (Time)
import Window exposing (Size)
import Model.TempoMedio exposing (..)
import View.TempoMedio exposing (..)
import Api.TempoMedio exposing (getTempoMedio)
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
    , tempoMedio : Maybe TempoMedio
    , scale : Float
    , size : Window.Size
    , tick : Int
    }


type Page
    = Home
    | Faturamento


type Msg
    = Resize Page Size
    | TickTime Time
    | FetchFail Http.Error
    | FetchSuccessTempoMedio TempoMedio


init : Result String Page -> ( Model, Cmd Msg )
init result =
    let
        t =
            Debug.log (toString result) 0
    in
        urlUpdate result (Model Home Nothing 1 { width = 0, height = 0 } 0)


urlUpdate : Result String Page -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    case result of
        Err _ ->
            ( model, Navigation.modifyUrl (toUrl model.page) )

        Ok (Home as page) ->
            ( { model | page = Home }, setScale Home )

        Ok (Faturamento as page) ->
            ( { model | page = Faturamento }, setScale Faturamento )


toUrl : Page -> String
toUrl page =
    case page of
        Home ->
            "#home"

        Faturamento ->
            "#fat"


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
        , format Faturamento (s "fat")
        ]



-- VIEW


view : Model -> Html Msg
view model =
    let
        content =
            case model.page of
                Home ->
                    text ("Redirecionando em " ++ (toString (3 - model.tick)) ++ "...")

                Faturamento ->
                    case model.tempoMedio of
                        Nothing ->
                            text "Carregando..."

                        Just tm ->
                            tempoMedioToHtml tm
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

                Faturamento ->
                    resizeCmd model newSize fetchTempoMedio

        TickTime newTime ->
            case model.page of
                Home ->
                    if model.tick < 2 then
                        ( { model | tick = model.tick + 1 }, Cmd.none )
                    else
                        ( { model | tick = 0, page = Faturamento }, Navigation.newUrl (toUrl Faturamento) )

                Faturamento ->
                    ( model, Cmd.none )

        FetchFail e ->
            let
                t =
                    Debug.log (toString e) 0
            in
                ( model, Cmd.none )

        FetchSuccessTempoMedio tempoMedio ->
            ( { model | tempoMedio = Just tempoMedio }, Cmd.none )


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
        ]



-- FETCHS


fetchTempoMedio : Cmd Msg
fetchTempoMedio =
    getTempoMedio FetchFail FetchSuccessTempoMedio
