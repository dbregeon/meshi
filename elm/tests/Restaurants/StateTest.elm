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
                  restaurant = {id = 0, name = "Test Name", url = "Test URL", postedBy = "Test Posted By", postedOn = "Test Posted On"}
                in
                  Expect.equal ({ restaurantList = [restaurant], newRestaurant = Nothing, selectedRestaurant = Types.emptyRestaurant }, Cmd.none) (State.update (Types.ShowRestaurant restaurant) { restaurantList = [], newRestaurant = Nothing, selectedRestaurant = Types.emptyRestaurant })
            , test "updates the existing model with the new restaurant" <|
              \_ ->
                  let
                    existing = {id = 0, name = "Test", url = "Test", postedBy = "Test", postedOn = "Test"}
                    restaurant = {id = 1, name = "Test Name", url = "Test URL", postedBy = "Test Posted By", postedOn = "Test Posted On"}
                  in
                    Expect.equal ({ restaurantList = [restaurant, existing], newRestaurant = Nothing, selectedRestaurant = Types.emptyRestaurant }, Cmd.none) (State.update (Types.ShowRestaurant restaurant) {restaurantList = [existing], newRestaurant = Nothing, selectedRestaurant = Types.emptyRestaurant})
          ]
        , describe "State.update UpdateRestaurants"
            [ test "creates a model with the returned list when successful" <|
              \_ ->
                  let
                    restaurant = { id = 0,  name = "Test", url = "Test", postedBy = "Test", postedOn = "Test" }
                    result = Ok [restaurant]
                  in
                    Expect.equal ({ restaurantList = [restaurant], newRestaurant = Nothing, selectedRestaurant = Types.emptyRestaurant }, Cmd.none) (State.update (Types.UpdateRestaurants result) { restaurantList = [], newRestaurant = Nothing, selectedRestaurant = Types.emptyRestaurant } )
              , test "keeps existing model when unsuccessful" <|
                \_ ->
                    let
                      existing = { restaurantList = [ { id = 0, name = "Test", url = "Test", postedBy = "Test", postedOn = "Test" } ], newRestaurant = Nothing, selectedRestaurant = Types.emptyRestaurant }
                      result = Err Http.NetworkError
                    in
                      Expect.equal (existing, Cmd.none) (State.update (Types.UpdateRestaurants result) existing)
            ]
        ]
