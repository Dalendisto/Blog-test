module Page.About exposing (Model, Msg, Data, page)

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
import RepoFiles
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never

type alias RouteParams =
    {}

page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


type alias Data =
    List RepoFiles.FileFm --()


data : DataSource Data
data =
    RepoFiles.getFileFm--DataSource.succeed ()


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


view : -- Listing all File names in content folder
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "About"
        , body = 
            Elem.column
                [ Elem.width Elem.fill
                , Elem.height Elem.fill
                , Elem.centerX
                --, Border.width 5
                ]
                [ blogLinks static
                ]
    }


blogLinks : StaticPayload Data RouteParams -> Elem.Element msg
blogLinks static =
    Elem.column 
        [ Elem.width Elem.fill
        , Elem.padding 50
        , Elem.centerY
        , Elem.spacingXY 0 30
        --, Border.width 5
        ]
        (static.data 
            |> List.map (\blogItem -> blogRow blogItem) 
        )


blogRow : RepoFiles.FileFm -> Elem.Element msg
blogRow static = 
    Elem.row 
        [ Elem.width (Elem.px 800)
        , Elem.centerX
        --, Border.width 1
        ]
        [ infoColumn static 
        , blogImage static 
        ]


infoColumn : RepoFiles.FileFm -> Elem.Element msg
infoColumn static =
    Elem.textColumn 
        [ Elem.width (Elem.fill |> Elem.maximum 400)
        , Elem.spacingXY 0 20
        , Elem.alignTop
        --, Border.width 1
        ]
        [ title static 
        , authorDate static
        , description static
        , blogLink static
        ]


title : RepoFiles.FileFm -> Elem.Element msg
title static =
    Elem.el
        [ Font.size 25
        , Font.bold
        , Font.underline
        ]
        (Elem.text static.title)


authorDate : RepoFiles.FileFm -> Elem.Element msg
authorDate static =
    Elem.el
        [ Font.size 14]
        (Elem.text ("by: " ++ static.author ++ " on: " ++ static.published))

description : RepoFiles.FileFm -> Elem.Element msg
description static =
    Elem.paragraph
        [Font.letterSpacing 1]
        [Elem.text static.description]


blogLink : RepoFiles.FileFm -> Elem.Element msg
blogLink static = 
    Elem.link 
        [ Elem.width (Elem.px 200)
        , Elem.height (Elem.px 40)
        , Background.color (Elem.rgb255 0 100 50)
        , Font.color (Elem.rgb255 255 255 255)
        , Border.rounded 4
        --, Border.width 1
        ]
        { url = "/repofiles/" ++ static.slug
        , label = 
            Elem.el
                [ Elem.centerX ]
                (Elem.text "Continue Reading")
        }


blogImage : RepoFiles.FileFm -> Elem.Element msg
blogImage static =
    Elem.el 
        [ Elem.width (Elem.px 250) --(Elem.fill |> Elem.maximum 300)
        , Elem.height (Elem.px 250)
        , Elem.alignRight
        , Background.image static.image 
        , Border.rounded 5
        ]
        Elem.none
