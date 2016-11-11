module View.TempoMedio exposing (..)

import Html exposing (Html, div, text, img)
import Html.Attributes exposing (..)
import Model.TempoMedio exposing (..)
import View.Utils exposing (customDiv)


tempoMedioToHtml : TempoMedio -> Html a
tempoMedioToHtml tempoMedio =
    let
        rows =
            List.indexedMap tempoMedioItemToHtml (List.take 20 tempoMedio.items)
    in
        div [ class "app--wrapper" ]
            [ div [ class "header--wrapper" ]
                [ div [ class "header--wrapper--top" ]
                    [ div [ class "header--logo" ] [ img [ src "http://10.1.0.105:8080/painel/assets/imgs/logo.png" ] [] ]
                    , div [ class "header--title" ] [ text "TEMPO MÉDIO P/ CONV." ]
                    , div [ class "header--date" ] [ text tempoMedio.date ]
                    ]
                , div [ class "header--wrapper--bottom" ]
                    [ customDiv "header--column header--convenio" "header--inner" (text "CONVÊNIO")
                    , customDiv "header--column header--quantidade" "header--inner" (text "ABERTAS")
                    , customDiv "header--column header--media" "header--inner" (text "T. MÉDIO")
                    ]
                ]
            , div [ class "content--wrapper" ]
                rows
            ]


tempoMedioItemToHtml : Int -> TempoMedioItem -> Html a
tempoMedioItemToHtml idx item =
    let
        topClass =
            "row--wrapper--" ++ (toString idx)

        rowClass =
            if idx % 2 == 0 then
                "row--wrapper row--wrapper--zebra " ++ topClass
            else
                "row--wrapper " ++ topClass

        convenio =
            div [ class "cell cell--convenio" ]
                [ div [ class "row--inner--padding" ] [ text item.nome ] ]

        quantidade =
            div [ class "cell cell--quantidade" ]
                [ div [ class "row--inner--padding" ] [ text <| toString <| item.quantidade ] ]

        media =
            div [ class "cell cell--media" ]
                [ div [ class "row--inner--padding" ] [ text <| toString <| item.media ] ]
    in
        div [ class rowClass ]
            [ convenio
            , quantidade
            , media
            ]
