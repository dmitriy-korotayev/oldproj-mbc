#= require helpers/deepCompare
# better serializeArray - http://stackoverflow.com/a/1186309/1262726
$.fn.serializeObject = ->
  o = {}
  a = @serializeArray()
  $.each a, ->
    if o[@name] != undefined
      if !o[@name].push
        o[@name] = [ o[@name] ]
      o[@name].push @value or ''
    else
      o[@name] = @value or ''
    return
  o

$ ->
  pluginName = 'ajaxFilter'
  defaults =
    url: null
    data: null
    sampleFirstData: []
    sampleData: []
    onFormChange:   ((form, formData, oldFormData)-> form)
    dataFilter:     ((data, formData)-> data)
    onDataChange:   ((data)-> true)


  AjaxFilter = (element, options) ->
    this.options = $.extend( {}, defaults, options)

    containers = this.options.containers
    this.containers = containers.constructor == Array && containers || [containers]

    templates = this.options.templates
    this.templates = templates.constructor == Array && templates || [templates]

    # Shortcuts
    this.form = element
    this.url = this.options.url

    this._defaults = defaults
    this._name = pluginName

    this._init()

  AjaxFilter.prototype =
    _init: ()->
      t = this

      # Save templates and remove them
      this.templatesHtml = []
      $.each this.templates, (i,template)->
        template = $(template).removeClass('template')
        if template.length != 0
          t.templatesHtml.push template[0].outerHTML
        else
          console.log "#{t._name}: template at index #{i} is empty"
        template.remove()

      # Set and render first data
      this.firstFormData = this._getFormData()
      this._showFirstItems()

      form = $(this.form)
      # Prevent submission
      form.submit (e)->
        e.preventDefault()
      # Change items on input changes
      this.oldFormData = this._getFormData()
      form.find(':input').change (e)->
        e.preventDefault()
        t._refresh()

      # Reset to first data on form reset
      form.find('input[type=reset]').click ->
        t._showFirstItems()

    _getFormData: ()->
      form = $(this.form)
      formData = form.serializeObject()

    _getData: (formData, callback)->
      #console.log "TODO: get ajax data"
      data = this.options.data
      data = this.options.dataFilter(data, formData)
      callback(data)

    _renderItems: (data)->
      t = this
      $.each this.templatesHtml, (i, templateHtml)->
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
        $(t.containers[i]).html(containerHtml)

      this.options.onDataChange(data)

    _showItems: (sample = false)->
      if !sample
        # Ajax, async or predefined
        t = this
        this._getData this._getFormData(), (data)->
          t._renderItems(data)
      else
        this._renderItems this.options.sampleData

    _showFirstItems: ()->
      if this.url || this.options.data
        # Ajax, async or predefined
        t = this
        this._getData this.firstFormData, (data)->
          t._renderItems data
      else
        # Sample data
        this._renderItems this.options.sampleFirstData

    _refresh: ()->
      # form data is the same as first time - use cached items data
      if deepCompare(this._getFormData(), this.firstFormData)
        this._showFirstItems()
      # else use sample data or get it from ajax/predefined
      else
        this._showItems(this.url == null && this.options.sampleData.length)


  # Initialization
  $.fn[pluginName] = (containers, templates, options)->
    this.each ->
      if !$.data(this, 'plugin_'+pluginName)
        options['containers'] = containers
        options['templates']  = templates
        $.data(this, 'plugin_'+pluginName,
          new AjaxFilter(this, options))

