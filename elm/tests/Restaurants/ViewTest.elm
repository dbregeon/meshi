module Restaurants.ViewTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)

import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag)

import Restaurants.Types as Types
import Restaurants.View as View

suite : Test
suite =
    describe "In the View module"
        [ describe "View.renderRestaurant" -- Nest as many descriptions as you like.
            [ test "shows the name of the restaurant" <|
                \_ ->
                    let
                        model = {
                         restaurantList = [
                            {
                              name = "Test Name",
                              url = "Test Url",
                              postedBy = "Test Posted By",
                              postedOn = "Test Posted On"
                            } ]
                          , newRestaurant = Types.emptyRestaurant
                        }
                        view = View.view model
                    in
                        view
                         |> Query.fromHtml
                         |> Query.find [ tag "strong"]
                         |> Query.has [ text "Test Name" ]
              ]
        ]
