module View.Faturamento exposing (faturamentoHtml)

import Html exposing (Html, div, text, img)
import Html.Attributes exposing (..)
import Model.Faturamento exposing (..)
import View.Utils exposing (customDiv, divLeftPadding, divRightPadding)
import Array


faturamentoHtml : Faturamento -> Int -> Html a
faturamentoHtml obj rCount =
    case (Array.get obj.index (Array.fromList obj.items)) of
        Just faturamentoGrupo ->
            faturamentoGrupoToHtml faturamentoGrupo rCount

        Nothing ->
            div [] [ text "Carregando..." ]


faturamentoGrupoToHtml : FaturamentoGrupo -> Int -> Html a
faturamentoGrupoToHtml faturamentoGrupo rCount =
    let
        items =
            List.drop (faturamentoGrupo.page * 10) faturamentoGrupo.items

        rows =
            List.indexedMap faturamentoItemToHtml (List.take 10 items)

        rText =
            if rCount < 0 then
                "Carregando..."
            else
                "Próxima atualização em " ++ (toString rCount) ++ "s."
    in
        div [ class "list" ]
            [ div [ class "header" ]
                [ div [ class "header__title" ]
                    [ text faturamentoGrupo.title
                    , div [ class "rCount" ] [ text rText ]
                    ]
                , div [ class "header__columns" ]
                    [ divLeftPadding "header__column header__column--convenio" <| text "CONVÊNIO"
                    , divRightPadding "header__column header__column--ge30" <| text "CONTAS ABERTAS >= 30 DIAS"
                    , divRightPadding "header__column header__column--t25 header__column--ge30 header__column--ge30Qtd" <| text "QTD"
                    , divRightPadding "header__column header__column--t25 header__column--ge30 header__column--ge30DaysAvg" <| text "MÉD. DIAS"
                    , divRightPadding "header__column header__column--t25 header__column--ge30 header__column--ge30ValueAvg" <| text "MÉD. VALOR"
                    , divRightPadding "header__column header__column--lt30 header__column--lt30Title" <| text "CONTAS ABERTAS < 30 DIAS"
                    , divRightPadding "header__column header__column--t25 header__column--lt30 header__column--lt30Qtd" <| text "QTD"
                    , divRightPadding "header__column header__column--t25 header__column--lt30 header__column--lt30DaysAvg" <| text "MÉD. DIAS"
                    , divRightPadding "header__column header__column--t25 header__column--lt30 header__column--lt30ValueAvg" <| text "MÉD. VALOR"
                    , divRightPadding "header__column header__column--pendentes" <| text "GUIAS PENDENTES"
                    , divRightPadding "header__column header__column--t25 header__column--pendentes header__column--qtdPendentes" <| text "QTD"
                    , divRightPadding "header__column header__column--t25 header__column--pendentes header__column--avgPendentes" <| text "MÉD. DIAS"
                    ]
                ]
            , div [ class "content" ]
                rows
            ]


cellFaturamentoInt : String -> Int -> Html a
cellFaturamentoInt f n =
    divRightPadding f <| text <| toString <| n


faturamentoItemToHtml : Int -> FaturamentoItem -> Html a
faturamentoItemToHtml idx item =
    let
        topClass =
            "row--" ++ (toString idx)

        rowClass =
            if idx % 2 == 0 then
                "row--wrapper row--zebra " ++ topClass
            else
                "row--wrapper " ++ topClass

        convenio =
            divLeftPadding "row row--convenio" <| text item.convenio

        pendentes =
            cellFaturamentoInt "row row--qtdPendentes" item.pendentes

        daysAvg =
            cellFaturamentoInt "row row--avgPendentes" item.daysAvg

        ge30 =
            cellFaturamentoInt "row row--ge30Qtd" item.ge30

        lt30 =
            cellFaturamentoInt "row row--lt30Qtd" item.lt30

        ge30Avg =
            cellFaturamentoInt "row row--ge30DaysAvg" item.ge30Avg

        lt30Avg =
            cellFaturamentoInt "row row--lt30DaysAvg" item.lt30Avg

        ge30ValueAvg =
            divRightPadding "row row--ge30ValueAvg" <| text item.ge30ValueAvg

        lt30ValueAvg =
            divRightPadding "row row--lt30ValueAvg" <| text item.lt30ValueAvg
    in
        div [ class rowClass ]
            [ convenio
            , ge30
            , ge30Avg
            , ge30ValueAvg
            , lt30
            , lt30Avg
            , lt30ValueAvg
            , pendentes
            , daysAvg
            ]
