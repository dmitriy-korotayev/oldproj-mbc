#= require vendor/markerwithlabel

$ ->
  pluginName = 'googleMarkerMap'
  unless google?
    $.fn[pluginName] = (options)->
      console.log "#{pluginName}: 'google' is not defined"
    return false

  defaults =

    map:
      mapTypeId: google.maps.MapTypeId.ROADMAP
      zoom: 17
      center: null
      panControl: 0
      zoomControl: 0
      mapTypeControl: 0
      scaleControl: 0
      streetViewControl: 0
      overviewMapControl: 0
      scrollwheel: 0
      draggable: true
    mapStyle: null
    mapZoomLimit: 1
    markers: []

    filter: null
    filterReset: null
    filterBehavior:
      radioToggles: false
      hideNoCategoryOnAny: false # Hide no category markers on filter toggle

    directionsContainer: null
    directionsForm: null


  GoogleMarkerMap = (element, options) ->
    this.options = $.extend(true, {}, defaults, options)

    this.element  = element
    this.map      = null
    this.center   = this.options.map.center
    this.markers  = this.options.markers
    this.markersOnMap = {none: []}

    this.filter   = this.options.filter
    this.filterReset = this.options.filterReset

    this._init()

  GoogleMarkerMap.prototype =
    _init: ()->
      t = this

      # Set/merge marker data
      markersFromHtml = $(this.element).siblings('.marker').map(->
        latitude = $(this).attr('data-latitude')
        longtitude = $(this).attr('data-longtitude')

        marker_background_url = $(this).css('background-image')
        marker_image_url = marker_background_url.substring(4, marker_background_url.length - 1)
        marker_text = $(this).html()
        marker_category = $(this).attr('data-category') || 'none'
        mcc = $(this).find('.content')
        marker_content = mcc.length && mcc[0].outerHTML || null
        mcc.remove()

        [[latitude, longtitude, marker_image_url, marker_text, marker_category, marker_content]]
      ).get()
      this.markers = this.markers.concat markersFromHtml

      # Set center point
      this.center ?= (->
        elem = $(t.element).siblings('.center')
        lat = elem.length && elem.attr('data-latitude') || t.markers[0][0]
        lng = elem.length && elem.attr('data-longtitude') || t.markers[0][1]
        return new google.maps.LatLng(lat, lng)
      )()
      this.options.map.center = this.center


      # Initialize map
      this.map = new google.maps.Map this.element,
        this.options.map

      mapStyle = this.options.mapStyle
      if mapStyle
        styledMap = new google.maps.StyledMapType(mapStyle, {name: "Styled Map"})
        this.map.mapTypes.set('map_style', styledMap)
        this.map.setMapTypeId('map_style')

      # Limit zoom level
      this._addZoomLimit(this.options.mapZoomLimit)

      # Markers, shown on map, by category
      hoverOffset = 80000
      this.lastOpenedContentTip = null
      this.mapCenterBeforeTipOpen= this.map.getCenter()
      $.each this.markers, (i,m) ->
        return true  if m.count < 2
        marker = new MarkerWithLabel(
          map: null
          position: new google.maps.LatLng(m[0], m[1])
          icon: m[2]
          labelContent: m[3]
          labelAnchor: new google.maps.Point(0,0)
          labelClass: "marker-label"
          labelStyle: {zIndex: hoverOffset + 1}
        )
        marker.setZIndex(hoverOffset)
        hoverOffset += 2

        # tip with content
        if m[5]
          contentTip = new google.maps.InfoWindow
            content: m[5]
          google.maps.event.addListener marker, 'click', ->
            t.directionsContainer.hide()
            t.mapCenterBeforeTipOpen = t.map.getCenter()
            contentTip.open(this.map,marker);
            loct = t.lastOpenedContentTip
            if loct != contentTip
              loct.close() if loct
              t.lastOpenedContentTip = contentTip
          google.maps.event.addListener contentTip, 'closeclick', ->
            t.directionsContainer.show()
            t.map.panTo(t.mapCenterBeforeTipOpen)

        # if category exists
        c = m[4]
        if t.markersOnMap[c]
          t.markersOnMap[c].push marker
        else
          t.markersOnMap[c] = [marker]

      this._showMarkersByCategory('none')

      # Filter markers
      this.filter ?= $(this.element).siblings('.filter')
      filters = this.filter.find('a')
      resetZoomIfNotDefault = ->
        map = t.map
        if map.getZoom() < t.options.map.zoom
          map.setZoom(t.options.map.zoom)
      if(this.filter.length)
        filters.each ->
          if $(this).hasClass('active')
            t._showMarkersByCategory($(this).attr('data-category'))
        filters.click (e)->
          e.preventDefault()
          category = $(this).attr('data-category')
          if t.markersOnMap[category]
            $(this).toggleClass('active')
            map = t.map
            hideNoCat = t.options.filterBehavior.hideNoCategoryOnAny
            turnOthersOff = t.options.filterBehavior.radioToggles
            # if activated
            if $(this).hasClass('active')
              t._hideMarkersByCategory('none') if hideNoCat && !$(this).siblings('.active').length
              filters.not(this).removeClass('active') && t._hideAllMarkers() if turnOthersOff
              t._showMarkersByCategory category, (marker)->
                if map.getBounds() && !map.getBounds().contains(marker.getPosition())
                  map.setZoom(map.getZoom() - 1)
            else
              t._showMarkersByCategory('none') if hideNoCat && !$(this).siblings('.active').length
              t._hideMarkersByCategory category
              if !$(this).siblings('.active').length
                resetZoomIfNotDefault()

      this.filterReset ?= this.filter.find('.reset a')
      this.filterReset.length && this.filterReset.click (e)->
        e.preventDefault()
        filters.removeClass('active')
        t._hideAllMarkers('none')
        t._showMarkersByCategory('none') if t.options.filterBehavior.hideNoCategoryOnAny
        resetZoomIfNotDefault()


      # Direction calculation
      directionsService = new google.maps.DirectionsService();
      directionsDisplay = new google.maps.DirectionsRenderer()
      this.directionsContainer = this.options.directionsContainer || $(this.element).siblings('.directions-search')

      # on submit
      this.directionsForm = this.options.directionsForm || this.directionsContainer.children('form')
      this.directionsForm.submit (e)->
        e.preventDefault()
        directionsDisplay.setMap(t.map)
        t._removeZoomLimit()
        origin = $(this).find('input[type=text]').val()
        if origin != ''
          request =
            origin: origin
            destination: t.options.map.center
            travelMode: google.maps.TravelMode.DRIVING

          directionsService.route request, (response, status)->
            if status == google.maps.DirectionsStatus.OK
              t._hideAllMarkers()
              t.filter.hide()
              directionsDisplay.setDirections response
        else
          $(this).find('[type=reset]').click()

      # on geolocation
      geocoder = new google.maps.Geocoder()
      this.directionsContainer.find('button.locate').click (e)->
        e.preventDefault()
        t._removeZoomLimit()
        if navigator.geolocation
          navigator.geolocation.getCurrentPosition (position) ->
            lat = position.coords.latitude
            lng = position.coords.longitude
            geocoder.geocode {'latLng': new google.maps.LatLng(lat, lng)}, (results, status)->
              if (status == google.maps.GeocoderStatus.OK && results[0])
                address = results[0].formatted_address
              else
                address = "#{lat}, #{lng}"
              t.directionsForm.find('input[type=text]').val(address)
              t.directionsForm.submit()
        else
          false

      # and reset
      this.directionsContainer.find('[type=reset]').click (e)->
        t._addZoomLimit(t.options.mapZoomLimit)
        directionsDisplay.setMap(null)
        t.filter.show()

        t.map.setCenter(t.center)
        t.map.setZoom(t.options.map.zoom)
        t.filterReset.click()
        t._showMarkersByCategory('none')


    _addZoomLimit: (limit)->
      map = this.map
      mapZoom = this.options.map.zoom
      min = limit % 1 == 0 && mapZoom-limit || limit[0]
      max = limit % 1 == 0 && mapZoom+limit || limit[1]

      window.mapZoomLimitListener && this._removeZoomLimit()
      window.mapZoomLimitListener = google.maps.event.addListener map, 'zoom_changed', ->
        map.setZoom(min) if map.getZoom() < min
        map.setZoom(max) if map.getZoom() > max

    _removeZoomLimit: ()->
      google.maps.event.removeListener window.mapZoomLimitListener


    _showMarker: (marker, callback=((marker)-> ))->
      map = this.map
      marker.setMap map
      callback(marker)

    _hideMarker: (marker)->
      marker.setMap null


    _showMarkersByCategory: (category, markerCallback=((marker)-> ))->
      t = this
      $.each this.markersOnMap[category], (i,m) ->
        t._showMarker m, markerCallback

    _hideMarkersByCategory: (category)->
      t = this
      $.each this.markersOnMap[category], (i,m) ->
        t._hideMarker m

    _hideAllMarkers: (except = '')->
      t = this
      $.each this.markersOnMap, (categoryName,category) ->
        if categoryName != except
          $.each category, (i,m) ->
            t._hideMarker m


  # Initialization
  $.fn[pluginName] = (options)->
    this.each ->
      if !$.data(this, 'plugin_'+pluginName)
        $.data(this, 'plugin_'+pluginName,
          new GoogleMarkerMap(this, options))

