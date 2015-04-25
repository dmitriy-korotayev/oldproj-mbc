$ ->
  # --- Building rollout ---
  animationDuration = 500
  $('a.tip').click (e)->
    e.preventDefault()
    # some loading magic maybe
    building_id = $(this).attr('href').split('#')[1]
    building_container = $('section.building').filter("##{building_id}")

    $('section.building.active').trigger('hide')
    building_container.trigger('show')

    setTimeout(->
      $.scrollTo building_container, 1500,
        easing: 'easeInOutQuart'
        offset: -30
    , animationDuration)

  $('section.building a.hide').click (e)->
    e.preventDefault()
    # some unloading magic
    building_container = $(this).parent()
    building_container.trigger 'hide'
    setTimeout(->
      $.scrollTo 'section.spaces', 1500,
        easing: 'easeInOutQuart'
        offset: -50
    , animationDuration)

  $('section.building').on 'show', ->
    $(this).addClass('active')
    t = this
    setTimeout(->
      $(t).trigger 'carousel_init'
    , animationDuration)

  $('section.building').on 'hide', ->
    $(this).removeClass('active')
    t = this
    setTimeout(->
      $(t).find('section.image:visible').slick('unslick')
    , animationDuration)


  # --- Building image carousel ---
  $('section.building').on 'carousel_init', ->
    carousel = $(this).find('section.image:visible')
    # item height = container height
    Breakpoints.on
      name: 'tablet'
      matched: ->
        carousel.find('.item').css('height', "#{carousel.height()}px")
    carousel.slick
      autoplay: true
      autoplaySpeed: 6000
      arrows: true
      fade: true
      fadeIn: true
      cssEase: 'linear'

