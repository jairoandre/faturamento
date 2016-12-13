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
    customDiv wrapperClass "lPadd" elem


divRightPadding : String -> Html a -> Html a
divRightPadding wrapperClass elem =
    customDiv wrapperClass "rPadd" elem


updateCountdownText : Int -> String
updateCountdownText rCount =
    if rCount < 0 then
        "Carregando..."
    else
        "Próxima atualização em " ++ (toString rCount) ++ "s."


rowClass : Int -> String
rowClass idx =
    let
        topClass =
            "row--" ++ (toString idx)
    in
        if idx % 2 == 0 then
            "row--wrapper row--zebra " ++ topClass
        else
            "row--wrapper " ++ topClass
