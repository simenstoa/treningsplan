-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Treningsplan.Object.Profile exposing (firstname, id, records, surname, vdot)

import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode
import Treningsplan.InputObject
import Treningsplan.Interface
import Treningsplan.Object
import Treningsplan.Scalar
import Treningsplan.ScalarCodecs
import Treningsplan.Union


{-| -}
firstname : SelectionSet String Treningsplan.Object.Profile
firstname =
    Object.selectionForField "String" "firstname" [] Decode.string


{-| -}
id : SelectionSet String Treningsplan.Object.Profile
id =
    Object.selectionForField "String" "id" [] Decode.string


{-| -}
records : SelectionSet decodesTo Treningsplan.Object.Record -> SelectionSet (List decodesTo) Treningsplan.Object.Profile
records object_ =
    Object.selectionForCompositeField "records" [] object_ (identity >> Decode.list)


{-| -}
surname : SelectionSet String Treningsplan.Object.Profile
surname =
    Object.selectionForField "String" "surname" [] Decode.string


{-| -}
vdot : SelectionSet Int Treningsplan.Object.Profile
vdot =
    Object.selectionForField "Int" "vdot" [] Decode.int
