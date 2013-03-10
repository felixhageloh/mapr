$ ->
  globeCenter = new google.maps.LatLng(44, 12)

  styles = [{
      stylers: [ {hue: "#152c3d"}, { lightness: -60 }, { saturation: -80 } ]
    }, {
      featureType: "all"
      elementType: "labels"
      stylers: [{ visibility: "off" }]
    }, {
      featureType: "administrative"
      elementType: "geometry.stroke"
      stylers: [{ color: "#666666" }, {weight: 1} ]
    }, {
      featureType: "road"
      elementType: 'geometry'
      stylers: [{visibility: 'off'}]
    }, {
      featureType: "water"
      elementType: 'geometry'
      stylers: [{color: '#152c3d'}]
    }
  ]

  styledMap = new google.maps.StyledMapType(styles, name: "Styled Map")

  mapOptions =
    center: globeCenter,
    zoom: 2,
    mapTypeId: google.maps.MapTypeId.ROADMAP
    mapTypeControl: false
    zoomControl: false
    maxZoom: 2
    minZoom: 2
    disableDoubleClickZoom: true
    draggable: false

  map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions)
  map.mapTypes.set('map_style', styledMap)
  map.setMapTypeId('map_style')

  addMarker = (position) ->
    latLng = new google.maps.LatLng(position.lat, position.lon)

    marker = new google.maps.Circle
      strokeWeight: 0,
      fillColor: "#fff5c7",
      fillOpacity: 0.5,
      map: map,
      center: latLng,
      radius: 20000 # in meters!

  update = ->
    $.get '/update', (positions) ->
      return unless positions?
      addMarker position for position in positions

  setInterval update, 500
