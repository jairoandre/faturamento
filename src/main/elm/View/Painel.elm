module View.Painel exposing (painelToHtml)

import Html exposing (Html, div, text, img)
import Html.Attributes exposing (..)
import Model.Faturamento exposing (..)
import View.Utils exposing (customDiv, divLeftPadding, divRightPadding)
import Array


painelToHtml : Faturamento -> Html a
painelToHtml obj =
    case (Array.get obj.index (Array.fromList obj.items)) of
        Just faturamentoGrupo ->
            faturamentoGrupoToHtml faturamentoGrupo

        Nothing ->
            div [] [ text "Carregando..." ]


faturamentoGrupoToHtml : FaturamentoGrupo -> Html a
faturamentoGrupoToHtml faturamentoGrupo =
    let
        items =
            List.drop (faturamentoGrupo.page * 10) faturamentoGrupo.items

        rows =
            List.indexedMap faturamentoItemToHtml (List.take 10 items)
    in
        div [ class "list--wrapper list--wrapper--faturamento" ]
            [ div [ class "header--wrapper" ]
                [ div [ class "header--wrapper--top" ]
                    [ div [ class "header--title header--title--faturamento" ] [ text <| faturamentoGrupo.title ]
                    ]
                , div [ class "header--wrapper--bottom" ]
                    [ div [ class "header--column--faturamento header--column--faturamento--situacao" ]
                        [ divLeftPadding "header--maintitle header--fat--sit--title" <| text "SITUAÇÃO REMESSAS (MV)"
                        , divRightPadding "header--subtitle header--fat--sit--faixa" <| text "FAIXA"
                        , divRightPadding "header--subtitle header--fat--sit--qtd" <| text "QTD"
                        , divRightPadding "header--subtitle header--fat--sit--daysAvg" <| text "MÉDIA DIAS"
                        , divRightPadding "header--subtitle header--fat--sit--valueAvg" <| text "MÉDIA VALOR"
                        ]
                    , div [ class "header--column--faturamento header--column--faturamento--pendentes" ]
                        [ divRightPadding "header--titleh2 header--fat--pend--title" <| text "PENDENTES"
                        , divRightPadding "header--titleh2 header--fat--pend--resp" <| text "MÉDIA RESP."
                        ]
                    ]
                ]
            , div [ class "content--wrapper" ]
                rows
            ]


cellFaturamentoInt : String -> Int -> Html a
cellFaturamentoInt f n =
    divRightPadding ("cell cell--faturamento--" ++ f) <| text <| toString <| n


faturamentoItemToHtml : Int -> FaturamentoItem -> Html a
faturamentoItemToHtml idx item =
    let
        topClass =
            "row--wrapper--faturamento row--wrapper--faturamento--" ++ (toString idx)

        rowClass =
            if idx % 2 == 0 then
                "row--wrapper row--wrapper--zebra " ++ topClass
            else
                "row--wrapper " ++ topClass

        convenio =
            divLeftPadding "cell cell--faturamento--convenio" <| text item.convenio

        pendentes =
            cellFaturamentoInt "pendentes" item.pendentes

        daysAvg =
            cellFaturamentoInt "daysAvg" item.daysAvg

        ge30label =
            divRightPadding "cell cell--faturamento--sitLabel" <| text ">= 30 dias"

        lt30label =
            divRightPadding "cell cell--faturamento--sitLabel" <| text "< 30 dias"

        ge30 =
            cellFaturamentoInt "sitDays" item.ge30

        lt30 =
            cellFaturamentoInt "sitDays" item.lt30

        ge30Avg =
            cellFaturamentoInt "sitDaysAvg" item.ge30Avg

        lt30Avg =
            cellFaturamentoInt "sitDaysAvg" item.lt30Avg

        ge30ValueAvg =
            divRightPadding "cell cell--faturamento--sitValueAvg" <| text item.ge30ValueAvg

        lt30ValueAvg =
            divRightPadding "cell cell--faturamento--sitValueAvg" <| text item.lt30ValueAvg
    in
        div [ class rowClass ]
            [ div [ class "cell--wrapper--faturamento--situacao" ]
                [ convenio
                , div [ class "div--wrapper--ge30" ]
                    [ ge30label
                    , ge30
                    , ge30Avg
                    , ge30ValueAvg
                    ]
                , div [ class "div--wrapper--lt30" ]
                    [ lt30label
                    , lt30
                    , lt30Avg
                    , lt30ValueAvg
                    ]
                ]
            , div [ class "cell--wrapper--faturamento--pendentes" ]
                [ pendentes
                , daysAvg
                ]
            ]
