module Restaurant exposing (view, Model)

import Html exposing (Html, span, strong, em, a, text)
import Html.Attributes exposing (class, href)

type alias Model =
  { name : String, url : String, postedBy : String, postedOn: String }

view : Model -> Html a
view model =
  span [ class "restaurant" ]
    [a [ href model.url ] [ strong [ ] [ text model.name ] ]
    , span [ ] [ text (" Posted by: " ++ model.postedBy) ]
    , em [ ] [ text (" (posted on: " ++ model.postedOn ++ ")") ]
    ]
