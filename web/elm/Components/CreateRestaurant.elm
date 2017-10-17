module Components.CreateRestaurant exposing (..)

import Html exposing (Html, text, input, div, button)
import Html.Attributes exposing (class, placeholder, type_, value)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Components.Restaurant as Restaurant
import Components.RestaurantList as RestaurantList

type alias Model = Restaurant.Model

type Msg
  = Name String
  | Url String
  | Create Model
  | CreateResult (Result Http.Error Model)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Name name ->
      ({ model | name = name }, Cmd.none)
    Url url ->
      ({ model | url = url }, Cmd.none)
    Create restaurant ->
      (model, createRestaurant (restaurant))
    CreateResult result ->
      case result of
      Ok restaurant ->
        (initialModel , Cmd.none)
      Err error ->
        Debug.log (toString error)
        (model, Cmd.none)

createRestaurant : Model -> Cmd Msg
createRestaurant restaurant =
  let
    url = "/api/restaurants"
    body =
      restaurant
      |> encodeRestaurant
      |> Http.jsonBody
  in
    Http.send CreateResult (Http.post url body decodeRestaurantCreate)

encodeRestaurant: Model -> Encode.Value
encodeRestaurant model =
    Encode.object
        [ ("name", Encode.string model.name)
        , ("url", Encode.string model.url)
        ]

decodeRestaurantCreate : Decode.Decoder Restaurant.Model
decodeRestaurantCreate =
  Decode.at ["restaurant"] decodeRestaurantData

decodeRestaurantData : Decode.Decoder Restaurant.Model
decodeRestaurantData =
  Decode.map4 Restaurant.Model
    (Decode.field "name" Decode.string)
    (Decode.field "url" Decode.string)
    (Decode.field "posted_by" Decode.string)
    (Decode.field "posted_on" Decode.string)

initialModel : Model
initialModel =
  {name = "", url = "", postedBy = "", postedOn = ""}

view : Model -> Html Msg
view model =
   div []
    [ input [ type_ "name", placeholder "Name", onInput Name, value model.name ] []
    , input [ type_ "url", placeholder "Url", onInput Url, value model.url ] []
    , button [ onClick (Create model), class "btn btn-primary" ] [ text "Add" ]
    ]
