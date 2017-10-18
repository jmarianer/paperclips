import Exts.Maybe exposing (catMaybes)
import Html exposing (..)
import Html.Attributes exposing (disabled)
import Html.Events exposing (onClick)
import Time exposing (Time, second)

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
    priceTag = "1\" of wire",
    shortDesc = "",
    visible = True,
    enabled = model.wireInches > 1,
    effect = createClips model 1
  }, {
    title = "Wire",
    priceTag = "$" ++ toString model.wirePrice,
    shortDesc = "1000\"",
    visible = True,
    enabled = model.funds > model.wirePrice,
    effect = { model | funds = model.funds - model.wirePrice, wireInches = model.wireInches + 1000 }
  }]


showNumber : String -> number -> Html Msg
showNumber icon num = text (icon ++ ":" ++ toString num)

maybeShowProject : Model -> Project -> Maybe (Html Msg)
maybeShowProject model project =
  case project.visible of
    True ->
      Just <| button [onClick <| RunProject project, disabled <| not project.enabled] [text project.title]
    False -> Nothing

showProjects : Model -> List (Html Msg)
showProjects model = catMaybes <| List.map (maybeShowProject model) (projects model)

view : Model -> Html Msg
view model = div [] ([
  showNumber "Inventory" model.unusedClips,
  showNumber "Total manufactured paperclips" model.totalManufactured,
  showNumber "Wire" model.wireInches,
  showNumber "Money" model.funds
  ] ++ showProjects model)

type Msg = RunProject Project | Tick Time

update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    RunProject p -> (p.effect, Cmd.none)
    Tick t -> ({ model | funds = model.funds+1 }, Cmd.none)

main = Html.program { init = (model, Cmd.none), view = view, update = update, subscriptions = \_ -> Time.every second Tick }
