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
      carousel = $('section.clients .items')
      slidesToShow = Math.ceil(carousel.innerWidth() / carousel.find('li').outerWidth(true))

      carousel.slick
        slide: 'li'
        infinite: true
        slidesToShow: slidesToShow
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
