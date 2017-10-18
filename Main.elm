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
    enabled = model.wireInches > 1,
    effect = createClips model 1
  }, {
    title = "Wire",
    icon = "wirespool",
    priceTag = "$" ++ toString model.wirePrice,
    shortDesc = "1000\"",
    visible = True,
    enabled = model.funds > model.wirePrice,
    effect = { model | funds = model.funds - model.wirePrice, wireInches = model.wireInches + 1000 }
  }]


-- VIEW

{ id, class, classList } = Html.CssHelpers.withNamespace ""

-- TODO Revamp showNumber
splitThousands : String -> List String  -- Copied from https://github.com/cuducos/elm-format-number/blob/5.0.2/src/Helpers.elm
splitThousands integers =
  let
    reversedSplitThousands : String -> List String
    reversedSplitThousands value =
      if String.length value > 3 then
        value
        |> String.dropRight 3
        |> reversedSplitThousands
        |> (::) (String.right 3 value)
      else
        [ value ]
  in
    integers
    |> reversedSplitThousands
    |> List.reverse

icon iconName desc = img [src <| "icons/" ++ iconName ++ ".svg", alt desc] []

showNumber : String -> String -> number -> Html Msg
showNumber iconName desc num =
  let
    digits = 9
    maxNumber = 1e10 - 1  -- TODO use digits

    string = String.padLeft digits '!' <| toString num
    separatedString = string |> splitThousands |> String.join ","
  in
    tr [] [
      td [] [icon iconName desc],
      td [class [Number]] [
        text <| separatedString,
        span [class [Overlay]] [text "888,888,888"]
      ]
    ]

maybeShowProject : Model -> Project -> Maybe (Html Msg)
maybeShowProject model project =
  case project.visible of
    True ->
      Just <| button [class [Stylesheet.Project], onClick <| RunProject project, disabled <| not project.enabled] [
        icon project.icon "",
        text project.title
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
        showNumber "paperclip" "Inventory" model.unusedClips,
        showNumber "paperclip" "Total manufactured paperclips" model.totalManufactured,
        showNumber "wirespool" "Wire" model.wireInches,
        showNumber "paperclip" "Money" model.funds
      ]
    ],
    div [class [Projects]] (showProjects model)
  ]


-- UPDATE and MAIN

type Msg = RunProject Project | Tick Time
update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    RunProject p -> (p.effect, Cmd.none)
    Tick t -> ({ model | funds = model.funds+1 }, Cmd.none)

main = Html.program { init = (model, Cmd.none), view = view, update = update, subscriptions = \_ -> Time.every second Tick }
