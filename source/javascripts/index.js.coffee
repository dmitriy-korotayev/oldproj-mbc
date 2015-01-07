#= require vendor/slick

$ ->
  # ----- Intro height -----
  Breakpoints.on
    name: 'tablet'
    matched: ->
      heightWithoutHeader =
        $(window).height() -
        $('header.main').height()
      itemsHeight =
        $('section.intro .top').outerHeight(true) +
        $('section.intro .bottom').outerHeight(true)
      if(itemsHeight < heightWithoutHeader)
        $('section.intro').css('height', heightWithoutHeader)


  # ----- Carousel -----

  # Intro
  $('section.intro .items').slick
    autoplay: true
    autoplaySpeed: 6000
    arrows: true
    fade: true
    fadeIn: true
    cssEase: 'linear'

  # Clients
  Breakpoints.on
    name: 'tablet'
    matched: ->
      $('section.clients .items').slick
        slide: 'li'
        centerMode: true
        variableWidth: true
        autoplay: true
        arrows: true

  # Reviews
  $('section.reviews .items').slick
    centerMode: true
    variableWidth: true
    autoplay: true
    autoplaySpeed: 6000
    arrows: true
    dots: true
