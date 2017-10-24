module Restaurants.Types exposing (..)

import Http
import Json.Decode as Decode
import Json.Encode as Encode

type alias Restaurant =
  { name : String, url : String, postedBy : String, postedOn: String }

type alias Restaurants = List Restaurant

type alias Model =
  { restaurantList : Restaurants
  , newRestaurant : Restaurant }

type Msg
  = UpdateRestaurants (Result Http.Error Restaurants)
  | AddRestaurant Restaurant
  | UpdateMap Restaurant
  | Name String
  | Url String
  | Create Restaurant
  | CreateResult (Result Http.Error Restaurant)

initialModel : Model
initialModel =
  { restaurantList = []
  , newRestaurant = emptyRestaurant
  }

emptyRestaurant: Restaurant
emptyRestaurant =
  {name = "", url = "", postedBy = "", postedOn = ""}

decodeRestaurantFetch : Decode.Decoder (List Restaurant)
decodeRestaurantFetch =
  Decode.at ["restaurants"] (Decode.list decodeRestaurantData)

decodeRestaurantData : Decode.Decoder Restaurant
decodeRestaurantData =
  Decode.map4 Restaurant
    (Decode.field "name" Decode.string)
    (Decode.field "url" Decode.string)
    (Decode.field "posted_by" Decode.string)
    (Decode.field "posted_on" Decode.string)

encodeRestaurant: Restaurant -> Encode.Value
encodeRestaurant model =
    Encode.object
        [ ("name", Encode.string model.name)
        , ("url", Encode.string model.url)
        ]
