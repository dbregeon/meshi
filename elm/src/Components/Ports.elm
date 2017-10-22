port module Components.Ports exposing (..)

port googleMap : String -> Cmd msg

port dispatchCreate : (String -> msg) -> Sub msg
