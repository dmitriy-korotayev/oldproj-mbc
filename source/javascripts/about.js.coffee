#= require vendor/slick
#= require vendor/jquery.getBackgroundImage

$ ->
  # Statement
  items = $('section.statement .items')

  # - resize to image size
  firstItem = items.find('.item:first')
  background = firstItem.find('.background:visible')
  backgroundContainers = items.find('header')
  Breakpoints.on
    name: 'tablet'
    matched: ->
      backgroundContainers = items

  resizeToImageSize = ->
    background.useBackgroundImage (image)->
      bgcs = backgroundContainers
      bgc = bgcs.first()

      targetContainerHeight = bgc.width() / image.width * image.height
      bgcs.css('height', "#{targetContainerHeight}px") if bgc.height() < targetContainerHeight

  resizeToImageSize()

  # - carousel
  initCarousel = ->
    items.slick
      autoplay: true
      autoplaySpeed: 6000
      arrows: true
      fade: true
      fadeIn: true
      cssEase: 'linear'

  initCarousel()

  $(window).on 'resize', ->
    backgroundContainers.attr('style', '')
    items.slick('unslick')
    initCarousel()
    resizeToImageSize()


# TRASH

# require jquery.kinetic

  ## --- History ---
  #wrapper = $('section.history .contents.tablet .kinetic')

  ## calculate frame width
  #lastItem = wrapper.find('.achievement:last-child')
  #frameWidth =
    #parseInt(wrapper.find('.achievements').css('margin-left')) +
    #lastItem.outerWidth(true) +
    #parseInt(lastItem.css('left'))

  #wrapper.children('.frame').css('width', "#{frameWidth}px")

  ## buttons updating dependent on visible items and their count
  #buttons = wrapper.parent().children('a.prev, a.next')
  #updateButtons = ->
    #invisible = [0,0]

    ## get how many items are not visible
    #wrapper.find('.achievement').each ->
      #if $(this).offset().left < 0
        #invisible[0] = invisible[0] + 1
      #else if ($(window).width() - ($(this).offset().left + $(this).outerWidth())) < 0
        #invisible[1] = invisible[1] + 1

    ## show according buttons
    #buttons.siblings('.active').remove()
    #$.each ['prev', 'next'], (i, direction)->
      #if invisible[i] > 0
        ## a.(next|prev).(multiple|single)
        #template = buttons.filter("a.#{direction}.#{invisible[i]>1 && 'multiple' || 'single'}")
        #button = template.clone()
        ## clone a template, add after, make visible,
        ## change %i to how many are invisible
        #button.insertAfter(template).addClass('active')
          #.click((e)->
            #e.preventDefault()
            #wrapper.kinetic 'start', {velocity: $(this).is('.next') && 20 || -20}
            #setTimeout (->
              #wrapper.kinetic 'end'
            #), 250
          #)
          #.html (index,html)->
            #html.replace('%i', invisible[i])


  ## initialization of kinetic
  #wrapper.kinetic
    #y: false
    #stopped: ->
      #updateButtons()

  #updateButtons()
