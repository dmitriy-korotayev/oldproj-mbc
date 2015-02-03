#= require jquery.customSelect/jquery.customSelect
#= require helpers/images

#= require jquery-ui
#= require jquery.scrollTo/jquery.scrollTo

#= require vendor/jquery.ajaxFilter
#= require purl

#= require vendor/slick

$ ->
  $('select').customSelect()

  # --- Building rollout ---

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
          $.scrollTo 'section.spaces', 1500,
            easing: 'easeInOutQuart'
            offset: -50
        , 500)


  # --- Dynamic items filter ---

  form = null
  Breakpoints.on
    name: 'mobile-only'
    matched: ->
      form = $('form.filters.mobile-only')
  Breakpoints.on
    name: 'tablet'
    matched: ->
      form = $('form.filters.tablet')


  url = null
  container = form.siblings('.items.grid')
  template  = container.children('.item.template')
  secondaryContainer = form.siblings('.items.list').find('tbody')
  secondaryTemplate  = secondaryContainer.children('.template')
  sampleData = Array.apply(null, new Array(3)).map ->
    image_url: "#{image_path 'spaces'}/1.jpg"
    image_small_src: "#{image_path 'spaces'}/1--small.jpg"
    info_area_number: 200
    info_price_number: 8
    info_building_number: 2
    extra_stores_number: 3
    extra_parkings_number: 7
    extra_furniture: '<i class="check"></i>'
    extra_lookover: '<i class="cross"></i>'


  form.ajaxFilter [container, secondaryContainer], [template, secondaryTemplate],
    sampleData: sampleData
    sampleFirstData: window.itemsSampleFirstData || []
    onDataChange: (data)->
      form.siblings('h1').find('span.number').html(data.length)


  # filter -> type change if given in hash
  changeFilterType = ->
    filter_type = $.url().fparam('filter_type')
    if filter_type
      form.find('[name="type"]').val(filter_type).change()
  changeFilterType()
  $(window).on('hashchange', changeFilterType)

  # --- Grid/List items view ---
  Breakpoints.on
    name: 'tablet'
    matched: ->
      $('.items-view a').click ->
        if !$(this).hasClass('active')
          klass = $(this).attr('class')
          container = $(".items.#{klass}")
          $(this).siblings().add(container.siblings('.items')).removeClass('active')
          $(this).add(container).addClass('active')


  # --- Modal: gallery - carousel ---

  gallery = $('.remodal.gallery')
  container = gallery.children('.image')
  firstImage = container.children().first()
  firstImage.load ->
    container.css('height', "#{$(this).height()}px")
  gallery.on 'opened', ->
    container.slick
      autoplay: true
      autoplaySpeed: 6000
      arrows: true
      fade: true
      fadeIn: true
      cssEase: 'linear'
  gallery.on 'closed', ->
    container.unslick()
