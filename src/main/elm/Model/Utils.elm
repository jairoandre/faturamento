module Model.Utils exposing (tickTimer)


type alias Scrollable a b =
    { a
        | items : List b
        , page : Int
        , timer : Int
    }


tickTimer : Scrollable a b -> Int -> Int -> Scrollable a b
tickTimer obj maxTimer maxItems =
    if obj.timer >= maxTimer then
        let
            itemsLen =
                List.length obj.items

            lastPage =
                (itemsLen // maxItems) - 1

            newPage =
                if obj.page == lastPage then
                    0
                else
                    obj.page + 1
        in
            { obj | timer = 0, page = newPage }
    else
        { obj | timer = obj.timer + 1 }
