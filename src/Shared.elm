module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Dom
import Browser.Events
import Browser.Navigation
import DataSource
import Element as Elem
import Element.Background as Background 
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import ViewSettings exposing (ViewSettings)
import View exposing (View)
import Task


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg
    | SizeChange Int Int


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { showMobileMenu : Bool
    , viewSettings : ViewSettings
    }


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init navigationKey flags maybePagePath =
    ( { showMobileMenu = False 
      , viewSettings = ViewSettings.forSize 1920 1080
      }
    , Task.perform 
        (\viewport -> 
            SizeChange (round viewport.scene.height) (round viewport.scene.width)
        )
        Browser.Dom.getViewport
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( { model | showMobileMenu = False }, Cmd.none )

        SharedMsg globalMsg ->
            ( model, Cmd.none )

        SizeChange w h ->
            ({ model | viewSettings = ViewSettings.forSize w h }, Cmd.none)


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Browser.Events.onResize SizeChange
    


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


view :
    Data
    ->
        { path : Path
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html msg, title : String }
view sharedData page model toMsg pageView =
    { title = pageView.title
    , body = 
        Elem.layout
            [ Elem.width Elem.fill
            , Elem.height Elem.fill
            ]
        <| 
            Elem.column 
                [ Elem.width Elem.fill
                , Elem.height Elem.fill
                ]
                [ pageView.body 
                ]
    }
