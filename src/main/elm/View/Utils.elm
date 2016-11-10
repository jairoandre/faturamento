module View.Utils exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)


customDiv : String -> String -> Html a -> Html a
customDiv wrapperClass innerClass elem =
    div [ class wrapperClass ]
        [ div [ class innerClass ]
            [ elem ]
        ]
