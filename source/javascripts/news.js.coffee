#= require jquery-ui
#= require jquery.scrollTo/jquery.scrollTo

$ ->
  items = $('.items .item')
  items.find('a.more').click (e)->
    e.preventDefault()
    items.removeClass 'open'
    currentItem = $(this).parent()
    currentItem.addClass 'open'
    setTimeout ->
      $.scrollTo currentItem, 750,
        easing: 'easeInOutQuart'
        offset: -$('header.main').height()
    , 500
