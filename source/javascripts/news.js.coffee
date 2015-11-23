#= require jquery-ui
#= require jquery.scrollTo/jquery.scrollTo
#= require vendor/jquery.readmoreable

$ ->
  items = $('.items .item')
  items.readmoreable()

  scrollTo = $('input.scroll-to-id')
  if scrollTo.length
    item = items.filter("[data-id=#{scrollTo.val()}]")
    if item.length
      setTimeout ->
        top = item.position().top
        $(window).scrollTop top
      , 1000
