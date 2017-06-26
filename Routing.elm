module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = HomeRoute
    | AboutRoute
    | ArchiveRoute
    | PostDetailRoute String
    | NotFoundRoute


parseBaseUrl : String -> Parser a a -> Parser a a
parseBaseUrl base_url item =
    case base_url of
        "" ->
            item

        _ ->
            base_url
                |> String.dropLeft 1
                |> String.split "/"
                |> List.map (s)
                |> List.reverse
                |> List.foldl (</>) (item)


matchers : String -> Parser (Route -> a) a
matchers base_url =
    oneOf
        [ map HomeRoute (parseBaseUrl base_url top)
        , map AboutRoute (parseBaseUrl base_url (s "about"))
        , map ArchiveRoute (parseBaseUrl base_url (s "postlist"))
        , map PostDetailRoute (parseBaseUrl base_url (s "post") </> string)
        ]


parseLocation : Location -> String -> Route
parseLocation location base_url =
    case (parsePath (matchers base_url) location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


urlFor : String -> Route -> String
urlFor base_url route =
    case route of
        HomeRoute ->
            base_url

        AboutRoute ->
            base_url ++ "/about"

        ArchiveRoute ->
            base_url ++ "/postlist"

        PostDetailRoute slug ->
            base_url ++ "/postdetail" ++ slug

        NotFoundRoute ->
            base_url


routingItem : String -> List ( String, String, Route, String )
routingItem base_url =
    [ ( "Home", "fa fa-apps", HomeRoute, base_url )
    , ( "About", "fa fa-list", AboutRoute, base_url ++ "/about" )
    , ( "Archives", "fa fa-list", ArchiveRoute, base_url ++ "/archive" )
    ]
