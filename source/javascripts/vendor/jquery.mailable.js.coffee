(($)->
  pluginName = 'mailable'
  defaults =
    url: 'http://localhost:3000/mail'
    locale: 'en'
    manual: false
    mail_id_attribute: 'data-mailable-id'
    errorContainer: false
    itemErrorContainer: '.error'
    itemErrorClass: 'has-error'


  Mailable = (element, options) ->
    this.options = $.extend( {}, defaults, options)

    this._defaults = defaults
    this._name = pluginName

    this._e = element
    this._url = this.options.url + "/" + $(this._e).attr(this.options.mail_id_attribute)

    if window.mailableLocale && !options.locale
      this._locale = window.mailableLocale
    else
      this._locale = this.options.locale

    this._errors = null

    this._init()

  Mailable.prototype =
    _init: ()->
      t = this
      $(this._e).attr('novalidate', true)
      if !this.options.manual
        $(this._e).submit (e)->
          e.preventDefault()
          t.send()

    _hasSlice: (slice)->
      $(this._e).find(slice).length

    _formData: (slice = null)->
      if !slice
        slice = $(this._e)
      else if !this._hasSlice(slice)
        console.log(this._name+': Slice is invalid')
        return false

      $(':input', slice).serializeArray().reduce((obj, k) ->
        obj[k.name] = k.value
        obj
      , {})

    _request: (url, data, callback=->{})->
      # TEST DATA
      #response = if data['field1'] == '' then {type: 'error', errors:{field1: ['type anything into this field']}} else {type: 'success'}
      #this._errors = if response.type == 'error' then response.errors else false
      #callback(response.type)
      # END
      t = this
      result = false

      $.ajax(
        url: "#{url}?locale=#{this._locale}"
        type: 'post'
        dataType: 'json'
        data: {data: data}
        beforeSend: ->
          $(t._e).addClass('mailable-processing')
      ).done (response) ->
        if !(response instanceof Object)
          console.log response
          console.log "#{t._name}: Response received is not a valid JSON"

        if ['success', 'error', 'failure'].indexOf(response.type) < 0
          console.log "#{t._name}: Got an unknown response type"

        callback(response)

        $(t._e).removeClass('mailable-processing')

      return result

    validate: (renderErrors = true, slice = null)->
      t = this
      valid = false
      slice_whole = false

      if !slice
        slice_whole = true

      this._request this._url+'/validate', this._formData(slice), (response)->
        if response.type == 'success'
          valid = true
        else if response.type == 'error' && !slice_whole
          error_keys = Object.keys(response.errors)
          slice_keys = Object.keys(t._formData(slice))
          intersecting_keys = error_keys.filter (n)->
            return slice_keys.indexOf(n) != -1
          valid = intersecting_keys.length == 0

        if valid
          t._clearErrors(slice)
        else
          t._renderErrors(response.errors, slice)

        valid = true if $(this._e).hasClass('mailable-debug')
        return valid

    #non-ajax getErrors: (cached = false, slice = null)->
      #if !cached
        #this.validate(false, slice)
      #this._errors

    _clearErrors:  (slice = null)->
      slice = $(this._e) if !slice

      iECo = this.options.itemErrorContainer
      if iECo
        $(slice).find(iECo).html('')

      iECl = this.options.itemErrorClass
      if iECl
        $(slice).find(".#{iECl}").removeClass(iECl)
      #eC = this.options.errorContainer
      #if eC

    _renderErrors: (errors, slice = null)->
      this._clearErrors(slice)
      slice = $(this._e) if !slice

      iECo = this.options.itemErrorContainer
      if iECo
        $.each errors, (name, error) ->
          $(slice).find('[name="'+name+'"]').siblings(iECo).html(error.join('<br>'))

      iECl = this.options.itemErrorClass
      if iECl
        $.each errors, (name, error) ->
          container = input = $(slice).find('[name="'+name+'"]')
          container = input.siblings('.select2-container') if input.is('.tokens, .free-choice')

          container.addClass(iECl)

      #eC = this.options.errorContainer
      #if eC
        #if response.type is "error"
          #$("<ul/>",
            #html: $.map(errors, (v, i) ->
              #$.map v, (v, i) ->
                #"<li>" + v + "</li>"

            #)
          #).appendTo eC

    send: (validate = true, successCallback = null)->
      this.validate() if validate

      t = this
      this._request this._url, this._formData(), (response)->
        if response.type == 'success'
          if successCallback
            successCallback(t)
          else
            t.displaySuccess()
            setTimeout (->
              t.resetForm()
              t.hideSuccess()
            ), 5000

    displaySuccess: ()->
      $(this._e).find('.result.success').show()
    hideSuccess: ()->
      $(this._e).find('.result.success').hide()

    resetForm: ()->
      $(this._e).trigger "reset"
      $(this._e).find('.select2-offscreen').select2('val','')
    #_renderResult: ()->
      #result_wrapper = $(t).children(".result").html("")
      #result_container = $("<div class=\"" + response.type + "\"></div>").appendTo(result_wrapper)
      #$(result_container).html "<div class=\"message\">" + response.message + "</div>"

  # Initialization
  $.fn[pluginName] = (options)->
    this.each ->
      if !$.data(this, 'plugin_'+pluginName)
        $.data(this, 'plugin_'+pluginName,
          new Mailable(this, options))

)(jQuery)
