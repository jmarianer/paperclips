module Model exposing (Model, initialModel, createClips, sellClips, demand, autoClipperPrice, createPartialClips)

import Fibonacci

type alias Model = {
  unusedClips : Int,
  wireInches : Int,
  totalManufactured : Int,
  funds : Int,
  priceCents : Int,
  wirePrice : Int,
  previousTotalClips : Int,
  autoClippersEnabled : Bool,
  autoClipperCount : Int,
  autoClipperRate : Int,
  marketingLevel : Int,
  partialClips  : Int,
  computationEnabled : Bool,
  trust : Int,
  nextTrust : Fibonacci.Fib,
  processors : Int,
  memory : Int,
  milliOps : Int,
  creativityEnabled : Bool,
  creativity : Int
  }

initialModel : Model
initialModel = {
  unusedClips = 0,
  wireInches = 1000,
  totalManufactured = 0,
  funds = 0,
  priceCents = 25,
  wirePrice = 10,
  previousTotalClips = 0,
  autoClippersEnabled = False,
  autoClipperCount = 0,
  autoClipperRate = 1000,
  marketingLevel = 0,
  partialClips = 0,
  computationEnabled = False,
  trust = 2,
  nextTrust = (3000, 5000),
  processors = 1,
  memory = 1,
  milliOps = 0,
  creativityEnabled = False,
  creativity = 0
  }

createClips : Model -> Int -> Model
createClips m i =
  let
    clipCount = min i m.wireInches
    newTotalManufactured = m.totalManufactured + clipCount
    newTrust = (m.totalManufactured < Fibonacci.get m.nextTrust) && (newTotalManufactured >= Fibonacci.get m.nextTrust)
  in
    { m |
      unusedClips = m.unusedClips + clipCount,
      totalManufactured = newTotalManufactured,
      wireInches = m.wireInches - clipCount,
      computationEnabled = m.computationEnabled || newTotalManufactured >= 2000,
      trust = if newTrust then m.trust+1 else m.trust,
      nextTrust = if newTrust then Fibonacci.advance m.nextTrust else m.nextTrust
    }

createPartialClips : Model -> Int -> Model
createPartialClips m i =
  let
    newPartialClips = m.partialClips + i
    clipsCreated = createClips m (newPartialClips // 1000)
  in
    { clipsCreated | partialClips = (rem newPartialClips 1000) }

demand m =
  let
    marketingLvl = 0
    marketing = 1.1 ^ (toFloat m.marketingLevel)
  in
    800 / (toFloat m.priceCents) * marketing

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
