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
    Types.ShowRestaurant restaurant ->
      ( { model | restaurantList = restaurant :: model.restaurantList }, Cmd.none )
    Types.EditRestaurant restaurant ->
      ( model, Cmd.none )
    Types.AddRestaurant restaurant ->
      ( { model | newRestaurant = (Just Types.emptyRestaurant) }, Cmd.none )
    Types.RemoveRestaurant restaurant ->
      ( { model | restaurantList = (List.filter (\r -> restaurant /= r) model.restaurantList), selectedRestaurant = Types.emptyRestaurant }, Cmd.none )
    Types.SelectRestaurant restaurant ->
      ( { model | selectedRestaurant = restaurant }, Cmd.none )
    Types.Name name ->
      let
        updatedCreateRestaurant = Maybe.map (\r -> { r | name = name }) model.newRestaurant
      in
        ({ model | newRestaurant = updatedCreateRestaurant }, Cmd.none)
    Types.Url url ->
      let
        updatedCreateRestaurant = Maybe.map (\r -> { r | url = url }) model.newRestaurant
      in
        ({ model | newRestaurant = updatedCreateRestaurant }, Cmd.none)
    Types.Create restaurant ->
      (model, createRestaurant (restaurant))
    Types.CreateResult result ->
      case result of
        Ok restaurant ->
          Debug.log("Created !")
          ({ model | newRestaurant = Nothing }, Cmd.none)
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
    Http.send Types.CreateResult (Http.post url body Types.decodeRestaurantResponse)

fetchRestaurants : Cmd Types.Msg
fetchRestaurants =
  let
    url = "/api/restaurants"
  in
    Http.send Types.UpdateRestaurants (Http.get url Types.decodeRestaurantFetch)
