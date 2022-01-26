module Page.Repofiles.Name_ exposing (Model, Msg, Data, page)

import DataSource exposing (DataSource)
import Element as Elem
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Head
import Head.Seo as Seo
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import RepoFiles
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never

type alias RouteParams =
    { name : String }

page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    RepoFiles.myFiles
        |> DataSource.map (List.map (\repo -> {name = repo.slug}))
   -- DataSource.succeed
   --     [ { name = "Cars" }
   --     , { name = "Fruits" }
   --     , { name = "Notes" }
   --     , { name = "People" }
   --     ]


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.map2 Data
        (RepoFiles.getFileContent routeParams.name)
        (RepoFiles.getSingleFm routeParams.name)
    --DataSource.succeed ()



head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    { content : RepoFiles.Content Msg        
    , metadata : RepoFiles.FileFm
    }
    --RepoFiles.Content Msg --()


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "RepoFiles"
    , body = 
        Elem.column
            [ Elem.centerX
            , Elem.padding 50
            --, Background.image static.data.metadata.image
            ]
            [ Elem.image 
                [ Elem.width (Elem.px 700)
                , Elem.height (Elem.px 500)
                ]
                { src = static.data.metadata.image 
                , description = "Bird?"
                } 
            , static.data.content.content
            ]
    }
    

