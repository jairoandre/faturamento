module Api.SemRemessa exposing (..)

import Model.SemRemessa exposing (SemRemessa, semRemessaDecoder)
import Task
import Http


apiHost : String
apiHost =
    if False then
        "http://localhost:8080/faturamento/"
    else
        ""


getSemRemessa : (Http.Error -> a) -> (SemRemessa -> a) -> Cmd a
getSemRemessa error success =
    Task.perform error success (Http.get semRemessaDecoder (apiHost ++ "rest/api/semRemessa"))
