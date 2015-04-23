#= require vendor/jquery.getBackgroundImage
#= require easy-markerwithlabel
#= require vendor/jquery.googleMarkerMap
#= require vendor/jquery.readmoreable

$ ->
  # --- Header image height as sizer and text hiding ---
  Breakpoints.on
    name: 'tablet'
    matched: ->
      header = $('article.client>header')
      sizer = header.find('.sizer:visible')
      header.find('.image:visible').css('max-height', "#{sizer.height()}px")
      header.find('.text').readmoreable()


  # --- Map ---
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


  mapZoom = mobile && 16 || 17
  mapDraggable = true
  mapZoomControl = !touch
  mapStyle = [{
    featureType: 'poi'
    stylers: [{ visibility: 'off' }]
  }]

  $('section.map .contents').first().googleMarkerMap
    map:
      zoom: mapZoom
      draggable: mapDraggable
      zoomControl: mapZoomControl
    mapStyle: mapStyle


