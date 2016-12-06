module Model.Faturamento exposing (Faturamento, FaturamentoGrupo, FaturamentoItem, faturamentoDecoder)

import Json.Decode exposing (Decoder, int, float, string, list)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional)


type alias Faturamento =
    { date : String
    , version : String
    , items : List FaturamentoGrupo
    , index : Int
    }


faturamentoDecoder : Decoder Faturamento
faturamentoDecoder =
    decode Faturamento
        |> optional "date" string ""
        |> optional "version" string ""
        |> optional "items" (list faturamentoGrupoDecoder) []
        |> hardcoded 0


type alias FaturamentoGrupo =
    { title : String
    , items : List FaturamentoItem
    , page : Int
    , timer : Int
    , cycles : Int
    }


faturamentoGrupoDecoder : Decoder FaturamentoGrupo
faturamentoGrupoDecoder =
    decode FaturamentoGrupo
        |> optional "title" string ""
        |> optional "items" (list faturamentoItemDecoder) []
        |> hardcoded 0
        |> hardcoded 0
        |> hardcoded 0


type alias FaturamentoItem =
    { convenio : String
    , pendentes : Int
    , daysAvg : Int
    , ge30 : Int
    , lt30 : Int
    , ge30Avg : Int
    , lt30Avg : Int
    , ge30ValueAvg : String
    , lt30ValueAvg : String
    }


faturamentoItemDecoder : Decoder FaturamentoItem
faturamentoItemDecoder =
    decode FaturamentoItem
        |> optional "convenio" string ""
        |> optional "pendentes" int 0
        |> optional "daysAvg" int 0
        |> optional "ge30" int 0
        |> optional "lt30" int 0
        |> optional "ge30Avg" int 0
        |> optional "lt30Avg" int 0
        |> optional "ge30ValueAvg" string ""
        |> optional "lt30ValueAvg" string ""
