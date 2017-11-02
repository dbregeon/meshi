module Restaurants.View exposing (..)

import Html exposing (Html, span, strong, em, a, text, div, button, input, ul, li, iframe, i)
import Html.Attributes exposing (class, href, id, value, placeholder, type_, width, height, src, style, disabled)
import Html.Events exposing (onClick, onInput)
import FontAwesome.Web as FA

import Restaurants.Types as Types

view: Types.Model -> Html Types.Msg
view model =
  div [ class "restaurants-panel"]
      [ (renderRestaurantMaster model)
      , div [class "restaurant-detail col-md-8 col-sm-12"]
        [ iframe [src model.selectedRestaurant.url, style [("border", "0")]] [] ]
      ]

renderRestaurantMaster: Types.Model -> Html Types.Msg
renderRestaurantMaster model =
  div [ class "restaurant-master col-md-4 col-sm-12" ]
   ( (renderRestaurantList model.restaurantList model.selectedRestaurant)
   :: div [] [ button [ onClick (Types.RemoveRestaurant model.selectedRestaurant), class "btn btn-danger restaurant-remove-btn", disabled (model.selectedRestaurant == Types.emptyRestaurant)] [ FA.minus ] ]
   :: div [] [ button [ onClick (Types.AddRestaurant model.selectedRestaurant), class "btn btn-primary restaurant-add-btn"] [ FA.plus ] ]
   :: (renderCreateRestaurantForm model.newRestaurant) )

renderRestaurant : Types.Restaurant -> Html Types.Msg
renderRestaurant restaurant =
 span [ class "restaurant" ]
  [ strong [ ] [ text restaurant.name ] ]

renderRestaurantList : Types.Restaurants -> Types.Restaurant -> Html Types.Msg
renderRestaurantList restaurants selection =
 ul [ class "list-group restaurant-list" ] ( List.map
   (\r -> li [ class (selectionClass r selection), onClick (Types.SelectRestaurant r) ]
          [ renderRestaurant r
          , span [ onClick (Types.EditRestaurant r), class "btn restaurant-edit-btn"] [ FA.edit ] ])
   restaurants )

selectionClass : Types.Restaurant -> Types.Restaurant -> String
selectionClass restaurant selection =
  if restaurant == selection then "restaurant-selected list-group-item" else "list-group-item"

renderCreateRestaurantForm : Maybe Types.Restaurant -> List (Html Types.Msg)
renderCreateRestaurantForm model =
  case model of
    Nothing ->
      []
    Just restaurant ->
      [ div [ class "dropdown restaurant-create form-inline" ]
        [ input [ class "form-control", type_ "name", placeholder "Name", onInput Types.Name, value restaurant.name ] []
        , input [ class "form-control", type_ "url", placeholder "Url", onInput Types.Url, value restaurant.url ] []
        , button [ onClick (Types.Create restaurant), class "btn btn-primary" ] [ text "Add" ]
        ] ]
