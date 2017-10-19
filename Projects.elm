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

cheatsOn = True

projects : Model -> List Project
projects model = [
  {
    title = "Cheat money",
    icon = "paperclip",
    priceTag = "$100",
    shortDesc = "",
    visible = cheatsOn,
    enabled = True,
    effect = { model | funds = model.funds + 10000 }
  }, {
    title = "Cheat paperclips",
    icon = "paperclip",
    priceTag = "1000 clips for free",
    shortDesc = "",
    visible = cheatsOn,
    enabled = True,
    effect = { model | totalManufactured = model.totalManufactured + 1000 }
  }, {
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
    shortDesc =
      if model.autoClipperRate == 1000
      then "Creates one paperclip per second"
      else "Creates " ++ toString ((toFloat model.autoClipperRate) / 1000) ++ " paperclips per second",
    visible = model.autoClippersEnabled,
    enabled = model.funds >= Model.autoClipperPrice model,
    effect = { model | funds = model.funds - Model.autoClipperPrice model, autoClipperCount = model.autoClipperCount + 1 }
  }, {
    title = "Buy ad",
    icon = "wirespool",
    priceTag = "$" ++ (toString <| (2 ^ model.marketingLevel) * 100),
    shortDesc = "Increases marketing effectiveness",
    visible = True,
    enabled = model.funds >= (2 ^ model.marketingLevel) * 10000,
    effect = { model | funds = model.funds - ((2 ^ model.marketingLevel) * 10000), marketingLevel = model.marketingLevel + 1 }
  }, {
    title = "Improved AutoClippers",
    icon = "wirespool",
    priceTag = "750 ops",
    shortDesc = "Increases AutoClipper performance",
    visible = model.autoClipperCount > 0,
    enabled = model.milliOps >= 750000,
    effect = { model | milliOps = model.milliOps - 750000, autoClipperRate = 1250 }
  }, {
    title = "Improved AutoClippers",
    icon = "wirespool",
    priceTag = "2500 ops",
    shortDesc = "Increases AutoClipper performance",
    visible = model.autoClipperRate == 1250,
    enabled = model.milliOps >= 2500000,
    effect = { model | milliOps = model.milliOps - 2500000, autoClipperRate = 1750 }
  }]

