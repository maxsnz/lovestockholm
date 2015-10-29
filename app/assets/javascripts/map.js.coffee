#= require jquery-2.1.4.min

$ ->
  console.log 'maps works'
  $('.newroute').click ->
    goStart()
  $('.goabout').click (e) ->
    e.preventDefault()



window.initMap = ->
  directionsService = new (google.maps.DirectionsService)
  directionsDisplay = new (google.maps.DirectionsRenderer)({polylineOptions: {strokeColor: "#949fa1"}})
  map = new (google.maps.Map)(document.getElementById('map'),
    zoom: 7
    disableDefaultUI: true
    center:
      lat: 60.2312266
      lng: 28.0543429)
  map.setOptions({styles: styles})
  directionsDisplay.setMap map

  onChangeHandler = ->
    calculateAndDisplayRoute directionsService, directionsDisplay
    return

  $('.calculate-button').click (e) ->
    e.preventDefault() 
    onChangeHandler() if $('.map-input').val().length > 0
  return

goFinish = () ->
  $('.part_start').fadeOut()
  $('.part_finish').fadeIn()

goStart = () ->
  $('.part_start').fadeIn()
  $('.part_finish').fadeOut()

calculateAndDisplayRoute = (directionsService, directionsDisplay) ->
  # waypts = []
  # waypts.push({location: {lat: 59.4391392, lng: 21.8744661}, stopover: false})
  # # waypts.push({location: {lat: 59.9248334, lng: 24.8792533}, stopover: true})
  # directionsService.route {
  #   # origin: $('#input').val()
  #   origin: 'Хельсинки, Olympiaranta 1'
  #   # destination: 'Хельсинки, Olympiaranta 1'
  #   # destination: {lat: 59.4391392, lng: 21.8744661}
  #   destination: 'Сткогольм'
  #   waypoints: waypts
  #   # travelMode: google.maps.TravelMode.TRANSIT
  #   travelMode: google.maps.TravelMode.DRIVING
  # }, (response, status) ->
  #   if status == google.maps.DirectionsStatus.OK
  #     directionsDisplay.setDirections response
  #   else
  #     window.alert 'Directions request failed due to ' + status

  directionsService.route {
    origin: $('.map-input').val()
    destination: 'Хельсинки, Olympiaranta 1'
    travelMode: google.maps.TravelMode.DRIVING
  }, (response, status) ->
    if status == google.maps.DirectionsStatus.OK
      directionsDisplay.setDirections response
      console.log response.routes[0].legs[0].duration
      $('.route-car').html(response.routes[0].legs[0].duration.text)
      goFinish()
    else
      window.alert 'Маршрут не найден, попробуйте еще раз'


  # https://developers.google.com/maps/documentation/javascript/examples/polyline-simple
styles = [
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      { "color": "#115698" }
    ]
  },{
    "featureType": "landscape",
    "elementType": "geometry",
    "stylers": [
      { "color": "#1464b0" }
    ]
  },{
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      { "color": "#3379bb" },
      { "weight": 0.1 },
      { "visibility": "off" }
    ]
  },{
    "elementType": "labels.text.stroke",
    "stylers": [
      { "visibility": "on" },
      { "weight": 3.1 },
      { "color": "#1567b5" }
    ]
  },{
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      { "color": "#0b3660" }
    ]
  },{
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      { "color": "#115596" }
    ]
  },{
    "elementType": "labels.text.fill",
    "stylers": [
      { "visibility": "on" }
    ]
  },{
    "featureType": "administrative.country",
    "elementType": "geometry",
    "stylers": [
      { "visibility": "on" },
      { "color": "#0c3a67" }
    ]
  },{
    "featureType": "administrative.province",
    "elementType": "geometry.stroke",
    "stylers": [
      { "visibility": "on" },
      { "color": "#0c3a67" },
      { "weight": 0.5 }
    ]
  },{
    "featureType": "administrative.locality",
    "elementType": "labels.icon"  },{
    "featureType": "water",
    "elementType": "labels",
    "stylers": [
      { "visibility": "off" }
    ]
  }
]