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

import Ports
import Restaurants.Types as Types
import Restaurants.View as View
import Restaurants.State as State

-- MODEL
type alias Flags =
    { socketUrl : String }

type alias Model =
  { restaurants : Types.Model
  , phxSocket : Phoenix.Socket.Socket Msg }

type Msg
  = RestaurantsMsg Types.Msg
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
  { restaurants = Types.initialModel
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
    , Cmd.batch [ Cmd.map PhoenixMsg phxCmd, Cmd.map RestaurantsMsg State.fetchRestaurants, (Ports.ready "ready") ])

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    RestaurantsMsg restaurantMsg ->
      let (updatedModel, cmd) = State.update restaurantMsg model.restaurants
      in ( { model | restaurants = updatedModel }, Cmd.map RestaurantsMsg cmd )
    NewMessage raw ->
      case Decode.decodeValue Types.decodeRestaurantData raw of
        Ok restaurant ->
          update ( RestaurantsMsg ( Types.AddRestaurant restaurant ) ) model
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
    [ Html.map RestaurantsMsg (View.view model.restaurants) ]

-- MAIN

main : Program Flags Model Msg
main =
  Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
