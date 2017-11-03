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
    Types.HideRestaurant restaurant ->
      ( { model | restaurantList = (List.filter (\r -> restaurant /= r) model.restaurantList), selectedRestaurant = Nothing }, Cmd.none )
    Types.EditRestaurant restaurant ->
      ( model, Cmd.none )
    Types.AddRestaurant ->
      ( { model | newRestaurant = (Just Types.emptyRestaurantForm) }, Cmd.none )
    Types.RemoveSelectedRestaurant ->
      case model.selectedRestaurant of
        Just restaurant -> (model, deleteRestaurant (restaurant))
        _ -> ( model, Cmd.none )
    Types.SelectRestaurant restaurant ->
      ( { model | selectedRestaurant = Just restaurant }, Cmd.none )
    Types.Name name ->
      case model.newRestaurant of
        Just newRestaurantForm ->
          let
            currentValue = newRestaurantForm.value
            updatedCreateRestaurant = { currentValue | name = { value = name, error = Nothing } }
          in
            ({ model | newRestaurant = Just (Types.validateRestaurantForm updatedCreateRestaurant) }, Cmd.none)
        _ ->
            ( model, Cmd.none )
    Types.Url url ->
      case model.newRestaurant of
        Just newRestaurantForm ->
          let
            currentValue = newRestaurantForm.value
            updatedCreateRestaurant = { currentValue | url = { value = url, error = Nothing } }
          in
            ({ model | newRestaurant = Just (Types.validateRestaurantForm updatedCreateRestaurant) }, Cmd.none)
        _ ->
          ( model, Cmd.none )
    Types.Create restaurant ->
      (model, createRestaurant (restaurant))
    Types.CreateResult result ->
      case result of
        Ok restaurant ->
          ({ model | newRestaurant = Nothing }, Cmd.none)
        Err error ->
          Debug.log (toString error)
          (model, Cmd.none)
    Types.DeleteResult result ->
      case result of
        Ok restaurant ->
          (model, Cmd.none)
        Err error ->
          Debug.log (toString error)
          (model, Cmd.none)

createRestaurant : Types.RestaurantForm -> Cmd Types.Msg
createRestaurant restaurant =
  let
    url = "/api/restaurants"
    body =
      restaurant
      |> Types.encodeRestaurant
      |> Http.jsonBody
  in
    Http.send Types.CreateResult (Http.post url body Types.decodeRestaurantResponse)

deleteRestaurant : Types.Restaurant -> Cmd Types.Msg
deleteRestaurant restaurant =
  let
    url = String.concat ["/api/restaurants/", toString restaurant.id]
    request = Http.request { method = "DELETE"
    , headers = []
    , url = url
    , body = Http.emptyBody
    , expect = Http.expectJson Types.decodeRestaurantResponse
    , timeout = Nothing
    , withCredentials = False
    }
  in
    Http.send Types.DeleteResult request

fetchRestaurants : Cmd Types.Msg
fetchRestaurants =
  let
    url = "/api/restaurants"
  in
    Http.send Types.UpdateRestaurants (Http.get url Types.decodeRestaurantFetch)
