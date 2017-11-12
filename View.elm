module View exposing (view, Msg(..))

import Model exposing (Model)
import Projects exposing (Project, projects)

import Exts.Maybe exposing (catMaybes)
import Html exposing (..)
import Html.Attributes exposing (alt, colspan, disabled, src, title)
import Html.CssHelpers
import Html.Events exposing (onClick)

-- TODO move these elsewhere
import Time exposing (Time)
type CssClasses = Number | Overlay | Projects | Project | Comma | Button | Disabled | CenterAll | TableHolder | Spacer | MainDiv

type Msg = RunProject Project | LargeTick Time | MediumTick Time | SmallTick Time | IncreasePrice Int | MaybeSell Int

classes = .class <| Html.CssHelpers.withNamespace ""
class a = classes [a]
icon iconName desc = img [src <| "icons/" ++ iconName ++ ".svg", alt desc, title desc] []
iconButton iconName desc msg = img [src <| "icons/" ++ iconName ++ ".svg", alt desc, title desc, onClick msg, class Button] []

maybeShowProject : Model -> Project -> Maybe (Html Msg)
maybeShowProject model project =
  let
    maybeDisabled = if project.enabled then [] else [Disabled]
  in
    case project.visible of
      True ->
        Just <| div [classes <| [Project] ++ maybeDisabled, onClick <| RunProject project] [
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

showDefaultNumber : Int -> Html Msg
showDefaultNumber = showNumber 9 0

type alias RowDescriptor =
  {
    icon: String,
    description: String,
    trigger: Bool,
    show: Html Msg
  }

manufacturingItems : Model -> List RowDescriptor
manufacturingItems model =
  [{
    icon = "paperclip",
    description = "Inventory",
    trigger = True,
    show = showDefaultNumber model.unusedClips
  }, {
    icon = "profit-graph",
    description = "Total manufactured paperclips",
    trigger = True,
    show = showDefaultNumber model.totalManufactured
  }, {
    icon = "wirespool",
    description = "Available wire",
    trigger = True,
    show = showDefaultNumber model.wireInches
  }, {
    icon = "dollar",
    description = "Available funds",
    trigger = True,
    show = showNumber 9 2 model.funds
  }, {
    icon = "paperclip",
    description = "Price per clip",
    trigger = True,
    show = div [class CenterAll] [
      iconButton "minus" "Decrease price" <| IncreasePrice -1,
      showNumber 3 2 model.priceCents,
      iconButton "plus" "Increase price" <| IncreasePrice 1
    ]
  }, {
    icon = "autoclippers",
    description = "AutoClippers",
    trigger = model.autoClipperCount > 0,
    show = showDefaultNumber model.autoClipperCount
  }]

computationItems : Model -> List RowDescriptor
computationItems model =
  [{
    icon = "trust",
    description = "Next available trust",
    trigger = model.computationEnabled,
    show = showDefaultNumber <| Tuple.first model.nextTrust
  }, {
    icon = "trust",
    description = "Current trust",
    trigger = model.computationEnabled,
    show = showDefaultNumber model.trust
  }, {
    icon = "processor",
    description = "Total processors",
    trigger = model.computationEnabled,
    show = div [class CenterAll] [
      showNumber 3 0 model.processors,
      div [class Spacer] [],
      icon "memory" "Total memory",
      showNumber 3 0 model.memory
    ]
  }, {
    icon = "memory",
    description = "Total memory",
    trigger = model.computationEnabled,
    show = showDefaultNumber model.memory
  }, {
    icon = "paperclip",
    description = "Stored operations",
    trigger = model.computationEnabled,
    show = showDefaultNumber <| model.milliOps // 1000
  }]

showTable : String -> List RowDescriptor -> Maybe (Html Msg)
showTable header items =
  let
    toRow viewItem =
      if viewItem.trigger
      then Just <| tr [] [
        td [] [icon viewItem.icon viewItem.description],
        td [] [viewItem.show]
      ]
      else Nothing

    rows = catMaybes <| List.map toRow <| items
  in
    if rows == []
    then Nothing
    else Just <| div [class TableHolder] [h1 [] [text header], table [] rows]

view : Model -> Html Msg
view model =
  let
    tables = [
      showTable "Manufacturing" <| manufacturingItems model,
      showTable "Computation" <| computationItems model,
      Just <| div [class Projects] (showProjects model)
    ]
  in
    div [class MainDiv] <| catMaybes tables

