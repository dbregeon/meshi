module Restaurants.ViewTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)

import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, class)

import Restaurants.Types as Types
import Restaurants.View as View

suite : Test
suite =
    describe "In the View module"
        [ describe "View.renderRestaurant"
            [ test "shows the name of the restaurant" <|
                \_ ->
                    let
                        restaurant = {
                              name = "Test Name",
                              url = "Test Url",
                              postedBy = "Test Posted By",
                              postedOn = "Test Posted On" }
                        view = View.renderRestaurant restaurant
                    in
                        view
                         |> Query.fromHtml
                         |> Query.find [ tag "strong"]
                         |> Query.has [ text "Test Name" ]
              ]
          , describe "View.renderRestaurantList"
              [ test "shows a restaurant-list list" <|
                \_ ->
                    let
                      restaurantList = [
                            {
                              name = "Test Name",
                              url = "Test Url",
                              postedBy = "Test Posted By",
                              postedOn = "Test Posted On"
                            } ]
                      view = View.renderRestaurantList restaurantList
                    in
                        view
                         |> Query.fromHtml
                         |> Query.has [ tag "ul", class "restaurant-list"]
                , test "shows the restaurants as li" <|
                  \_ ->
                      let
                        restaurantList =
                           [ { name = "Test Name"
                             , url = "Test Url"
                             , postedBy = "Test Posted By"
                             , postedOn = "Test Posted On" }
                           , { name = "Other Name"
                             , url = "Other Url"
                             , postedBy = "Other Posted By"
                             , postedOn = "Other Posted On" } ]
                        view = View.renderRestaurantList restaurantList
                      in
                          view
                           |> Query.fromHtml
                           |> Query.findAll [ tag "li"]
                           |> Query.count (Expect.equal 2)
                , test "shows the restaurants as rendered by renderRestaurant" <|
                  \_ ->
                      let
                        restaurantList =
                           [ { name = "Test Name"
                             , url = "Test Url"
                             , postedBy = "Test Posted By"
                             , postedOn = "Test Posted On" }
                           , { name = "Other Name"
                             , url = "Other Url"
                             , postedBy = "Other Posted By"
                             , postedOn = "Other Posted On" } ]
                        view = View.renderRestaurantList restaurantList
                      in
                          view
                           |> Query.fromHtml
                           |> Query.findAll [ tag "li"]
                           |> Expect.all
                             (List.indexedMap ( \i -> \r -> Query.index i
                                                         >> Query.contains [(View.renderRestaurant r)] )
                                              restaurantList)
              ]
        ]
