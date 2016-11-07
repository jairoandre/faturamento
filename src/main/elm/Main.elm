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
import Time exposing (Time)


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
    , count : Int
    , scale : Float
    , hue : Float
    , size : Window.Size
    }


type Page
    = Home
    | Faturamento


type Msg
    = Resize Size
    | TickHue Time


init : Result String Page -> ( Model, Cmd Msg )
init result =
    let
        t =
            Debug.log (toString result) 0
    in
        urlUpdate result (Model Home 0 1 0 { width = 0, height = 0 })


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


faturamentoRow : Int -> Int -> Html Msg
faturamentoRow idx elem =
    let
        topClass =
            "row--wrapper--" ++ (toString idx)

        rowClass =
            if idx % 2 == 0 then
                "row--wrapper row--wrapper--zebra " ++ topClass
            else
                "row--wrapper " ++ topClass
    in
        div [ class rowClass ] [ text <| toString <| elem ]


faturamentoView : Model -> Html Msg
faturamentoView model =
    let
        rows =
            List.indexedMap faturamentoRow [0..11]
    in
        div [ class "app--wrapper" ]
            [ div [ class "header--wrapper" ]
                [ div [ class "header--wrapper--top" ]
                    [ div [ class "header--logo" ] [ img [ src "http://10.1.0.105:8080/painel/assets/imgs/logo.png" ] [] ]
                    , div [ class "header--title" ] [ text "TÍTULO" ]
                    , div [ class "header--date" ] [ text "07/11/2016" ]
                    ]
                , div [ class "header--wrapper--bottom" ]
                    [ div [ class "header--column header--convenio" ] [ text "CONVÊNIO" ]
                    , div [ class "header--column header--quantidade" ] [ text "QTD." ]
                    ]
                ]
            , div [ class "content--wrapper" ]
                rows
            ]


view : Model -> Html Msg
view model =
    let
        v =
            case model.page of
                Home ->
                    text (toString model.size)

                Faturamento ->
                    faturamentoView model

        hsl =
            (toString <| ceiling <| model.hue) ++ ", 100%, 50%"
    in
        div
            [ class "app--wrapper"
            , style
                [ ( "transform", "scale(" ++ (toString model.scale) ++ ")" )
                ]
            ]
            [ v ]


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Resize newSize ->
            resizeCmd model newSize Cmd.none

        TickHue newTime ->
            let
                newHue =
                    if model.hue < 360 then
                        model.hue + 1
                    else
                        0
            in
                ( { model | hue = newHue }, Cmd.none )


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
