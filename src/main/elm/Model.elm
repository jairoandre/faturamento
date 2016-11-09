module Model exposing (..)


type alias Model =
    { title : String
    , date : String
    , version : String
    , items : List Item
    }


type alias Item =
    { convenio : String
    , quantidade : Int
    , percentual : Float
    , tempoMedio : Float
    }
