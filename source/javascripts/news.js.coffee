#= require jquery-ui
#= require jquery.scrollTo/jquery.scrollTo
#= require vendor/jquery.readmoreable

$ ->
  items = $('.items .item')
  items.readmoreable()


  id = window.location.hash.substring 1
  if idIsPresentAndNumeric = id.length && !isNaN(id)
    item = items.filter("[data-id=#{id}]")
    if item.length
      item.addClass 'open'
      setTimeout ->
        top = item.position().top
        $(window).scrollTop top
      , 500
