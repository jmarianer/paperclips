module Model exposing (Model, initialModel, createClips, sellClips, demand)

type alias Model = {
  unusedClips : Int,
  wireInches : Int,
  totalManufactured : Int,
  funds : Int,
  priceCents : Int,
  wirePrice : Int,
  previousTotalClips : Int
  }

initialModel : Model
initialModel = {
  unusedClips = 0,
  wireInches = 1000,
  totalManufactured = 0,
  funds = 0,
  priceCents = 25,
  wirePrice = 10,
  previousTotalClips = 0
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
    clipsToSell = floor (0.7 * (demand m)^1.15)
  in
    if m.unusedClips > clipsToSell
    then
      { m |
        unusedClips = m.unusedClips - clipsToSell,
        funds = m.funds + m.priceCents * clipsToSell
      }
    else
      { m |
        unusedClips = 0,
        funds = m.funds + m.priceCents * m.unusedClips
      }
