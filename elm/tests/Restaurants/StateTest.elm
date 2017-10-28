module Restaurants.StateTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)

import Json.Decode as Decode
import Http
import Restaurants.Types as Types
import Restaurants.State as State

suite : Test
suite =
  describe "In the State module"
      [ describe "State.update ShowRestaurant"
          [ test "updates the empty model with the new restaurant" <|
            \_ ->
                let
                  restaurant = {name = "Test Name", url = "Test URL", postedBy = "Test Posted By", postedOn = "Test Posted On"}
                in
                  Expect.equal ({ restaurantList = [restaurant], newRestaurant = Types.emptyRestaurant, selectedRestaurant = Types.emptyRestaurant }, Cmd.none) (State.update (Types.ShowRestaurant restaurant) { restaurantList = [], newRestaurant = Types.emptyRestaurant, selectedRestaurant = Types.emptyRestaurant })
            , test "updates the existing model with the new restaurant" <|
              \_ ->
                  let
                    existing = {name = "Test", url = "Test", postedBy = "Test", postedOn = "Test"}
                    restaurant = {name = "Test Name", url = "Test URL", postedBy = "Test Posted By", postedOn = "Test Posted On"}
                  in
                    Expect.equal ({ restaurantList = [restaurant, existing], newRestaurant = Types.emptyRestaurant, selectedRestaurant = Types.emptyRestaurant }, Cmd.none) (State.update (Types.ShowRestaurant restaurant) {restaurantList = [existing], newRestaurant = Types.emptyRestaurant, selectedRestaurant = Types.emptyRestaurant})
          ]
        , describe "State.update UpdateRestaurants"
            [ test "creates a model with the returned list when successful" <|
              \_ ->
                  let
                    restaurant = { name = "Test", url = "Test", postedBy = "Test", postedOn = "Test" }
                    result = Ok [restaurant]
                  in
                    Expect.equal ({ restaurantList = [restaurant], newRestaurant = Types.emptyRestaurant, selectedRestaurant = Types.emptyRestaurant }, Cmd.none) (State.update (Types.UpdateRestaurants result) { restaurantList = [], newRestaurant = Types.emptyRestaurant, selectedRestaurant = Types.emptyRestaurant } )
              , test "keeps existing model when unsuccessful" <|
                \_ ->
                    let
                      existing = { restaurantList = [ { name = "Test", url = "Test", postedBy = "Test", postedOn = "Test" } ], newRestaurant = Types.emptyRestaurant, selectedRestaurant = Types.emptyRestaurant }
                      result = Err Http.NetworkError
                    in
                      Expect.equal (existing, Cmd.none) (State.update (Types.UpdateRestaurants result) existing)
            ]
        ]
