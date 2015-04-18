#= require vendor/jquery.getBackgroundImage
#= require easy-markerwithlabel
#= require vendor/jquery.googleMarkerMap

$ ->
  # --- Header image height ---
  Breakpoints.on
    name: 'tablet'
    matched: ->
      header = $('article.client>header')
      background = header.find('.image:visible')
      background.useBackgroundImage (image)->
        targetContainerHeight = header.width() / image.width * image.height
        header.css('height', "#{targetContainerHeight}px") if header.height() < targetContainerHeight


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
  mapDraggable = !touch
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

