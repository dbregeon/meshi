module RestaurantListTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)

import Json.Decode as Decode
import Http
import Components.RestaurantList as RestaurantList

suite : Test
suite =
    describe "In the RestaurantList module"
        [ describe "RestaurantList.decodeRestaurantData" -- Nest as many descriptions as you like.
            [ test "enables to decode a correct input" <|
                \_ ->
                    let
                        jsonString =
                            """
                            {
                              "name": "Test Name",
                              "url": "Test Url",
                              "posted_by": "Test Posted By",
                              "posted_on": "Test Posted On"
                            }
                            """
                        decodedOutput = ( Decode.decodeString RestaurantList.decodeRestaurantData jsonString )
                    in
                      Expect.equal decodedOutput (Ok
                        { name = "Test Name"
                        , url = "Test Url"
                        , postedBy = "Test Posted By"
                        , postedOn = "Test Posted On"
                        }
                    )

            -- Expect.equal is designed to be used in pipeline style, like this.
            , test "fails to decode when posted_on is a number" <|
                \_ ->
                    let
                        jsonString =
                            """
                            {
                              "name": "Test Name",
                              "url": "Test Url",
                              "posted_by": "Test Posted By",
                              "posted_on": 1234
                            }
                            """
                        decodedOutput = ( Decode.decodeString RestaurantList.decodeRestaurantData jsonString )
                    in
                      Expect.equal decodedOutput (Err "Expecting a String at _.posted_on but instead got: 1234")
              ]
        , describe "RestaurantList.update AddRestaurant"
          [ test "updates the empty model with the new restaurant" <|
            \_ ->
                let
                  restaurant = {name = "Test Name", url = "Test URL", postedBy = "Test Posted By", postedOn = "Test Posted On"}
                in
                  Expect.equal ({ restaurants = [restaurant] }, Cmd.none) (RestaurantList.update (RestaurantList.AddRestaurant restaurant) {restaurants = []})
            , test "updates the existing model with the new restaurant" <|
              \_ ->
                  let
                    existing = {name = "Test", url = "Test", postedBy = "Test", postedOn = "Test"}
                    restaurant = {name = "Test Name", url = "Test URL", postedBy = "Test Posted By", postedOn = "Test Posted On"}
                  in
                    Expect.equal ({ restaurants = [restaurant, existing] }, Cmd.none) (RestaurantList.update (RestaurantList.AddRestaurant restaurant) {restaurants = [existing]})
          ]
        , describe "RestaurantList.update UpdateRestaurants"
            [ test "creates a model with the returned list when successful" <|
              \_ ->
                  let
                    restaurant = { name = "Test", url = "Test", postedBy = "Test", postedOn = "Test" }
                    result = Ok [restaurant]
                  in
                    Expect.equal ({ restaurants = [restaurant] }, Cmd.none) (RestaurantList.update (RestaurantList.UpdateRestaurants result) { restaurants = [] } )
              , test "keeps existing model when unsuccessful" <|
                \_ ->
                    let
                      existing = { restaurants = [ { name = "Test", url = "Test", postedBy = "Test", postedOn = "Test" } ] }
                      result = Err Http.NetworkError
                    in
                      Expect.equal (existing, Cmd.none) (RestaurantList.update (RestaurantList.UpdateRestaurants result) existing)
            ]
        ]
