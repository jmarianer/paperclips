module Projects exposing (Project, projects)

import Model exposing (Model)

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

projects : Model -> List Project
projects model = [
  {
    title = "Make paperclip",
    icon = "paperclip",
    priceTag = "1\" of wire",
    shortDesc = "",
    visible = True,
    enabled = model.wireInches >= 1,
    effect = Model.createClips model 1
  }, {
    title = "Wire",
    icon = "wirespool",
    priceTag = "$" ++ toString model.wirePrice,
    shortDesc = "1000\"",
    visible = True,
    enabled = model.funds >= model.wirePrice * 100,
    effect = { model | funds = model.funds - model.wirePrice * 100, wireInches = model.wireInches + 1000 }
  }, {
    title = "AutoClippers",
    icon = "wirespool",
    priceTag = toString <| Model.autoClipperPrice model,
    shortDesc = "Creates one paperclip per second",
    visible = model.autoClippersEnabled,
    enabled = model.funds >= Model.autoClipperPrice model,
    effect = { model | funds = model.funds - Model.autoClipperPrice model, autoClipperCount = model.autoClipperCount + 1 }
  }]

