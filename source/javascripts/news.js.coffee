$ ->
  $('a.more').click (e)->
    e.preventDefault()
    $(this).parent().addClass('open')
