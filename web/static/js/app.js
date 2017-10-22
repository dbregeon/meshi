// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

// Set up our Elm App
const elmDiv = document.querySelector('#elm-container');
const socketUrl = window.socketUrl;
const elmApp = Elm.App.embed(elmDiv,  { socketUrl });

const mapDiv = document.getElementById('map');

elmApp.ports.googleMap.subscribe(function(url) {
    console.log("received", url);
    let myLatlng = new google.maps.LatLng(10, 5);
    gmap.setCenter(myLatlng);
});

let myLatlng = new google.maps.LatLng(43, 4.5);
let mapOptions = {
  zoom: 6,
  center: myLatlng
};
const gmap = new google.maps.Map(mapDiv, mapOptions);
