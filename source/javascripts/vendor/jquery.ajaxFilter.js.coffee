#= require helpers/deepCompare
$ ->
  pluginName = 'ajaxFilter'
  defaults =
    url: null
    sampleFirstData: {}
    sampleData: {}
    onDataChange: ((data)-> true)


  AjaxFilter = (element, options) ->
    this.options = $.extend( {}, defaults, options)

    # Shortcuts
    this.form = element
    this.url = this.options.url
    this.container = this.options.container
    this.template = this.options.template

    this._defaults = defaults
    this._name = pluginName

    this._init()

  AjaxFilter.prototype =
    _init: ()->
      # Save template and remove it
      template = $(this.template).removeClass('template')
      this.templateHtml = template[0].outerHTML
      $(this.template).remove()

      # Set and render first data
      this.firstFormData = this._getFormData()
      this._showFirstItems()

      t = this
      # Prevent submission
      $(this.form).submit (e)->
        e.preventDefault()
      # Change items on input changes
      $(this.form).find(':input').change (e)->
        e.preventDefault()
        t._refresh()

      # Reset to first data on form reset
      $(this.form).find('input[type=reset]').click ->
        t._showFirstItems()

    _getFormData: ()->
      $(this.form).serializeArray()

    _getData: (formData, callback)->
      console.log "TODO: get ajax data"
      callback(this.sampleData)

    _renderItems: (data)->
      templateHtml = this.templateHtml
      itemsHtml = data.map (item)->
        itemHtml = templateHtml

        $.each item, (name, value)->
          find = "%"+name
          regex = new RegExp(find, 'g')
          itemHtml = itemHtml.replace(regex, value)

        itemHtml = itemHtml.replace(/data-src="([^"]+)" src="[^"]+"/g, 'src="$1"')
        itemHtml = itemHtml.replace(/data-image-url="([^"]+)" style="background-image: none"/g, 'style="background-image: url($1)"')
        itemHtml

      containerHtml = itemsHtml.join('')

      $(this.container).html(containerHtml)
      this.options.onDataChange(data)

    _showItems: (sample = false)->
      if !sample
        # Ajax, async
        this._getData this._getFormData(), (data)->
          this.renderItems(data)
      else
        this._renderItems this.options.sampleData

    _showFirstItems: ()->
      if this.options.url
        # Ajax, async
        this._getData this.firstFormData, (data)->
          this._renderItems data
      else
        # Sample data
        this._renderItems this.options.sampleFirstData

    _refresh: ()->
      # form data is the same as first time - use cached container html
      if deepCompare(this._getFormData(), this.firstFormData)
        this._showFirstItems()
      # else use sample data or get it from ajax
      else
        this._showItems(this.url == null)


  # Initialization
  $.fn[pluginName] = (container, template, options)->
    this.each ->
      if !$.data(this, 'plugin_'+pluginName)
        options['container'] = container
        options['template']  = template
        $.data(this, 'plugin_'+pluginName,
          new AjaxFilter(this, options))

