#= require jquery-ui
#= require jquery.scrollTo/jquery.scrollTo

$ ->
  items = $('.items .item')
  scrollTo = (item)->
    setTimeout ->
      $.scrollTo item, 750,
        easing: 'easeInOutQuart'
        offset: -$('header.main').height()
    , 500


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
    $(this).parent().trigger 'open'

  items.find('a.less').click (e)->
    e.preventDefault()
    $(this).parent().trigger 'close'
