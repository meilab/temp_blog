module ViewHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Messages exposing (Msg(..))
import Routing exposing (Route, routingItem, urlFor)
import Html.Events exposing (onInput)
import Json.Decode as JD
import Models exposing (Model)
import Html.CssHelpers exposing (withNamespace)
import Styles.SharedStyles exposing (..)
import Date.Extra
import Date exposing (Date)


{ id, class, classList } =
    withNamespace "meilab"


navigationOnClick : Msg -> Attribute Msg
navigationOnClick msg =
    Html.Events.onWithOptions "click"
        { stopPropagation = False
        , preventDefault = True
        }
        (JD.succeed msg)


navContainer : Model -> Html Msg
navContainer model =
    nav [ class [ MenuContainer ] ]
        [ ul [ class [ MenuList ] ]
            (List.map (navItem model) (routingItem model.url.base_url))
        ]


navItem : Model -> ( String, String, Route, String ) -> Html Msg
navItem model ( title, iconClass, route, slug ) =
    let
        isCurrentLocation =
            model.route == route

        ( onClickCmd, selectedClass ) =
            case ( isCurrentLocation, route ) of
                ( False, route ) ->
                    ( route |> (urlFor model.url.base_url) |> NewUrl
                    , class []
                    )

                _ ->
                    ( NoOp
                    , class [ MenuSelected ]
                    )
    in
        linkItem selectedClass
            onClickCmd
            (class [])
            iconClass
            slug
            title


linkItem : Attribute Msg -> Msg -> Attribute Msg -> String -> String -> String -> Html Msg
linkItem liClass onClickCmd aClass iconClass slug textToShow =
    li
        [ class [ MenuItem ]
        , liClass
        ]
        [ a
            [ href slug
            , navigationOnClick (onClickCmd)
            , aClass
            ]
            [ i [ Html.Attributes.class iconClass ] []
            , text textToShow
            ]
        ]


normalLinkItem : String -> String -> String -> Html Msg
normalLinkItem base_url slug textToShow =
    linkItem (class [])
        (NewUrl (base_url ++ slug))
        (class [])
        ""
        slug
        textToShow


formatDate : Date -> String
formatDate =
    Date.Extra.toFormattedString "MMMM ddd, y"
