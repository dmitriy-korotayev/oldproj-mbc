#= require easy-markerwithlabel

$ ->
  # Map
  element = $('section.map .contents')[0]

  markers = $(element).siblings('.marker').map ->
    latitude = $(this).attr('data-latitude')
    longtitude = $(this).attr('data-longtitude')
    marker_background_url = $(this).css('background-image')
    marker_image_url = marker_background_url.substring(4, marker_background_url.length - 1)
    marker_text = $(this).html()
    [[latitude, longtitude, marker_image_url, marker_text]]

  center = ->
    elem = $(element).siblings('.center')
    if(elem.length)
      return new google.maps.LatLng(elem.attr('data-latitude'), elem.attr('data-longtitude'))
    else
      return new google.maps.LatLng(markers[0][0], markers[0][1])
  map = new google.maps.Map element,
    zoom: ($(element).width() > 480) && 17 || 16
    center: center()
    mapTypeId: google.maps.MapTypeId.ROADMAP
    panControl: 0
    zoomControl: 0
    mapTypeControl: 0
    scaleControl: 0
    streetViewControl: 0
    overviewMapControl: 0
    scrollwheel: 0


  $.each markers, (i, v) ->
    return true  if v.count < 2
    marker = new MarkerWithLabel(
      map: map
      position: new google.maps.LatLng(v[0], v[1])
      icon: v[2]
      labelContent: v[3]
      labelAnchor: new google.maps.Point(0,0)
      labelClass: "marker-label"
    )
    return
