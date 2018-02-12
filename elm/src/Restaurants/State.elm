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
    Types.AddRestaurant ->
      ( { model | newRestaurant = (Just Types.emptyRestaurantForm) }, Cmd.none )
    Types.RemoveSelectedRestaurant ->
      case model.selectedRestaurant of
        Just restaurant -> (model, deleteRestaurant (restaurant) model.token)
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
      (model, createRestaurant (restaurant) model.token)
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
    Types.EditOpinion restaurant ->
      ( { model | opinionForm = Just (Types.emptyOpinionForm restaurant.id)  }, Cmd.none )
    Types.Update opinion newValue ->
      let
        newOpinion = Types.validateOpinionForm {opinion | opinion = {value = newValue, error = Nothing} }
        newModel = {model | opinionForm = (Just newOpinion) }
      in
        case newOpinion.error of
          Nothing -> (newModel, updateOpinion (newOpinion.value) model.token)
          _ -> (newModel, Cmd.none)
    Types.UpdateOpinionResult result ->
      case result of
        Ok opinion ->
          ({ model | opinionForm = Nothing }, Cmd.none)
        Err error ->
          Debug.log (toString error)
          (model, Cmd.none)


createRestaurant : Types.RestaurantForm -> String -> Cmd Types.Msg
createRestaurant restaurant token =
  let
    url = "/api/restaurants"
    body =
      restaurant
      |> Types.encodeRestaurant
      |> Http.jsonBody
    post =  Http.request { method = "POST"
    , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
    , url = url
    , body = body
    , expect = Http.expectJson Types.decodeRestaurantResponse
    , timeout = Nothing
    , withCredentials = False
    }
  in
    Http.send Types.CreateResult post

updateOpinion : Types.OpinionForm -> String -> Cmd Types.Msg
updateOpinion opinion token =
  let
    url = "/api/opinions"
    body =
      opinion
      |> Types.encodeOpinion
      |> Http.jsonBody
    post =  Http.request { method = "POST"
    , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
    , url = url
    , body = body
    , expect = Http.expectJson Types.decodeOpinionResponse
    , timeout = Nothing
    , withCredentials = False
    }
  in
    Http.send Types.UpdateOpinionResult post

deleteRestaurant : Types.Restaurant -> String -> Cmd Types.Msg
deleteRestaurant restaurant token =
  let
    url = String.concat ["/api/restaurants/", toString restaurant.id]
    request = Http.request { method = "DELETE"
    , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
    , url = url
    , body = Http.emptyBody
    , expect = Http.expectJson Types.decodeRestaurantResponse
    , timeout = Nothing
    , withCredentials = False
    }
  in
    Http.send Types.DeleteResult request

fetchRestaurants : String -> Cmd Types.Msg
fetchRestaurants token  =
  let
    url = "/api/restaurants"
    get =  Http.request { method = "GET"
    , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
    , url = url
    , body = Http.emptyBody
    , expect = Http.expectJson Types.decodeRestaurantFetch
    , timeout = Nothing
    , withCredentials = False
    }
  in
    Http.send Types.UpdateRestaurants get
