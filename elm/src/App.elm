port module App exposing (..)

import Html exposing (Html, text, div)
import Html.Attributes exposing (class, id)
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Debug
import Task
import Json.Encode as Encode
import Json.Decode as Decode

import Components.RestaurantList as RestaurantList
import Components.CreateRestaurant as CreateRestaurant
import Components.Restaurant as Restaurant
import Components.Ports as Ports

-- MODEL
type alias Flags =
    { socketUrl : String }

type alias Model =
  { restaurantListModel : RestaurantList.Model
  , createRestaurantModel : CreateRestaurant.Model
  , phxSocket : Phoenix.Socket.Socket Msg }

type Msg
  = RestaurantListMsg RestaurantList.Msg
    | CreateRestaurantMsg CreateRestaurant.Msg
    | NewMessage Encode.Value
    | PhoenixMsg (Phoenix.Socket.Msg Msg)


type alias SendMsg =
      { topic : String
      , event: String
      , payload : String
      , ref : String
      }

initialModel : Flags -> Model
initialModel flags =
  { restaurantListModel = RestaurantList.initialModel
  , createRestaurantModel = CreateRestaurant.initialModel
  , phxSocket =  initPhxSocket flags }

initPhxSocket : Flags -> Phoenix.Socket.Socket Msg
initPhxSocket flags =
    Phoenix.Socket.init flags.socketUrl
        |> Phoenix.Socket.withDebug
        |> Phoenix.Socket.on "change" "restaurants" NewMessage

init : Flags -> (Model, Cmd Msg)
init flags =
  let
    model = initialModel flags
    channel = Phoenix.Channel.init "restaurants"
    ( phxSocket, phxCmd ) = Phoenix.Socket.join channel model.phxSocket
  in
    ( { model | phxSocket = phxSocket }
    , Cmd.batch [ Cmd.map PhoenixMsg phxCmd, Cmd.map RestaurantListMsg RestaurantList.fetchRestaurants, (Ports.ready "ready") ])

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    RestaurantListMsg restaurantMsg ->
      let (updatedModel, cmd) = RestaurantList.update restaurantMsg model.restaurantListModel
      in ( { model | restaurantListModel = updatedModel }, Cmd.map RestaurantListMsg cmd )
    CreateRestaurantMsg restaurantMsg ->
        let (updatedModel, cmd) = CreateRestaurant.update restaurantMsg model.createRestaurantModel
        in ( { model | createRestaurantModel = updatedModel }, Cmd.map CreateRestaurantMsg cmd )
    NewMessage raw ->
      case Decode.decodeValue RestaurantList.decodeRestaurantData raw of
        Ok restaurant ->
          update ( RestaurantListMsg ( RestaurantList.AddRestaurant restaurant ) ) model
        Err error ->
          model ! []
    PhoenixMsg msg ->
      let
        ( phxSocket, phxCmd ) = Phoenix.Socket.update msg model.phxSocket
      in
        ( { model | phxSocket = phxSocket } , Cmd.map PhoenixMsg phxCmd )

encoder : SendMsg -> String
encoder m =
    Encode.object
        [ ("topic", Encode.string m.topic)
        , ("event", Encode.string m.event)
        , ("payload", Encode.string m.payload)
        , ("ref", Encode.string m.ref)
        ]
    |> Encode.encode 0

subscriptions : Model -> Sub Msg
subscriptions model =
   Phoenix.Socket.listen model.phxSocket PhoenixMsg

-- VIEW

view : Model -> Html Msg
view model =
  div [ class "elm-app" ]
   [ div [ class "restaurants-panel"]
      [ div [class "restaurant-master" ]
        [ Html.map RestaurantListMsg (RestaurantList.view model.restaurantListModel)
        , Html.map CreateRestaurantMsg (CreateRestaurant.view model.createRestaurantModel) ]
      , div [id "map", class "restaurant-map"] [] ] ]


-- MAIN

main : Program Flags Model Msg
main =
  Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
