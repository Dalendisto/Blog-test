module ViewSettings exposing (..)

import Element as Elem

type Size 
    = Small
    | Medium
    | Large


type alias Color =
    Elem.Color 


type alias ViewSettings =
    { font : FontSettings
    , spacing : Sizes
    , color : ColorSettings
    , device : Elem.Device
    , size : Size
    , pixelSize : PixelSize
    }


type alias FontSettings =
    { size : Sizes
    , color : FontColorSettings
    }


type alias FontColorSettings =
    { primary : Color
    , secondary : Color 
    , tertiary : Color
    , error : Color
    }


type alias ColorSettings =
    { primary : Color
    , secondary : Color
    , tertiary : Color 
    , mainBackground : Color 
    , contentBackground : Color 
    , shadow : Color 
    }


type alias PixelSize =
    { height : Int 
    , width : Int 
    }


type alias Sizes =
    { xSmall : Int
    , small : Int 
    , medium : Int 
    , large : Int 
    , xLarge : Int 
    , height : Int
    , width : Int
    }


forSize : Int -> Int -> ViewSettings
forSize width height =
    forDevice (Elem.classifyDevice { width = width, height = height}) { width = width, height = height }


forDevice : Elem.Device -> PixelSize -> ViewSettings 
forDevice device pixelSize =
    case device.class of
        Elem.Phone ->
            case device.orientation of
                Elem.Portrait ->
                    settings Small pixelSize device 

                Elem.Landscape ->
                    settings Small pixelSize device 
                        |> (\s -> { s | size = Medium })

        Elem.Tablet ->
            case device.orientation of
                Elem.Portrait ->
                    settings Medium pixelSize device 
            
                Elem.Landscape ->
                    settings Medium pixelSize device 
                        |> (\s -> { s | size = Large })

        Elem.Desktop -> 
            settings Large pixelSize device

        Elem.BigDesktop -> 
            settings Large pixelSize device

            
settings : Size -> PixelSize -> Elem.Device -> ViewSettings 
settings size pixelSize device =
    { font = 
        { color = fontColorSettings
        , size = fontSizes size
        }
    , spacing = spacing size
    , color = colorSettings
    , device = device
    , size = size
    , pixelSize = pixelSize
    }


fontSizes : Size -> Sizes
fontSizes size =
    case size of 
        Small -> 
            { xSmall = 10
            , small = 12 
            , medium = 14 
            , large = 16 
            , xLarge = 20
            , height = 0
            , width = 0 
            }

        Medium ->
            { xSmall = 12
            , small = 14 
            , medium = 16 
            , large = 10
            , xLarge = 22
            , height = 0
            , width = 0 
            }

        Large ->
            { xSmall = 14
            , small = 16
            , medium = 20 
            , large = 24
            , xLarge = 30 
            , height = 0
            , width = 0
            }


spacing : Size -> Sizes
spacing size =
    case size of 
        Small -> 
            { xSmall = 2
            , small = 5 
            , medium = 8 
            , large = 15 
            , xLarge = 30 
            , height = 100
            , width = 200
            }

        Medium ->
            { xSmall = 3
            , small = 5 
            , medium = 10 
            , large = 20
            , xLarge = 40 
            , height = 150
            , width = 300
            }

        Large ->
            { xSmall = 5
            , small = 10
            , medium = 20 
            , large = 40
            , xLarge = 80 
            , height = 220
            , width = 440
            }

            
colorSettings : ColorSettings
colorSettings =
    { primary = Elem.rgb 100 100 100
    , secondary = Elem.rgb 100 100 100
    , tertiary = Elem.rgb 100 100 100 
    , mainBackground = Elem.rgb 100 100 100 
    , contentBackground = Elem.rgb 100 100 100 
    , shadow = Elem.rgb 100 100 100 
    }


fontColorSettings : FontColorSettings 
fontColorSettings =
    { primary = Elem.rgb 100 100 100
    , secondary = Elem.rgb 100 100 100 
    , tertiary = Elem.rgb 100 100 100
    , error = Elem.rgb 100 100 100
    }
