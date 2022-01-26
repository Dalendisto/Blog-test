module RepoFiles exposing (..)

import DataSource exposing (DataSource)
import DataSource.File as File
import DataSource.Glob as Glob
import Html.Attributes as HA
import Element as Elem
import Element.Border as Border
import OptimizedDecoder as Dec
import Markdown as Mrkdn
import DkMarkdown as Md


type alias FileNames =
    { filePath : String 
    , slug : String 
    }


myFiles : DataSource (List FileNames) 
myFiles =
    Glob.succeed --FileNames
        (\filePath slug ->
            { filePath = filePath
            , slug = slug
            }
        )
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource 


type alias FileFm =
    { slug : String
    , author : String
    , title : String 
    , description : String 
    , published : String 
    , image : String
    }


getFileFm : DataSource (List FileFm)
getFileFm =
    myFiles 
        |> DataSource.map 
            (\filePaths -> 
                List.map 
                    (\filePath -> 
                        File.onlyFrontmatter (fmDecoder filePath.slug) filePath.filePath
                    ) filePaths
            )
        |> DataSource.resolve  


getSingleFm : String -> DataSource FileFm
getSingleFm slug =
    File.onlyFrontmatter (fmDecoder slug) ("content/" ++ slug ++ ".md")               


fmDecoder : String -> Dec.Decoder FileFm
fmDecoder slug =
    Dec.map5 (FileFm slug) 
        (Dec.field "author" Dec.string)
        (Dec.field "title" Dec.string)
        (Dec.field "description" Dec.string)
        (Dec.field "published" Dec.string)
        (Dec.field "image" Dec.string)


-- Markdown Content


type alias Content msg =
    { content : Elem.Element msg}


--getFileMd : String -> DataSource (Content msg)
--getFileMd slug =
--    File.bodyWithoutFrontmatter ("content/" ++ slug ++ ".md")
--        |> DataSource.andThen 
--            (\markdown -> 
--                Md.view markdown
--                    |> Result.map
--                        (\content ->
--                            Elem.column
--                                [ Elem.width Elem.fill 
--                                , Elem.padding 100
--                                ]
--                                (List.map (\v -> v) content)
--                        )
--                    |> DataSource.fromResult
--            )
--        |> DataSource.map (\item -> { content = item })
            

getFileContent : String -> DataSource (Content msg)
getFileContent slug =
    File.bodyWithoutFrontmatter ("content/" ++ slug ++ ".md")
        |> DataSource.map 
            (\item -> 
                { content =
                    Elem.paragraph
                        [ Elem.width (Elem.px 1000)
                        --, Border.width 1
                        ]
                        [  Mrkdn.toHtml [ HA.list ""] item |> Elem.html
                        ]
                        
                   
                }
            )

            
