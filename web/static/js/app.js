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
const token = window.token;
const elmApp = Elm.App.embed(elmDiv,  { socketUrl, token });

// var service;
// var mapDiv;
// var gmap;
//
// elmApp.ports.googleMap.subscribe(function(url) {
//     console.log("received", url);
//     updateMap(url);
// });
// elmApp.ports.ready.subscribe(function(value) {
//   if (value === "ready") {
//     let myLatlng = new google.maps.LatLng(43, 4.5);
//     let mapOptions = {
//       zoom: 6,
//       center: myLatlng
//     };
//     mapDiv = document.getElementById('map');
//     gmap = new google.maps.Map(mapDiv, mapOptions);
//     service = new google.maps.places.PlacesService(gmap);
//     updateMap("https://www.google.co.jp/maps/place/Authentic/@35.669322,139.7365143,17z/data=!3m1!4b1!4m5!3m4!1s0x60188b84388f5135:0xaa9230919f8256a!8m2!3d35.669322!4d139.738703?hl=en");
//   }
// });
//
// function updateMap(url) {
//   service.getDetails({
//           placeId: 'TradingScreen+Japan+K.K.'
//   }, function(place, status) {
//     if (status === google.maps.places.PlacesServiceStatus.OK) {
//         var marker = new google.maps.Marker({
//           map: gmap,
//           position: place.geometry.location
//         });
//         gmap.setCenter(place.geometry.location);
//     }
//   });
// }
