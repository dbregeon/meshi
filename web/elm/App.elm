module App exposing (..)

import Html exposing (Html, text, div)
import Html.Attributes exposing (class)

import Components.RestaurantList as RestaurantList
import Components.CreateRestaurant as CreateRestaurant


-- MODEL

type alias Model =
  { restaurantListModel : RestaurantList.Model
  , createRestaurantModel : CreateRestaurant.Model }

initialModel : Model
initialModel =
  { restaurantListModel = RestaurantList.initialModel
  , createRestaurantModel = CreateRestaurant.initialModel }

init : (Model, Cmd Msg)
init =
  ( initialModel, Cmd.none )

-- UPDATE

type Msg
  = RestaurantListMsg RestaurantList.Msg
  | CreateRestaurantMsg CreateRestaurant.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    RestaurantListMsg restaurantMsg ->
      let (updatedModel, cmd) = RestaurantList.update restaurantMsg model.restaurantListModel
      in ( { model | restaurantListModel = updatedModel }, Cmd.map RestaurantListMsg cmd )
    CreateRestaurantMsg restaurantMsg ->
        let (updatedModel, cmd) = CreateRestaurant.update restaurantMsg model.createRestaurantModel
        in ( { model | createRestaurantModel = updatedModel }, Cmd.map CreateRestaurantMsg cmd )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW

view : Model -> Html Msg
view model =
  div [ class "elm-app" ]
   [ Html.map RestaurantListMsg (RestaurantList.view model.restaurantListModel)
   , Html.map CreateRestaurantMsg (CreateRestaurant.view model.createRestaurantModel) ]


-- MAIN

main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
