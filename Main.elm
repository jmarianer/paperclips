import Model exposing (Model)
import View exposing (view, Msg(..))

import Html
import Time




-- UPDATE and MAIN

update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    RunProject p -> (p.effect, Cmd.none)
    Tick t -> ({ model | funds = model.funds+1 }, Cmd.none)

main =
  Html.program {
    init = (Model.initialModel, Cmd.none),
    view = view,
    update = update,
    subscriptions = \_ -> Time.every Time.second Tick
  }
