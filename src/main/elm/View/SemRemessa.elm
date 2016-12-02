module View.SemRemessa exposing (..)

import Html exposing (Html, div, text, img, span)
import Html.Attributes exposing (..)
import Model.SemRemessa exposing (..)
import View.Utils exposing (customDiv)


semRemessaToHtml : SemRemessa -> Html a
semRemessaToHtml semRemessa =
    let
        items =
            List.drop (semRemessa.page * 20) semRemessa.items

        rows =
            List.indexedMap semRemessaItemToHtml (List.take 20 items)
    in
        div [ class "list--wrapper list--wrapper--semRemessa" ]
            [ div [ class "header--wrapper" ]
                [ div [ class "header--wrapper--top" ]
                    [ div [ class "header--title header--title--semRemessa" ] [ text "CONTAS SEM REMESSA (MV)" ]
                    ]
                , div [ class "header--wrapper--bottom" ]
                    [ customDiv "header--column header--column--convenio" "header--inner" (text "CONVÊNIO")
                    , customDiv "header--column header--column--quantidade" "header--inner--right" (text "QTD.")
                    , customDiv "header--column header--column--media" "header--inner--right" (text "MÉDIA DIAS")
                    , customDiv "header--column header--column--mediaValor" "header--inner--right" (text "MÉDIA VALORES")
                    ]
                ]
            , div [ class "content--wrapper" ]
                rows
            ]


semRemessaItemToHtml : Int -> SemRemessaItem -> Html a
semRemessaItemToHtml idx item =
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
                [ div [ class "row--inner--padding" ] [ text item.convenio ] ]

        qtdSpan =
            span [ class ("span--padding span--padding--" ++ item.status) ] [ text <| toString <| item.quantidade ]

        quantidade =
            div [ class "cell cell--quantidade" ]
                [ div [ class "row--inner--padding--right" ] [ qtdSpan ] ]

        mediaDias =
            div [ class "cell cell--media" ]
                [ div [ class "row--inner--padding--right" ] [ text <| toString <| item.mediaDias ] ]

        mediaValor =
            div [ class "cell cell--mediaValor" ]
                [ div [ class "row--inner--padding--right" ] [ text <| item.mediaValor ] ]
    in
        div [ class rowClass ]
            [ convenio
            , quantidade
            , mediaDias
            , mediaValor
            ]
