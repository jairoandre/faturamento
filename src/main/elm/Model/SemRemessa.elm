module Model.SemRemessa exposing (SemRemessa, SemRemessaItem, semRemessaDecoder)

import Json.Decode exposing (Decoder, int, float, string, list)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional)


type alias SemRemessa =
    { date : String
    , version : String
    , items : List SemRemessaItem
    , page : Int
    , timer : Int
    }


semRemessaDecoder : Decoder SemRemessa
semRemessaDecoder =
    decode SemRemessa
        |> optional "date" string ""
        |> optional "version" string ""
        |> optional "items" (list semRemessaItemDecoder) []
        |> hardcoded 0
        |> hardcoded 0


type alias SemRemessaItem =
    { convenio : String
    , status : String
    , quantidade : Int
    , mediaDias : Int
    , mediaValor : String
    }


semRemessaItemDecoder : Decoder SemRemessaItem
semRemessaItemDecoder =
    decode SemRemessaItem
        |> optional "convenio" string ""
        |> optional "status" string ""
        |> optional "quantidade" int 0
        |> optional "mediaDias" int -1
        |> optional "mediaValor" string "R$ 0,00"
