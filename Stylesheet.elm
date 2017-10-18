module Stylesheet exposing (CssClasses(..), cssString)

import Css exposing (..)
import Css.Elements exposing (..)

type CssClasses = Number | Overlay | Projects | Project | Comma
css =
  stylesheet [
    body [
      backgroundColor <| hex "AF7B35",
      margin (px 10)
    ],
    img [
      width (pt 36)
    ],
    Css.Elements.table [
      borderSpacing (px 15)
    ],
    class Number [
      fontFamilies [qt "DSEG7 Classic Mini"],
      position relative,
      color <| rgba 0 255 0 0.15,
      backgroundColor <| hex "000",
      border3 (px 1) solid <| hex "979797",
      padding (px 5),
      fontSize (pt 36),
      children [
        class Overlay [
          position absolute,
          left (px -5),
          color <| rgba 0 255 0 1,
          textAlign right,
          width (pct 100)
        ]
      ]
    ],
    class Comma [
      fontFamilies [qt "DSEG14 Classic Mini"],
      marginRight (px -20),
      marginLeft (px -10)
    ],
    class Project [
      width (px 128),
      height (px 200),
      displayFlex,
      flexDirection column,
      justifyContent (\a -> property "space-evenly" a.value),
      alignItems center
    ],
    class Projects [
      displayFlex,
      flexDirection row
    ],
    div [
      displayFlex,
      flexDirection row
    ]
  ]

cssString = .css <| Css.compile [css]
