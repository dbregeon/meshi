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
        [ describe "Types.decodeRestaurantData"
            [ test "enables to decode a correct input" <|
                \_ ->
                    let
                        jsonString =
                            """
                            {
                              "id": 0,
                              "name": "Test Name",
                              "url": "Test Url",
                              "posted_by": "Test Posted By",
                              "posted_on": "Test Posted On"
                            }
                            """
                        decodedOutput = ( Decode.decodeString Types.decodeRestaurantData jsonString )
                    in
                      Expect.equal decodedOutput (Ok
                        { id = 0
                        , name = "Test Name"
                        , url = "Test Url"
                        , postedBy = "Test Posted By"
                        , postedOn = "Test Posted On"
                        }
                    )

            , test "fails to decode when id is not a number" <|
                \_ ->
                    let
                        jsonString =
                            """
                            { "id": "Test"
                              "name": "Test Name",
                              "url": "Test Url",
                              "posted_by": "Test Posted By",
                              "posted_on": "Test Posted On"
                            }
                            """
                        decodedOutput = ( Decode.decodeString Types.decodeRestaurantData jsonString )
                    in
                      Expect.equal decodedOutput (Err "Given an invalid JSON: Unexpected string in JSON at position 74")
              ]
        ]
