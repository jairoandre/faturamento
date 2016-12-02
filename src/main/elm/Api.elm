module Api exposing (..)

import Model.TempoMedio exposing (SetorTempoMedio, setorTempoMedioDecoder)
import Model.SemRemessa exposing (SemRemessa, semRemessaDecoder)
import Task
import Http


apiHost : String
apiHost =
    if False then
        "http://10.1.8.118:8080/faturamento/"
    else
        ""


getTempoMedio : (Http.Error -> a) -> (SetorTempoMedio -> a) -> Cmd a
getTempoMedio error success =
    Task.perform error success (Http.get setorTempoMedioDecoder (apiHost ++ "rest/api/tempoMedio"))


getSemRemessa : (Http.Error -> a) -> (SemRemessa -> a) -> Cmd a
getSemRemessa error success =
    Task.perform error success (Http.get semRemessaDecoder (apiHost ++ "rest/api/semRemessa"))
