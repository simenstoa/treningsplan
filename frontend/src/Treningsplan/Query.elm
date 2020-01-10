-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Treningsplan.Query exposing (PlanRequiredArguments, ProfileRequiredArguments, WorkoutRequiredArguments, intensityZones, plan, plans, profile, workout, workoutV2s, workouts)

import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)
import Treningsplan.InputObject
import Treningsplan.Interface
import Treningsplan.Object
import Treningsplan.Scalar
import Treningsplan.ScalarCodecs
import Treningsplan.Union


{-| -}
intensityZones : SelectionSet decodesTo Treningsplan.Object.Intensity -> SelectionSet (List decodesTo) RootQuery
intensityZones object_ =
    Object.selectionForCompositeField "intensityZones" [] object_ (identity >> Decode.list)


type alias PlanRequiredArguments =
    { id : String }


{-|

  - id - The id of the plan

-}
plan : PlanRequiredArguments -> SelectionSet decodesTo Treningsplan.Object.Plan -> SelectionSet (Maybe decodesTo) RootQuery
plan requiredArgs object_ =
    Object.selectionForCompositeField "plan" [ Argument.required "id" requiredArgs.id Encode.string ] object_ (identity >> Decode.nullable)


{-| -}
plans : SelectionSet decodesTo Treningsplan.Object.Plan -> SelectionSet (List decodesTo) RootQuery
plans object_ =
    Object.selectionForCompositeField "plans" [] object_ (identity >> Decode.list)


type alias ProfileRequiredArguments =
    { id : String }


{-|

  - id - The id of the profile

-}
profile : ProfileRequiredArguments -> SelectionSet decodesTo Treningsplan.Object.Profile -> SelectionSet (Maybe decodesTo) RootQuery
profile requiredArgs object_ =
    Object.selectionForCompositeField "profile" [ Argument.required "id" requiredArgs.id Encode.string ] object_ (identity >> Decode.nullable)


type alias WorkoutRequiredArguments =
    { id : String }


{-|

  - id - The id of the workout

-}
workout : WorkoutRequiredArguments -> SelectionSet decodesTo Treningsplan.Object.Workout -> SelectionSet (Maybe decodesTo) RootQuery
workout requiredArgs object_ =
    Object.selectionForCompositeField "workout" [ Argument.required "id" requiredArgs.id Encode.string ] object_ (identity >> Decode.nullable)


{-| -}
workoutV2s : SelectionSet decodesTo Treningsplan.Object.WorkoutV2 -> SelectionSet (List decodesTo) RootQuery
workoutV2s object_ =
    Object.selectionForCompositeField "workoutV2s" [] object_ (identity >> Decode.list)


{-| -}
workouts : SelectionSet decodesTo Treningsplan.Object.Workout -> SelectionSet (List decodesTo) RootQuery
workouts object_ =
    Object.selectionForCompositeField "workouts" [] object_ (identity >> Decode.list)
