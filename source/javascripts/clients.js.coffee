#= require jquery.customSelect/jquery.customSelect
#= require jquery-ui
#= require jquery.scrollTo/jquery.scrollTo

$ ->
  $('select').customSelect()

  # Show according building on this page
  Breakpoints.on
    name: 'tablet'
    matched: ->
      $('a.tip').click (e)->
        e.preventDefault()
        # some loading magic
        $.scrollTo $('section.building').addClass('active'), 1500,
          easing: 'easeInOutQuart'
          offset: -30
      $('section.building a.hide').click (e)->
        e.preventDefault()
        # some unloading magic
        $(this).parent().removeClass('active')
        setTimeout(->
          $.scrollTo 'section.clients', 1500,
            easing: 'easeInOutQuart'
            offset: -50
        , 500)

