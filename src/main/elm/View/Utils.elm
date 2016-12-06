module View.Utils exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)


customDiv : String -> String -> Html a -> Html a
customDiv wrapperClass innerClass elem =
    div [ class wrapperClass ]
        [ div [ class innerClass ]
            [ elem ]
        ]


divLeftPadding : String -> Html a -> Html a
divLeftPadding wrapperClass elem =
    customDiv wrapperClass "row--inner--padding" elem


divRightPadding : String -> Html a -> Html a
divRightPadding wrapperClass elem =
    customDiv wrapperClass "row--inner--padding--right" elem
