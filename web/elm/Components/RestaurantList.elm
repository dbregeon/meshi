module Components.RestaurantList exposing (..)

import Html exposing (Html, text, ul, li, div, h2, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Debug
import List
import Restaurant

type alias Model =
  { restaurants: List Restaurant.Model }

type Msg
  = NoOp
  | Fetch
  | UpdateRestaurants (Result Http.Error (List Restaurant.Model))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
    Fetch ->
      (model, fetchRestaurants)
    UpdateRestaurants result ->
     case result of
      Ok restaurantList ->
        (Model restaurantList, Cmd.none)
      Err error ->
        Debug.log (toString error)
        (model, Cmd.none)

-- HTTP calls
fetchRestaurants : Cmd Msg
fetchRestaurants =
  let
    url = "/api/restaurants"
  in
    Http.send UpdateRestaurants (Http.get url decodeRestaurantFetch)

-- Fetch the articles out of the "data" key
decodeRestaurantFetch : Decode.Decoder (List Restaurant.Model)
decodeRestaurantFetch =
  Decode.at ["restaurants"] decodeRestaurantList

-- Then decode the "data" key into a List of Article.Models
decodeRestaurantList : Decode.Decoder (List Restaurant.Model)
decodeRestaurantList =
  Decode.list decodeRestaurantData

-- Finally, build the decoder for each individual Article.Model
decodeRestaurantData : Decode.Decoder Restaurant.Model
decodeRestaurantData =
  Decode.map4 Restaurant.Model
    (Decode.field "name" Decode.string)
    (Decode.field "url" Decode.string)
    (Decode.field "posted_by" Decode.string)
    (Decode.field "posted_on" Decode.string)

renderRestaurant : Restaurant.Model -> Html a
renderRestaurant restaurant =
  li [ ] [ Restaurant.view restaurant ]

renderRestaurants : Model -> List (Html a)
renderRestaurants model =
   List.map renderRestaurant model.restaurants

initialModel : Model
initialModel =
  { restaurants = [] }

view : Model -> Html Msg
view model =
  div [ class "restaurant-list" ] [
    h2 [] [ text "Restaurant List" ],
    button [ onClick Fetch, class "btn btn-primary" ] [ text "Fetch Restaurants" ],
    ul [] (renderRestaurants model)]
