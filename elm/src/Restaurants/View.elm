module Restaurants.View exposing (..)

import Html exposing (Html, span, strong, em, a, text, div, button, input, ul, li)
import Html.Attributes exposing (class, href, id, value, placeholder, type_)
import Html.Events exposing (onClick, onInput)

import Restaurants.Types as Types

view: Types.Model -> Html Types.Msg
view model =
  div [ class "restaurants-panel"]
      [ div [class "restaurant-master" ]
        [ (renderRestaurantList model.restaurantList)
        , (renderCreateRestaurantForm model.newRestaurant) ]
      , div [id "map", class "restaurant-map"] [] ]

renderRestaurant : Types.Restaurant -> Html Types.Msg
renderRestaurant restaurant =
 span [ class "restaurant" ]
  [a [ href restaurant.url ]
    [ strong [ ] [ text restaurant.name ] ]
    , span [ ] [ text (" Posted by: " ++ restaurant.postedBy) ]
    , em [ ] [ text (" (posted on: " ++ restaurant.postedOn ++ ")") ] ]

renderRestaurantList : Types.Restaurants -> Html Types.Msg
renderRestaurantList restaurants =
 ul [ class "restaurant-list" ] ( List.map
   (\r -> li [ onClick (Types.UpdateMap r) ] [ renderRestaurant r ])
   restaurants )

renderCreateRestaurantForm : Types.Restaurant -> Html Types.Msg
renderCreateRestaurantForm model =
   div [ class "restaurant-create form-inline" ]
    [ input [ class "form-control", type_ "name", placeholder "Name", onInput Types.Name, value model.name ] []
    , input [ class "form-control", type_ "url", placeholder "Url", onInput Types.Url, value model.url ] []
    , button [ onClick (Types.Create model), class "btn btn-primary" ] [ text "Add" ]
    ]
