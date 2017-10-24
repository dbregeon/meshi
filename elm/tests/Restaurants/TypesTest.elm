module Restaurants.TypesTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)

import Json.Decode as Decode
import Http
import Restaurants.Types as Types

suite : Test
suite =
    describe "In the Types module"
        [ describe "Types.decodeRestaurantData" -- Nest as many descriptions as you like.
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
                        decodedOutput = ( Decode.decodeString Types.decodeRestaurantData jsonString )
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
                        decodedOutput = ( Decode.decodeString Types.decodeRestaurantData jsonString )
                    in
                      Expect.equal decodedOutput (Err "Expecting a String at _.posted_on but instead got: 1234")
              ]
        ]
