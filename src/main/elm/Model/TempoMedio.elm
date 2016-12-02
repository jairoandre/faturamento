module Model.TempoMedio exposing (SetorTempoMedio, TempoMedio, TempoMedioItem, setorTempoMedioDecoder)

import Json.Decode exposing (Decoder, int, string, list)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional)


type alias SetorTempoMedio =
    { date : String
    , version : String
    , items : List TempoMedio
    , index : Int
    }


setorTempoMedioDecoder : Decoder SetorTempoMedio
setorTempoMedioDecoder =
    decode SetorTempoMedio
        |> optional "date" string ""
        |> optional "version" string ""
        |> optional "items" (list tempoMedioDecoder) []
        |> hardcoded 0


type alias TempoMedio =
    { title : String
    , items : List TempoMedioItem
    , page : Int
    , timer : Int
    , cycles : Int
    }


tempoMedioDecoder : Decoder TempoMedio
tempoMedioDecoder =
    decode TempoMedio
        |> optional "title" string ""
        |> optional "items" (list tempoMedioItemDecoder) []
        |> hardcoded 0
        |> hardcoded 0
        |> hardcoded 0


type alias TempoMedioItem =
    { nome : String
    , quantidade : Int
    , media : Int
    }


tempoMedioItemDecoder : Decoder TempoMedioItem
tempoMedioItemDecoder =
    decode TempoMedioItem
        |> optional "nome" string ""
        |> optional "quantidade" int 0
        |> optional "media" int 0
