module View exposing (view, Msg(..))

import Model exposing (Model)
import Projects exposing (Project, projects)

import Exts.Maybe exposing (catMaybes)
import Html exposing (..)
import Html.Attributes exposing (alt, colspan, disabled, src, title)
import Html.CssHelpers
import Html.Events exposing (onClick)
import Stylesheet exposing (..)

-- TODO move these elsewhere
import Time exposing (Time)
type Msg = RunProject Project | Tick Time | IncreasePrice Int | MaybeSell Int

classes = .class <| Html.CssHelpers.withNamespace ""
class a = classes [a]
icon iconName desc = img [src <| "icons/" ++ iconName ++ ".svg", alt desc, title desc] []
iconButton iconName desc msg = img [src <| "icons/" ++ iconName ++ ".svg", alt desc, title desc, onClick msg, class Button] []

showNumber : Int -> Int -> Int -> Html Msg
showNumber digits decimals num =
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

    splitThousandsAndAddDecimal i =
      if decimals > 0
      then
        splitThousands (i//10^decimals)
        ++ [text ("." ++ (String.padLeft decimals '0' <| toString <| rem i <| 10^decimals))]
      else
        splitThousands i
    
  in
    div [class Number] (
      splitThousandsAndAddDecimal eights
      ++ [span [class Overlay] <| splitThousandsAndAddDecimal <| min num maxDisplay]
    )

maybeShowProject : Model -> Project -> Maybe (Html Msg)
maybeShowProject model project =
  let
    maybeDisabled = if project.enabled then [] else [Disabled]
  in
    case project.visible of
      True ->
        Just <| div [classes <| [Stylesheet.Project, Stylesheet.Button] ++ maybeDisabled, onClick <| RunProject project] [
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
  let
    row decimals iconName desc num =
      tr [] [
        td [] [icon iconName desc],
        td [colspan 3] [showNumber 9 decimals  num]
      ]
  in
  div [] [
    node "style" [] [text cssString],
    div [] [
      table [] [
        row 0 "paperclip" "Inventory" model.unusedClips,
        row 0 "paperclip" "Total manufactured paperclips" model.totalManufactured,
        row 0 "wirespool" "Available wire" model.wireInches,
        row 2 "paperclip" "Available funds" model.funds,
        tr [] [
          td [] [icon "paperclip" "Price per clip"],
          td [Html.Attributes.style [("text-align", "right")]] [iconButton "paperclip" "Decrease price" <| IncreasePrice -1],
          td [] [showNumber 3 2 model.priceCents],
          td [] [iconButton "paperclip" "Increase price" <| IncreasePrice 1]
        ]
      ]
    ],
    text <| "Demand: " ++ (toString <| round <| Model.demand model),
    div [class Projects] (showProjects model)
  ]

