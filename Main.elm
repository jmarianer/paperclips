import Model exposing (Model)
import View exposing (view, Msg(..))

import Html
import Random
import Time

doSmallTick model =
  let
    clipsMade = Model.createPartialClips model (model.autoClipperCount * model.autoClipperRate // 100)
    addedOps =
      if model.computationEnabled
      then min (model.memory * 1000000 - model.milliOps) (model.processors * 100)
      else 0
  in
    ({clipsMade | milliOps = model.milliOps + addedOps}, Random.generate MaybeSell (Random.int 1 10000))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    RunProject p -> if p.enabled then (p.effect, Cmd.none) else (model, Cmd.none)
    SmallTick _ -> doSmallTick model
    MediumTick _ -> (model, Cmd.none)
    LargeTick _ -> (model, Cmd.none)
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
    subscriptions = \_ -> 
    Sub.batch [
      Time.every (10*Time.millisecond) SmallTick,
      Time.every (100*Time.millisecond) MediumTick,
      Time.every (Time.second) LargeTick
    ]
  }
