module View exposing (view, Msg(..))

import Model exposing (Model)
import Projects exposing (Project, projects)

import Exts.Maybe exposing (catMaybes)
import Html exposing (..)
import Html.Attributes exposing (alt, disabled, src, title)
import Html.CssHelpers
import Html.Events exposing (onClick)
import Stylesheet exposing (..)

-- TODO move these elsewhere
import Time exposing (Time)
type Msg = RunProject Project | Tick Time

class a = (.class <| Html.CssHelpers.withNamespace "") [a]
icon iconName desc = img [src <| "icons/" ++ iconName ++ ".svg", alt desc, title desc] []

showNumber : Int -> String -> String -> Int -> Html Msg
showNumber digits iconName desc num =
  let
    maxDisplay = 10^digits - 1
    eights = maxDisplay // 9 * 8

    splitThousands_ : Int -> List (Html Msg)
    splitThousands_ i =
      if i == 0
      then []
      else
        if i >= 1000
        then splitThousands_ (i//1000) ++ [span [class Comma] [text ","], text <| String.padLeft 3 '0' <| toString <| rem i 1000]
        else [text <| toString i]

    splitThousands : Int -> List (Html Msg)
    splitThousands i =
      if i == 0
      then [text "0"]
      else splitThousands_ i
    
  in
    tr [] [
      td [] [icon iconName desc],
      td [class Number] (
        splitThousands eights
        ++ [span [class Overlay] <| splitThousands <| min num maxDisplay]
      )
    ]

maybeShowProject : Model -> Project -> Maybe (Html Msg)
maybeShowProject model project =
  case project.visible of
    True ->
      Just <| button [class Stylesheet.Project, onClick <| RunProject project, disabled <| not project.enabled] [
        icon project.icon "",
        text project.title,
        br [] [],
        text project.priceTag,
        br [] [],
        text project.shortDesc
      ]
    False -> Nothing

showProjects : Model -> List (Html Msg)
showProjects model = catMaybes <| List.map (maybeShowProject model) (projects model)

view : Model -> Html Msg
view model =
  div [] [
    node "style" [] [text cssString],
    div [] [
      table [] [
        showNumber 9 "paperclip" "Inventory" model.unusedClips,
        showNumber 9 "paperclip" "Total manufactured paperclips" model.totalManufactured,
        showNumber 9 "wirespool" "Available wire" model.wireInches,
        showNumber 9 "paperclip" "Available funds" model.funds
      ]
    ],
    div [class Projects] (showProjects model)
  ]

