-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Treningsplan.Enum.MetricV2 exposing (MetricV2(..), decoder, fromString, list, toString)

import Json.Decode as Decode exposing (Decoder)


{-|

  - Meter -
  - Second -

-}
type MetricV2
    = Meter
    | Second


list : List MetricV2
list =
    [ Meter, Second ]


decoder : Decoder MetricV2
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "METER" ->
                        Decode.succeed Meter

                    "SECOND" ->
                        Decode.succeed Second

                    _ ->
                        Decode.fail ("Invalid MetricV2 type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representating the Enum to a string that the GraphQL server will recognize.
-}
toString : MetricV2 -> String
toString enum =
    case enum of
        Meter ->
            "METER"

        Second ->
            "SECOND"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe MetricV2
fromString enumString =
    case enumString of
        "METER" ->
            Just Meter

        "SECOND" ->
            Just Second

        _ ->
            Nothing
