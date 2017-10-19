module Stylesheet exposing (CssClasses(..), cssString)

import Css exposing (..)
import Css.Elements exposing (..)

type CssClasses = Number | Overlay | Projects | Project | Comma | Button | Disabled
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
      border3 (px 1) inset <| hex "979797",
      padding (px 5),
      fontSize (pt 36),
      textAlign right,
      children [
        class Overlay [
          position absolute,
          left (px -5),
          color <| rgba 0 255 0 1,
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
      alignItems center,
      margin (px 15)
    ],
    class Projects [
      displayFlex,
      flexDirection row
    ],
    div [
      displayFlex,
      flexDirection row
    ],
    class Button [
      border3 (px 1) outset <| hex "979797",
      backgroundColor <| rgba 0 0 0 0.05,
      active [
        border3 (px 1) inset <| hex "979797"
      ]
    ],
    class Disabled [
      active [
        border3 (px 1) outset <| hex "979797"
      ],
      color <| hex "#4c4c4c"
    ]
  ]

cssString = .css <| Css.compile [css]
