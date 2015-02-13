#= require easy-markerwithlabel
#= require vendor/jquery.googleMarkerMap

$ ->

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

  $('section.map .contents').first().googleMarkerMap
    map:
      zoom: mapZoom
      draggable: mapDraggable
      zoomControl: 1

