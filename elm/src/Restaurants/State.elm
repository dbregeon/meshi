module Restaurants.State exposing (update, fetchRestaurants)

import Http
import Debug
import Restaurants.Types as Types
import Restaurants.Ports as Ports

update : Types.Msg -> Types.Model -> (Types.Model, Cmd Types.Msg)
update msg model =
  case msg of
    Types.UpdateRestaurants result ->
     case result of
      Ok restaurantList ->
        ({ model | restaurantList = restaurantList }, Cmd.none)
      Err error ->
        Debug.log (toString error)
        (model, Cmd.none)
    Types.AddRestaurant restaurant ->
      ( { model | restaurantList = restaurant :: model.restaurantList }, Cmd.none )
    Types.UpdateMap restaurant ->
      ( model , Ports.googleMap restaurant.url )
    Types.Name name ->
      let
        current = model.newRestaurant
        updatedCreateRestaurant = { current | name = name }
      in
        ({ model | newRestaurant = updatedCreateRestaurant }, Cmd.none)
    Types.Url url ->
      let
        current = model.newRestaurant
        updatedCreateRestaurant = {current | url = url }
      in
        ({ model | newRestaurant = updatedCreateRestaurant }, Cmd.none)
    Types.Create restaurant ->
      (model, createRestaurant (restaurant))
    Types.CreateResult result ->
      case result of
        Ok restaurant ->
          ({ model | newRestaurant = Types.emptyRestaurant }, Cmd.none)
        Err error ->
          Debug.log (toString error)
          (model, Cmd.none)

createRestaurant : Types.Restaurant -> Cmd Types.Msg
createRestaurant restaurant =
  let
    url = "/api/restaurants"
    body =
      restaurant
      |> Types.encodeRestaurant
      |> Http.jsonBody
  in
    Http.send Types.CreateResult (Http.post url body Types.decodeRestaurantData)

fetchRestaurants : Cmd Types.Msg
fetchRestaurants =
  let
    url = "/api/restaurants"
  in
    Http.send Types.UpdateRestaurants (Http.get url Types.decodeRestaurantFetch)
