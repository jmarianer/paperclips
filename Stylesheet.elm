module Stylesheet exposing (CssClasses(..), cssString)

import Css exposing (..)
import Css.Elements exposing (img, body, div, h1)

type CssClasses = Number | Overlay | Projects | Project | Comma | Button | Disabled | Thing | TableHolder | Spacer
css =
  stylesheet [
    body [
      backgroundColor <| hex "AF7B35",
      margin zero
    ],
    img [
      width (em 1),
      height (em 1),
      margin (px 5),
      marginRight (px 15)
    ],
    class Thing [
      displayFlex,
      alignItems center,
      justifyContent center
    ],
    Css.Elements.table [
      borderSpacing (em 0.3)
    ],
    class Number [
      fontFamilies [qt "DSEG7 Classic Mini"],
      position relative,
      color <| rgba 0 255 0 0.15,
      backgroundColor <| hex "000",
      border3 (px 1) inset <| hex "979797",
      padding (px 5),
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
      marginRight (em -0.3),
      marginLeft (em -0.25)
    ],
    class Project [
      width (px 128),
      height (px 200),
      displayFlex,
      flexDirection column,
      justifyContent (\a -> property "space-evenly" a.value),
      alignItems center,
      margin (px 15),
      children [
        img [
          width (pt 36),
          height (pt 36)
        ]
      ]
    ],
    class Projects [
      displayFlex,
      flexDirection row,
      flexWrap wrap,
      property "align-content" "start"
    ],
    div [
      displayFlex,
      flexDirection row
    ],
    class TableHolder [
      fontSize (pt 28),
      borderRight3 (px 1.5) solid (hex "000"),
      flexDirection column
    ],
    class Spacer [
      flexGrow <| int 100
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
    ],
    h1 [
      fontSize (em 1),
      fontFamily monospace,
      textAlign center
    ]
  ]

cssString = .css <| Css.compile [css]
