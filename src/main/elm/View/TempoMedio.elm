module View.TempoMedio exposing (setorTempoMedioToHtml)

import Html exposing (Html, div, text, img)
import Html.Attributes exposing (..)
import Model.TempoMedio exposing (..)
import View.Utils exposing (customDiv)
import Array


setorTempoMedioToHtml : SetorTempoMedio -> Html a
setorTempoMedioToHtml obj =
    case (Array.get obj.index (Array.fromList obj.items)) of
        Just tempoMedio ->
            tempoMedioToHtml tempoMedio

        Nothing ->
            div [] [ text "Carregando..." ]


tempoMedioToHtml : TempoMedio -> Html a
tempoMedioToHtml tempoMedio =
    let
        items =
            List.drop (tempoMedio.page * 20) tempoMedio.items

        rows =
            List.indexedMap tempoMedioItemToHtml (List.take 20 items)
    in
        div [ class "list--wrapper list--wrapper--tempoMedio" ]
            [ div [ class "header--wrapper" ]
                [ div [ class "header--wrapper--top" ]
                    [ div [ class "header--title header--title--tempoMedio" ] [ text <| "GUIAS SEM RESPOSTA - " ++ tempoMedio.title ]
                    ]
                , div [ class "header--wrapper--bottom" ]
                    [ customDiv "header--column header--column--convenio" "header--inner" (text "CONVÊNIO")
                    , customDiv "header--column header--column--quantidade" "header--inner--right" (text "QTD.")
                    , customDiv "header--column header--column--media" "header--inner--right" (text "MÉDIA DIAS")
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
                [ div [ class "row--inner--padding--right" ] [ text <| toString <| item.quantidade ] ]

        media =
            div [ class "cell cell--media" ]
                [ div [ class "row--inner--padding--right" ] [ text <| toString <| item.media ] ]
    in
        div [ class rowClass ]
            [ convenio
            , quantidade
            , media
            ]
