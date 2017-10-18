import Exts.Maybe exposing (catMaybes)
import Html exposing (..)
import Html.Attributes exposing (alt, disabled, src)
import Html.CssHelpers
import Html.Events exposing (onClick)
import Stylesheet exposing (..)
import Time exposing (Time, second)

-- MODEL

type alias Model = {
  unusedClips : Int,
  wireInches : Int,
  totalManufactured : Int,
  funds : Int,
  priceCents : Int,
  wirePrice : Int,
  previousTotalClips : Int
  }

model : Model
model = {
  unusedClips = 0,
  wireInches = 1000,
  totalManufactured = 0,
  funds = 0,
  priceCents = 25,
  wirePrice = 10,
  previousTotalClips = 0
  }

type alias Project = {
  title : String,
  icon : String,
  priceTag : String,
  shortDesc : String,
  --longDesc : String,
  visible : Bool,
  enabled : Bool,
  effect : Model
  }

createClips : Model -> Int -> Model
createClips m i =
  { m |
    unusedClips = m.unusedClips + i,
    totalManufactured = m.totalManufactured + i,
    wireInches = m.wireInches - i
  }

projects : Model -> List Project
projects model = [
  {
    title = "Make paperclip",
    icon = "paperclip",
    priceTag = "1\" of wire",
    shortDesc = "",
    visible = True,
    enabled = model.wireInches >= 1,
    effect = createClips model 1
  }, {
    title = "Wire",
    icon = "wirespool",
    priceTag = "$" ++ toString model.wirePrice,
    shortDesc = "1000\"",
    visible = True,
    enabled = model.funds >= model.wirePrice,
    effect = { model | funds = model.funds - model.wirePrice, wireInches = model.wireInches + 1000 }
  }]


-- VIEW

class a = (.class <| Html.CssHelpers.withNamespace "") [a]

icon iconName desc = img [src <| "icons/" ++ iconName ++ ".svg", alt desc] []


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
        showNumber 9 "wirespool" "Wire" model.wireInches,
        showNumber 9 "paperclip" "Money" model.funds
      ]
    ],
    div [class Projects] (showProjects model)
  ]


-- UPDATE and MAIN

type Msg = RunProject Project | Tick Time
update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    RunProject p -> (p.effect, Cmd.none)
    Tick t -> ({ model | funds = model.funds+1 }, Cmd.none)

main = Html.program { init = (model, Cmd.none), view = view, update = update, subscriptions = \_ -> Time.every second Tick }
