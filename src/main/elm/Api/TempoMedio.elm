module Api.TempoMedio exposing (..)

import Model.TempoMedio exposing (TempoMedio, tempoMedioDecoder)
import Task
import Http


apiHost : String
apiHost =
    if False then
        "http://localhost:8080/faturamento/"
    else
        ""


getTempoMedio : (Http.Error -> a) -> (TempoMedio -> a) -> Cmd a
getTempoMedio error success =
    Task.perform error success (Http.get tempoMedioDecoder (apiHost ++ "rest/api/tempoMedio"))
