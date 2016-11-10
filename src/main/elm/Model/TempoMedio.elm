module Model.TempoMedio exposing (TempoMedio, TempoMedioItem, mockTempoMedio)


type alias TempoMedio =
    { date : String
    , version : String
    , items : List TempoMedioItem
    }


type alias TempoMedioItem =
    { nome : String
    , quantidade : Int
    , media : Int
    }


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
