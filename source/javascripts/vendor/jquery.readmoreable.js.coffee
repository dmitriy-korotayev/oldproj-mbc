$ ->
  scrollTo = (item)->
    return false unless $.fn.scrollTo
    setTimeout ->
      $.scrollTo item, 750,
        easing: 'easeInOutQuart'
        offset: -$('header.main').height()
    , 500

  pluginName = 'readmoreable'

  $.fn[pluginName] = ()->
    items = $(@)

    items.on 'open', ->
      item = $(@)
      items.removeClass 'open'
      item.addClass 'open'
      scrollTo(item)

    items.on 'close', ->
      item = $(@)
      item.removeClass 'open'
      scrollTo(item)


    items.find('a.more').click (e)->
      e.preventDefault()
      $(@).parent().trigger 'open'

    items.find('a.less').click (e)->
      e.preventDefault()
      $(@).parent().trigger 'close'

