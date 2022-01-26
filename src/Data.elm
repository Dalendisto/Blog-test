module Data exposing (..)

import DataSource exposing (DataSeource)
import DataSource.Http 
import Pages.Secrets as Secrets
import OptimizedDecoder as Dec


apiUrl : String 
apiUrl =
    "https://jsonplaceholder.typicode.com/users"


type alias Person =
    { name : String
    , email : String
    , website : String 
    }


personDecoder : DecDecoder Person 
personDecoder =
    Dec.map3 Person 
        (Dec.field "name" Dec.string)
        (Dec.field "email" Dec.string)
        (Dec.field "website" Dec.string)


people : DataSource (List Person)
people =
    Decode.list personDecoder
        |> DataSource.Http.get (Secrets.succeed apiUrl)
        
