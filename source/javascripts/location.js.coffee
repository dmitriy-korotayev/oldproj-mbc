#= require easy-markerwithlabel

$ ->
  # Map
  element = $('section.map .contents')[0]

  # Get markers and center point
  markers = $(element).siblings('.marker').map ->
    latitude = $(this).attr('data-latitude')
    longtitude = $(this).attr('data-longtitude')
    marker_background_url = $(this).css('background-image')
    marker_image_url = marker_background_url.substring(4, marker_background_url.length - 1)
    marker_text = $(this).html()
    marker_category = $(this).attr('data-category') || 'none'
    [[latitude, longtitude, marker_image_url, marker_text, marker_category]]

  center = (->
    elem = $(element).siblings('.center')
    if(elem.length)
      return new google.maps.LatLng(elem.attr('data-latitude'), elem.attr('data-longtitude'))
    else
      return new google.maps.LatLng(markers[0][0], markers[0][1])
  )()

  # Device-specific settings
  mobile = false
  Breakpoints.on
    name: 'mobile-only'
    matched: ->
      mobile = true
  touch = true
  Breakpoints.on
    name: 'desktop'
    matched: ->
      touch = false


  # Initialize map
  map = new google.maps.Map element,
    zoom: mobile && 16 || 17
    center: center
    mapTypeId: google.maps.MapTypeId.ROADMAP
    panControl: 0
    zoomControl: 0
    mapTypeControl: 0
    scaleControl: 0
    streetViewControl: 0
    overviewMapControl: 0
    scrollwheel: 0
    draggable: !touch


  # Add markers
  markersOnMap = {none: []}
  $.each markers, (i,m) ->
    return true  if m.count < 2
    marker = new MarkerWithLabel(
      map: null
      position: new google.maps.LatLng(m[0], m[1])
      icon: m[2]
      labelContent: m[3]
      labelAnchor: new google.maps.Point(0,0)
      labelClass: "marker-label"
    )
    # if category exists
    c = m[4]
    if markersOnMap[c]
      markersOnMap[c].push marker
    else
      markersOnMap[c] = [marker]

  showMarkersByCategory = (category)->
    $.each markersOnMap[category], (i,m) ->
      m.setMap(map)

  hideMarkersByCategory = (category)->
    $.each markersOnMap[category], (i,m) ->
      m.setMap(null)

  hideAllMarkers = ->
    $.each markersOnMap, (i,category) ->
      $.each category, (i,m) ->
        m.setMap(null)

  showMarkersByCategory('none')
  # Filter markers
  filters = $(element).siblings('.filter').find('a')
  filters.each ->
    if $(this).hasClass('active')
      showMarkersByCategory($(this).attr('data-category'))
  filters.click (e)->
    e.preventDefault()
    category = $(this).attr('data-category')
    if markersOnMap[category]
      $(this).toggleClass('active')
      if $(this).hasClass('active')
        showMarkersByCategory(category)
      else
        hideMarkersByCategory(category)


  # Direction calculation on search
  directionsDisplay = new google.maps.DirectionsRenderer()
  directionsService = new google.maps.DirectionsService();

  directionsDisplay.setMap(map)
  $(element).siblings('.directions-search').children('form').submit (e)->
    e.preventDefault()
    request =
      origin: $(this).find('input[type=text]').val(),
      destination: center,
      travelMode: google.maps.TravelMode.DRIVING

    directionsService.route request, (response, status)->
      if status == google.maps.DirectionsStatus.OK
        hideAllMarkers()
        $(element).siblings('.filter').hide()
        directionsDisplay.setDirections response

