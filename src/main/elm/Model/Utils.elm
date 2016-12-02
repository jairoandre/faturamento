module Model.Utils exposing (tickTimer, tickScrollableBag)

import Array


type alias Scrollable a b =
    { a
        | items : List b
        , page : Int
        , timer : Int
        , cycles : Int
    }


type alias ScrollableBag a b c =
    { a
        | items : List (Scrollable b c)
        , index : Int
    }


tickScrollableBag : ScrollableBag a b c -> Int -> Int -> ScrollableBag a b c
tickScrollableBag obj maxTimer maxItems =
    let
        itemsArray =
            Array.fromList obj.items

        itemsLength =
            Array.length itemsArray
    in
        case (Array.get obj.index itemsArray) of
            Just item ->
                let
                    currItemCycles =
                        item.cycles

                    itemsHead =
                        List.take obj.index obj.items

                    itemsTail =
                        List.drop (obj.index + 1) obj.items

                    tickedItem =
                        tickTimer item maxTimer maxItems

                    afterItemCycles =
                        tickedItem.cycles

                    newItems =
                        itemsHead ++ [ tickedItem ] ++ itemsTail

                    newIndex =
                        if currItemCycles == afterItemCycles then
                            obj.index
                        else
                            (obj.index + 1) % itemsLength
                in
                    { obj | items = newItems, index = newIndex }

            Nothing ->
                obj


tickTimer : Scrollable a b -> Int -> Int -> Scrollable a b
tickTimer obj maxTimer maxItems =
    if obj.timer >= maxTimer then
        let
            itemsLen =
                List.length obj.items

            lastPage =
                (itemsLen // (maxItems + 1))

            ( newPage, cycles ) =
                if obj.page == lastPage then
                    ( 0, obj.cycles + 1 )
                else
                    ( obj.page + 1, obj.cycles )
        in
            { obj | timer = 0, cycles = cycles, page = newPage }
    else
        { obj | timer = obj.timer + 1 }
