import Model exposing (Model)
import View exposing (view, Msg(..))

import Html
import Random
import Time




-- UPDATE and MAIN

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    RunProject p -> if p.enabled then (p.effect, Cmd.none) else (model, Cmd.none)
    Tick t -> (model, Random.generate MaybeSell (Random.int 1 1000))
    IncreasePrice i ->
      if model.priceCents + i > 0
      then ({ model | priceCents = model.priceCents + i }, Cmd.none) 
      else (model, Cmd.none)
    MaybeSell b ->
      if b < (round <| Model.demand model)
      then (Model.sellClips model, Cmd.none)
      else (model, Cmd.none)

main =
  Html.program {
    init = (Model.initialModel, Cmd.none),
    view = view,
    update = update,
    subscriptions = \_ -> Time.every (100*Time.millisecond) Tick
  }
