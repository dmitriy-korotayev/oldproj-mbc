#= require slick.js/slick/slick

$ ->
  Breakpoints.on
    name: 'tablet'
    matched: ->
      $('section.clients .items').slick
        slide: 'li'
        centerMode: true
        variableWidth: true
        autoplay: true
        arrows: true

  $('section.reviews .items').slick
    centerMode: true
    variableWidth: true
    autoplay: true
    autoplaySpeed: 6000
    arrows: true
    dots: true
