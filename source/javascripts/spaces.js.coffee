#= require jquery.customSelect/jquery.customSelect
#= require helpers/images

#= require jquery-ui
#= require jquery.scrollTo/jquery.scrollTo

#= require vendor/jquery.ajaxFilter
#= require purl

#= require vendor/slick

$ ->
  # --- Building rollout ---

  # Show according building on this page
  Breakpoints.on
    name: 'tablet'
    matched: ->
      $('a.tip').click (e)->
        e.preventDefault()
        # some loading magic maybe
        building_id = $(this).attr('href').split('#')[1]
        building_container = $('section.building').removeClass('active').filter("##{building_id}").addClass('active')
        scroll = ->
          $.scrollTo building_container, 1500,
            easing: 'easeInOutQuart'
            offset: -30
        setTimeout(scroll, 500)
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

  # Preamble
  form = null
  Breakpoints.on
    name: 'mobile-only'
    matched: ->
      form = $('form.filters.mobile-only')
  Breakpoints.on
    name: 'tablet'
    matched: ->
      form = $('form.filters.tablet')


  # ajaxFilter variables
  url = null
  container = form.parent().find('.items.grid')
  template  = container.children('.item.template')
  secondaryContainer = container.siblings('.items.list').find('tbody')
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


  # init
  form.ajaxFilter [container, secondaryContainer], [template, secondaryTemplate],
    data: window.itemsData || null
    sampleData: window.itemsSampleFirstData && sampleData || []
    sampleFirstData: window.itemsSampleFirstData || []
    dataFilter: (data, formData) ->
      f = formData

      data = $.map data, (item,i)->
        if f.building_class
          return null if f.building_class.constructor == String && f.building_class != item.building_class
          return null if f.building_class.constructor == Array  && f.building_class.indexOf(item.building_class) == -1
        if f.building_number
          return null if f.building_number != "0" && f.building_number != String(item.building_number)
        if f.limit_price_min
          return null if item.price < parseInt(f.limit_price_min)
        if f.limit_price_max
          return null if item.price > parseInt(f.limit_price_max)
        if f.limit_area_min
          return null if item.area < parseInt(f.limit_area_min)
        if f.limit_area_max != ''
          return null if item.area > parseInt(f.limit_area_max)
        item

      sort = {}

      sort.area  = f.sort_area  if f.sort_price
      sort.price = f.sort_price if f.sort_price
      if f.sort # mobile
        a_o = f.sort.split('_')
        attribute = a_o[0]
        order = a_o[1]
        sort[attribute] = order

      $.each sort, (attribute,order)->
        if order != '0'
          data = data.sort (a,b)->
            return if order == 'asc'
              a[attribute] - b[attribute]
            else
              b[attribute] - a[attribute]

      data

    onDataChange: (data)->
      form.siblings('h1').find('span.number').html(data.length)


  # init selects and redraw them on filter reset
  customSelects = $('select').customSelect()
  console.log form.find('[type=reset]')
  form.find('[type=reset]').click ->
    setTimeout ->
      customSelects.trigger('render')
    , 10

  # Reset another sorting on change of one
  s_price = form.find('[name=sort_price]')
  s_area =  form.find('[name=sort_area]')
  s_price.change ->
    if($(this).val() != '0')
      s_area.val '0'
      s_area.change()
  s_area.change ->
    if($(this).val() != '0')
      s_price.val '0'
      s_price.change()


  # filter -> type change if given in hash
  changeFilterBuildingNumber = ->
    filter_bnumber = $.url().fparam('filter_building_number')
    if filter_bnumber
      form.find('[name="building_number"]').val(filter_bnumber).change()
      $.scrollTo form, 1500,
        easing: 'easeInOutQuart'
        offset: -100
  changeFilterBuildingNumber()
  $(window).on 'hashchange', ->
    changeFilterBuildingNumber()


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


  # --- Modal: space - carousel ---

  modal = $('.remodal.space')
  modal.on 'opened', ->
    container = modal.children('.image')
    firstPlanItem = container.children('div.plan').first()
    firstPlanItemIndex = container.children().index(firstPlanItem)
    if $(this).width() < parseInt $(this).css('max-width')
      container.css('width',  "#{$(window).width() }px")
    container.on 'init', ->
      if firstPlanItem.length
        button = $('<button class="plan"/>')
        button.appendTo container
        button.click ->
          container.slick('slickGoTo', firstPlanItemIndex)

    container.slick
      autoplay: true
      autoplaySpeed: 6000
      arrows: true
      fade: true
      fadeIn: true
      cssEase: 'linear'

  modal.on 'closed', ->
    container.find('button.plan').remove()
    container.slick('unslick')

