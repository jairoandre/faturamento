module Model.TempoMedio exposing (TempoMedio, TempoMedioItem, tempoMedioDecoder, mockTempoMedio)

import Json.Decode exposing (Decoder, int, string, list)
import Json.Decode.Pipeline exposing (decode, optional)


type alias TempoMedio =
    { date : String
    , version : String
    , items : List TempoMedioItem
    }


tempoMedioDecoder : Decoder TempoMedio
tempoMedioDecoder =
    decode TempoMedio
        |> optional "date" string ""
        |> optional "version" string ""
        |> optional "items" (list tempoMedioItemDecoder) []


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
        |> optional "media" int -1


mockTempoMedio : TempoMedio
mockTempoMedio =
    { date = "10/11/2016"
    , version = "0.0.1"
    , items = mockList
    }


mockList : List TempoMedioItem
mockList =
    List.map mockItem [1..20]


mockItem : Int -> TempoMedioItem
mockItem n =
    { nome = "Convênio " ++ (toString n)
    , quantidade = n * 2
    , media = n * 3
    }
