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
        [ iframe [src (Maybe.withDefault "" (Maybe.map (\r->r.url) model.selectedRestaurant)), style [("border", "0")]] [] ]
      ]

renderRestaurantMaster: Types.Model -> Html Types.Msg
renderRestaurantMaster model =
  div [ class "restaurant-master col-md-4 col-sm-12" ]
   ( (renderRestaurantList model.restaurantList model.selectedRestaurant)
   :: div [] [ button [ onClick (Types.RemoveSelectedRestaurant), class "btn btn-danger restaurant-remove-btn", disabled (Maybe.withDefault True (Maybe.map (\r->False) model.selectedRestaurant) )] [ FA.minus ]
             , button [ onClick (Types.AddRestaurant), class "btn btn-primary restaurant-add-btn"] [ FA.plus ] ]
   :: (renderCreateRestaurantForm model.newRestaurant) )

renderRestaurant : Types.Restaurant -> Html Types.Msg
renderRestaurant restaurant =
 span [ class "restaurant" ]
  [ strong [ ] [ text restaurant.name ] ]

renderRestaurantList : Types.Restaurants -> Maybe Types.Restaurant -> Html Types.Msg
renderRestaurantList restaurants selection =
 ul [ class "list-group restaurant-list" ] ( List.map
   (\r -> li [ class (selectionClass r selection), onClick (Types.SelectRestaurant r) ]
          [ renderRestaurant r
          , span [ onClick (Types.EditRestaurant r), class "btn restaurant-edit-btn"] [ FA.edit ] ])
   restaurants )

selectionClass : Types.Restaurant -> Maybe Types.Restaurant -> String
selectionClass restaurant selection =
  String.append "list-group-item" (case selection of
    Just selectedRestaurant -> if restaurant == selectedRestaurant then " restaurant-selected" else ""
    _ -> "")

renderCreateRestaurantForm : Maybe (Types.Input Types.RestaurantForm) -> List (Html Types.Msg)
renderCreateRestaurantForm model =
  case model of
    Nothing ->
      []
    Just restaurant ->
      [ div [ class "dropdown restaurant-create form-inline" ]
        [ input [ class "form-control", type_ "name", placeholder "Name", onInput Types.Name, value restaurant.value.name.value ] []
        , input [ class "form-control", type_ "url", placeholder "Url", onInput Types.Url, value restaurant.value.url.value ] []
        , button [ onClick (Types.Create restaurant.value), class "btn btn-primary", disabled (Types.restaurantFormIsValid restaurant) ] [ text "Add" ]
        ] ]
