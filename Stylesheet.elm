module Stylesheet exposing (CssClasses(..), cssString)

import Css exposing (..)
import Css.Elements exposing (body, span)

type CssClasses = Number | Button | Overlay
css = stylesheet [
  body [
    backgroundColor <| hex "AF7B35",
    margin (px 10)
  ],
  class Number [
      fontFamilies [qt "DSEG7 Classic", qt "Courier New"],
      position relative,
      color <| hex "0F0",
      backgroundColor <| hex "000",
      border3 (px 1) solid <| hex "979797",
      padding (px 5),
      fontSize (pt 36),
      children [
        class Overlay [
          position absolute,
          left (px 5),
          color <| rgba 0 255 0 0.43
        ]
      ]
    ]
  ]

cssString = (.css <| Css.compile [css])
