module View.Paciente exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (..)
import Model.Paciente exposing (..)
import View.Utils exposing (updateCountdownText, divLeftPadding, divRightPadding, rowClass)


pacienteToHtml : Paciente -> Int -> Html a
pacienteToHtml p rCount =
    let
        items =
            List.drop (p.page * 10) p.items

        rows =
            List.indexedMap pacienteItemToHtml (List.take 10 items)
    in
        div [ class "list" ]
            [ div [ class "header" ]
                [ div [ class "header__title" ]
                    [ text "PACIENTES COM CONTAS ABERTAS A MAIS DE 60 DIAS"
                    , div [ class "rCount" ] [ text <| updateCountdownText rCount ]
                    ]
                , div [ class "header__columns" ]
                    [ divLeftPadding "header__column header__column--paciente--convenio" <| text "CONVÊNIO"
                    , divLeftPadding "header__column header__column--paciente--nome" <| text "NOME"
                    , divRightPadding "header__column header__column--paciente--atendimento" <| text "ATENDIMENTO"
                    , divRightPadding "header__column header__column--paciente--conta" <| text "CONTA"
                    , divRightPadding "header__column header__column--paciente--dias" <| text "DIAS"
                    , divRightPadding "header__column header__column--paciente--valorTotal" <| text "VALOR TOTAL"
                    ]
                ]
            , div [ class "content" ]
                rows
            ]


pacienteItemToHtml : Int -> PacienteItem -> Html a
pacienteItemToHtml idx item =
    let
        convenio =
            divLeftPadding "row row--paciente--convenio" <| text item.convenio

        paciente =
            divLeftPadding "row row--paciente--nome" <| text item.nome

        atendimento =
            divRightPadding "row row--paciente--atendimento" <| text (toString item.atendimento)

        conta =
            divRightPadding "row row--paciente--conta" <| text (toString item.conta)

        dias =
            divRightPadding "row row--paciente--dias" <| text (toString item.dias)

        valorTotal =
            divRightPadding "row row--paciente--valorTotal" <| text item.valorTotal
    in
        div [ class <| rowClass idx ]
            [ convenio
            , paciente
            , atendimento
            , conta
            , dias
            , valorTotal
            ]
