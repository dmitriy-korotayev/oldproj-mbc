#= require jquery-ui
#= require jquery.scrollTo/jquery.scrollTo
#= require vendor/jquery.readmoreable

$ ->
  items = $('.items .item')
  items.readmoreable()


  id = window.location.pathname.split('/').pop()
  if idIsPresentAndNumeric = id.length && !isNaN(id)
    item = items.filter("[data-id=#{id}]")
    if item.length
      item.addClass 'open'
      setTimeout ->
        top = item.position().top
        $(window).scrollTop top
      , 500
