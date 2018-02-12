module Restaurants.Types exposing (..)

import Http
import Json.Decode as Decode
import Json.Encode as Encode

type alias Restaurant =
  { id: Int
  , name : String
  , url : String
  , postedBy : String
  , postedOn: String
  , opinion: Opinion }

type alias Opinion = String

type alias Restaurants = List Restaurant

type alias RestaurantForm =
  { name : Input String, url : Input String }

type alias OpinionForm =
  { restaurantId : Int, opinion : Input String }

type alias Input a =
  {value: a, error: Maybe String}

type alias Model =
  { restaurantList : Restaurants
  , newRestaurant : Maybe (Input RestaurantForm)
  , opinionForm : Maybe (Input OpinionForm)
  , selectedRestaurant : Maybe Restaurant
  , token : String }

type Msg
  = UpdateRestaurants (Result Http.Error Restaurants)
  | ShowRestaurant Restaurant
  | HideRestaurant Restaurant
  | AddRestaurant
  | RemoveSelectedRestaurant
  | SelectRestaurant Restaurant
  | Create RestaurantForm
  | EditOpinion Restaurant
  | Update OpinionForm String
  | Name String
  | Url String
  | CreateResult (Result Http.Error Restaurant)
  | DeleteResult (Result Http.Error Restaurant)
  | UpdateOpinionResult (Result Http.Error Opinion)


initialModel : String -> Model
initialModel token =
  { restaurantList = []
  , newRestaurant = Nothing
  , opinionForm = Nothing
  , selectedRestaurant = Nothing
  , token = token
  }

emptyRestaurantForm: Input RestaurantForm
emptyRestaurantForm =
  {value = {name = { value = "", error = Nothing }, url = { value = "", error = Nothing }}, error = Nothing}

emptyOpinionForm: Int -> Input OpinionForm
emptyOpinionForm restaurantId =
  {value = {restaurantId = restaurantId, opinion = {value = "", error = Nothing}}, error = Nothing}

validateRestaurantForm: RestaurantForm -> Input RestaurantForm
validateRestaurantForm form =
  let
    validatedName = validateName(form)
    validatedUrl  = validateUrl(form)
  in
    {value = { name = validatedName, url = validatedUrl}, error = Nothing }

validateOpinionForm: OpinionForm -> Input OpinionForm
validateOpinionForm form =
  let
    validatedOpinion = validateOpinion(form)
  in
    {value = {restaurantId = form.restaurantId, opinion = validatedOpinion}, error = Nothing }

restaurantFormIsValid: Input RestaurantForm -> Bool
restaurantFormIsValid form =
  case [form.error, form.value.name.error, form.value.url.error] of
    [Nothing, Nothing, Nothing] -> True
    _ -> False

opinionFormIsValid: Input OpinionForm -> Bool
opinionFormIsValid form =
  case [form.error, form.value.opinion.error] of
    [Nothing, Nothing] -> True
    _ -> False

validateName: RestaurantForm -> Input String
validateName f =
  let
    current = f.name.value
  in
    { value = current, error = (case current of
    "" -> Just "cannot be empty"
    _  -> Nothing) }


validateUrl: RestaurantForm -> Input String
validateUrl f =
  let
    -- Google Map Embed URL.
    prefix = "https://www.google.com/maps/embed?pb="
    current = f.url.value
  in
    { value = current, error = (if String.startsWith prefix current
      then Just (String.append "should start with " prefix)
      else Nothing) }

validateOpinion: OpinionForm -> Input String
validateOpinion f =
  let
    current = f.opinion.value
  in
    { value = current, error = (case current of
    "" -> Just "cannot be empty"
    "Like" -> Nothing
    "Neutral" -> Nothing
    "Dislike" -> Nothing
    _  -> Just "invalid value") }

decodeRestaurantFetch : Decode.Decoder (List Restaurant)
decodeRestaurantFetch =
  Decode.at ["restaurants"] (Decode.list decodeRestaurantData)

decodeRestaurantResponse : Decode.Decoder Restaurant
decodeRestaurantResponse =
  Decode.at ["restaurant"] decodeRestaurantData

decodeRestaurantData : Decode.Decoder Restaurant
decodeRestaurantData =
  Decode.map6 Restaurant
    (Decode.field "id" Decode.int)
    (Decode.field "name" Decode.string)
    (Decode.field "url" Decode.string)
    (Decode.field "posted_by" Decode.string)
    (Decode.field "posted_on" Decode.string)
    (Decode.field "opinion" Decode.string)

encodeRestaurant: RestaurantForm -> Encode.Value
encodeRestaurant model =
    Encode.object
        [ ("name", Encode.string model.name.value)
        , ("url", Encode.string model.url.value)
        ]

encodeOpinion: OpinionForm -> Encode.Value
encodeOpinion model =
  Encode.object [ ("opinion", Encode.string model.opinion.value) ]

decodeOpinionResponse : Decode.Decoder Opinion
decodeOpinionResponse =
  Decode.at ["opinion"] Decode.string
