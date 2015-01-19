#= require helpers/deepCompare
$ ->
  pluginName = 'ajaxFilter'
  defaults =
    url: null
    sampleData: {}


  AjaxFilter = (element, options) ->
    this.options = $.extend( {}, defaults, options)
    this.form = element
    this.url = this.options.url
    this.container = this.options.container
    this.template = this.options.template

    this._defaults = defaults
    this._name = pluginName

    this._init()

  AjaxFilter.prototype =
    _init: ()->
      template = $(this.template).removeClass('template')
      templateHtml = template[0].outerHTML
      $(this.template).remove()

      firstFormData = $(this.form).serializeArray()
      firstContainerHtml = $(this.container).html()

      t = this
      $(this.form).submit (e)->
        e.preventDefault()
      $(this.form).find(':input').change (e)->
        e.preventDefault()
        formData = $(t.form).serializeArray()

        # form data is the same as first time - use cached container html
        if deepCompare(formData, firstFormData)
          $(t.container).html(firstContainerHtml)
        # else use sample data or get it from ajax
        else
          if t.url == null
            t._renderItems(templateHtml, t.options.sampleData)
          else
            console.log "TODO: get ajax data"
            ajaxData = t.sampleData
            t._renderItems(templateHtml, ajaxData)

    _renderItems: (templateHtml, data)->
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


  # Initialization
  $.fn[pluginName] = (container, template, options)->
    this.each ->
      if !$.data(this, 'plugin_'+pluginName)
        options['container'] = container
        options['template']  = template
        $.data(this, 'plugin_'+pluginName,
          new AjaxFilter(this, options))

