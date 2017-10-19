module Model exposing (..)--(Model, initialModel, createClips, sellClips, demand)

type alias Model = {
  unusedClips : Int,
  wireInches : Int,
  totalManufactured : Int,
  funds : Int,
  priceCents : Int,
  wirePrice : Int,
  previousTotalClips : Int,
  autoClippersEnabled : Bool,
  autoClipperCount : Int
  }

initialModel : Model
initialModel = {
  unusedClips = 0,
  wireInches = 1000,
  totalManufactured = 0,
  funds = 1000,
  priceCents = 25,
  wirePrice = 10,
  previousTotalClips = 0,
  autoClippersEnabled = False,
  autoClipperCount = 0
  }

createClips : Model -> Int -> Model
createClips m i =
  { m |
    unusedClips = m.unusedClips + i,
    totalManufactured = m.totalManufactured + i,
    wireInches = m.wireInches - i
  }

demand m =
  let
    marketingLvl = 0
    marketing = 1.1^marketingLvl
  in
    800 / (toFloat m.priceCents) * marketing --* marketingEffectiveness

sellClips : Model -> Model
sellClips m =
  let
    clipsToSell = min m.unusedClips (floor (7 * (demand m / 100) ^ 1.15))
    newFunds = m.funds + m.priceCents * clipsToSell
  in
    { m |
      unusedClips = m.unusedClips - clipsToSell,
      funds = newFunds,
      autoClippersEnabled = m.autoClippersEnabled || newFunds >= 500
    }

autoClipperPrice m =
  case m.autoClipperCount of
    0 -> 500
    _ -> round (1.1 ^ (toFloat m.autoClipperCount) * 100) + 500
