$ ->
  pluginName = 'googleMarkerMap'
  defaults =
    markers: []
    zoomLimit: 1

    filter: null
    filterReset: null
    directionsContainer: null
    directionsForm: null

    map:
      mapTypeId: google.maps.MapTypeId.ROADMAP
      zoom: 17
      center: null
      panControl: 0
      zoomControl: 0
      #mapTypeControl: 0
      scaleControl: 0
      streetViewControl: 0
      overviewMapControl: 0
      scrollwheel: 0
      draggable: true


  GoogleMarkerMap = (element, options) ->
    this.options = $.extend( {}, defaults, options)
    this.options.map = $.extend( {}, defaults.map, options.map) if options.map

    this.map      = null
    this.element  = element
    this.markers  = this.options.markers
    this.center   = this.options.map.center
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

        [[latitude, longtitude, marker_image_url, marker_text, marker_category]]
      ).get()
      this.markers = this.markers.concat markersFromHtml

      # Set center point
      this.center ?= (->
        elem = $(this.element).siblings('.center')
        lat = elem.length && elem.attr('data-latitude') || t.markers[0][0]
        lng = elem.length && elem.attr('data-longtitude') || t.markers[0][1]
        return new google.maps.LatLng(lat, lng)
      )()
      this.options.map.center = this.center


      # Initialize map
      this.map = new google.maps.Map this.element,
        this.options.map


      # Limit zoom level
      this._addZoomLimit(this.options.zoomLimit)

      # Markers, shown on map, by category
      $.each this.markers, (i,m) ->
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
        if t.markersOnMap[c]
          t.markersOnMap[c].push marker
        else
          t.markersOnMap[c] = [marker]

      this._showMarkersByCategory('none')

      # Filter markers
      this.filter ?= $(this.element).siblings('.filter')
      filters = this.filter.find('a')
      if(this.filter.length)
        filters.each ->
          if $(this).hasClass('active')
            t._showMarkersByCategory($(this).attr('data-category'))
        filters.click (e)->
          e.preventDefault()
          category = $(this).attr('data-category')
          if t.markersOnMap[category]
            $(this).toggleClass('active')
            if $(this).hasClass('active')
              t._showMarkersByCategory(category)
            else
              t._hideMarkersByCategory(category)

      this.filterReset ?= this.filter.find('.reset a')
      this.filterReset.length && this.filterReset.click (e)->
        e.preventDefault()
        filters.removeClass('active')
        t._hideAllMarkers('none')


      # Direction calculation
      directionsService = new google.maps.DirectionsService();
      directionsDisplay = new google.maps.DirectionsRenderer()
      directionsContainer = this.options.directionsContainer || $(this.element).siblings('.directions-search')

      # on submit
      directionsForm = this.options.directionsForm || directionsContainer.children('form')
      directionsForm.submit (e)->
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
      directionsContainer.find('button.locate').click (e)->
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
              directionsForm.find('input[type=text]').val(address)
              directionsForm.submit()
        else
          false

      # and reset
      directionsContainer.find('[type=reset]').click (e)->
        t._addZoomLimit(t.options.zoomLimit)
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


    _showMarkersByCategory: (category)->
      map = this.map
      $.each this.markersOnMap[category], (i,m) ->
        m.setMap(map)

    _hideMarkersByCategory: (category)->
      $.each this.markersOnMap[category], (i,m) ->
        m.setMap(null)

    _hideAllMarkers: (except = '')->
      $.each this.markersOnMap, (categoryName,category) ->
        if categoryName != except
          $.each category, (i,m) ->
            m.setMap(null)


  # Initialization
  $.fn[pluginName] = (options)->
    this.each ->
      if !$.data(this, 'plugin_'+pluginName)
        $.data(this, 'plugin_'+pluginName,
          new GoogleMarkerMap(this, options))

