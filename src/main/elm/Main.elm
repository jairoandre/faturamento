module Main exposing (..)

import Html exposing (Html, div, text, img)
import Html.Attributes exposing (class, style, src)
import UrlParser exposing (Parser, (</>), format, int, oneOf, s, string)
import Window exposing (Size)
import Task
import String
import Window
import Navigation
import Debug
import Model.TempoMedio exposing (..)
import View.TempoMedio exposing (..)


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
    }


type Page
    = Home
    | Faturamento


type Msg
    = Resize Size


init : Result String Page -> ( Model, Cmd Msg )
init result =
    let
        t =
            Debug.log (toString result) 0
    in
        urlUpdate result (Model Home (Just mockTempoMedio) 1 { width = 0, height = 0 })


urlUpdate : Result String Page -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    case result of
        Err _ ->
            ( model, Navigation.modifyUrl (toUrl model.page) )

        Ok (Home as page) ->
            ( { model | page = Home }, setScale )

        Ok (Faturamento as page) ->
            ( { model | page = Faturamento }, setScale )


toUrl : Page -> String
toUrl page =
    case page of
        Home ->
            "#home"

        Faturamento ->
            "#faturamento"


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
        , format Faturamento (s "faturamento")
        ]


view : Model -> Html Msg
view model =
    let
        content =
            case model.page of
                Home ->
                    text (toString model.size)

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


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Resize newSize ->
            resizeCmd model newSize Cmd.none


setScale : Cmd Msg
setScale =
    Task.perform (\_ -> Debug.crash "Oopss!!!") Resize Window.size


resizeCmd : Model -> Size -> Cmd Msg -> ( Model, Cmd Msg )
resizeCmd model newSize cmd =
    let
        scale =
            (toFloat newSize.width) / 1200.0
    in
        ( { model | scale = scale, size = newSize }, cmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Window.resizes Resize
        ]
