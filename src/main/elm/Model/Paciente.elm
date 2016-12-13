module Model.Paciente exposing (Paciente, PacienteItem, pacienteDecoder)

import Json.Decode exposing (Decoder, int, string, list)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional)


type alias Paciente =
    { date : String
    , version : String
    , items : List PacienteItem
    , page : Int
    , timer : Int
    , cycles : Int
    }


type alias PacienteItem =
    { nome : String
    , atendimento : Int
    , conta : Int
    , convenio : String
    , dias : Int
    , valorTotal : String
    }


pacienteDecoder : Decoder Paciente
pacienteDecoder =
    decode Paciente
        |> optional "date" string ""
        |> optional "version" string ""
        |> optional "items" (list pacienteItemDecoder) []
        |> hardcoded 0
        |> hardcoded 0
        |> hardcoded 0


pacienteItemDecoder : Decoder PacienteItem
pacienteItemDecoder =
    decode PacienteItem
        |> optional "nome" string ""
        |> optional "atendimento" int 0
        |> optional "conta" int 0
        |> optional "convenio" string ""
        |> optional "dias" int 0
        |> optional "valorTotal" string "R$ 0,00"
