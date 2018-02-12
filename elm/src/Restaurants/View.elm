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
   ( (renderRestaurantList model.restaurantList model.selectedRestaurant model.opinionForm)
   :: div [] [ button [ onClick (Types.RemoveSelectedRestaurant), class "btn btn-danger restaurant-remove-btn", disabled (Maybe.withDefault True (Maybe.map (\r->False) model.selectedRestaurant) )] [ FA.minus ]
             , button [ onClick (Types.AddRestaurant), class "btn btn-primary restaurant-add-btn"] [ FA.plus ] ]
   :: (renderCreateRestaurantForm model.newRestaurant) )

renderRestaurant : Types.Restaurant -> Html Types.Msg
renderRestaurant restaurant =
 span [ class "restaurant" ]
  [ strong [ ] [ text restaurant.name ] ]

renderRestaurantList : Types.Restaurants -> Maybe Types.Restaurant -> Maybe (Types.Input Types.OpinionForm)  -> Html Types.Msg
renderRestaurantList restaurants selection opinion =
 ul [ class "list-group restaurant-list" ] ( List.map
   (\r -> li [ class (selectionClass r selection), onClick (Types.SelectRestaurant r) ]
          ( renderRestaurant r
          :: span [ onClick (Types.EditOpinion r), class "btn restaurant-edit-btn"] [ (opinionCharacter r) ]
          :: if (isSelected r selection) then (renderEditOpinionForm opinion) else []))
   restaurants )

opinionCharacter : Types.Restaurant -> Html msg
opinionCharacter restaurant =
  case restaurant.opinion of
    "Neutral" ->
      FA.meh_o
    "Like" ->
      FA.thumbs_up
    "Dislike" ->
      FA.thumbs_down
    _ ->
      FA.question

selectionClass : Types.Restaurant -> Maybe Types.Restaurant -> String
selectionClass restaurant selection =
  String.append "list-group-item" (if (isSelected restaurant selection) then " restaurant-selected" else "")

isSelected:  Types.Restaurant -> Maybe Types.Restaurant -> Bool
isSelected restaurant selection =
  case selection of
    Just selectedRestaurant -> restaurant == selectedRestaurant
    _ -> False

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

renderEditOpinionForm : Maybe (Types.Input Types.OpinionForm) -> List (Html Types.Msg)
renderEditOpinionForm model =
  case model of
    Nothing ->
      []
    Just opinion ->
      [ div [ class "dropdown opinion-edit form-inline" ]
        [ span [ onClick (Types.Update opinion.value "Like"), class "btn opinion-edit-btn"] [ FA.thumbs_up ]
        , span [ onClick (Types.Update opinion.value "Neutral"), class "btn opinion-edit-btn"] [ FA.meh_o ]
        , span [ onClick (Types.Update opinion.value "Dislike"), class "btn opinion-edit-btn"] [ FA.thumbs_down ]
        ] ]
