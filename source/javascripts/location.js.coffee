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

  mapCenter = (->
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
  mapZoom = mobile && 16 || 17
  map = new google.maps.Map element,
    zoom: mapZoom
    center: mapCenter
    mapTypeId: google.maps.MapTypeId.ROADMAP
    panControl: 0
    zoomControl: 0
    mapTypeControl: 0
    scaleControl: 0
    streetViewControl: 0
    overviewMapControl: 0
    scrollwheel: 0
    draggable: !touch

  # limit zoom level to +1/-1
  addZoomLimitListener = null
  addZoomLimit = ->
    window.addZoomLimitListener = google.maps.event.addListener map, 'zoom_changed', ->
      map.setZoom(mapZoom+1) if map.getZoom() > mapZoom+1
      map.setZoom(mapZoom-1) if map.getZoom() < mapZoom-1
  removeZoomLimit = ->
    google.maps.event.removeListener window.addZoomLimitListener

  addZoomLimit()

  # Add/remove markers
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

  hideAllMarkers = (except = '')->
    $.each markersOnMap, (categoryName,category) ->
      if categoryName != except
        $.each category, (i,m) ->
          m.setMap(null)

  showMarkersByCategory('none')

  # Filter markers
  filter = $(element).siblings('.filter')
  filters = filter.find('a')
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

  filterReset = filter.find('.reset a')
  filterReset.click (e)->
    e.preventDefault()
    filters.removeClass('active')
    hideAllMarkers('none')


  # Direction calculation
  directionsService = new google.maps.DirectionsService();
  directionsDisplay = new google.maps.DirectionsRenderer()
  directionsContainer = $(element).siblings('.directions-search')

  # on submit
  directionsForm = directionsContainer.children('form')
  directionsForm.submit (e)->
    e.preventDefault()
    directionsDisplay.setMap(map)
    removeZoomLimit()
    origin = $(this).find('input[type=text]').val()
    if origin != ''
      request =
        origin: origin
        destination: mapCenter
        travelMode: google.maps.TravelMode.DRIVING

      directionsService.route request, (response, status)->
        if status == google.maps.DirectionsStatus.OK
          hideAllMarkers()
          filter.hide()
          directionsDisplay.setDirections response
    else
      $(this).find('[type=reset]').click()

  # on geolocation
  geocoder = new google.maps.Geocoder()
  directionsContainer.find('button.locate').click (e)->
    e.preventDefault()
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (position) ->
        lat = position.coords.latitude
        lng = position.coords.longitude
        geocoder.geocode {'latLng': new google.maps.LatLng(lat, lng)}, (results, status)->
          if (status == google.maps.GeocoderStatus.OK && results[0])
            address = results[0].formatted_address
          else
            address = "#{lat}, #{lng}"
          directionsForm.find('[name=from]').val(address)
          directionsForm.submit()
    else
      false

  # and reset
  directionsContainer.find('[type=reset]').click (e)->
    addZoomLimit()
    directionsDisplay.setMap(null)
    filter.show()

    map.setCenter(mapCenter)
    map.setZoom(mapZoom)
    filterReset.click()
    showMarkersByCategory('none')

