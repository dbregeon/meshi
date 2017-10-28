module Restaurants.Types exposing (..)

import Http
import Json.Decode as Decode
import Json.Encode as Encode

type alias Restaurant =
  { name : String, url : String, postedBy : String, postedOn: String }

type alias Restaurants = List Restaurant

type alias Model =
  { restaurantList : Restaurants
  , newRestaurant : Maybe Restaurant
  , selectedRestaurant : Restaurant }

type Msg
  = UpdateRestaurants (Result Http.Error Restaurants)
  | ShowRestaurant Restaurant
  | AddRestaurant Restaurant
  | RemoveRestaurant Restaurant
  | EditRestaurant Restaurant
  | SelectRestaurant Restaurant
  | Create Restaurant
  | Name String
  | Url String
  | CreateResult (Result Http.Error Restaurant)

initialModel : Model
initialModel =
  { restaurantList = []
  , newRestaurant = Nothing
  , selectedRestaurant = emptyRestaurant
  }

emptyRestaurant: Restaurant
emptyRestaurant =
  {name = "", url = "", postedBy = "", postedOn = ""}

decodeRestaurantFetch : Decode.Decoder (List Restaurant)
decodeRestaurantFetch =
  Decode.at ["restaurants"] (Decode.list decodeRestaurantData)

decodeRestaurantResponse : Decode.Decoder Restaurant
decodeRestaurantResponse =
  Decode.at ["restaurant"] decodeRestaurantData

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
