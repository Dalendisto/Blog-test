module View exposing (View, map, placeholder)

import Element as Elem
import Html exposing (Html)


type alias View msg =
    { title : String
    , body : Elem.Element msg
    }


map : (msg1 -> msg2) -> View msg1 -> View msg2
map fn doc =
    { title = doc.title
    , body = Elem.map fn doc.body
    }


placeholder : String -> View msg
placeholder moduleName =
    { title = "Placeholder - " ++ moduleName
    , body =
        Elem.column [] []
    }
