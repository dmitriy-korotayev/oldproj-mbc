#= require jquery.customSelect/jquery.customSelect
#= require jquery-ui
#= require jquery.scrollTo/jquery.scrollTo
#= require helpers/images
#= require vendor/jquery.ajaxFilter

$ ->
  $('select').customSelect()

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
  template = container.children('a.item.template')
  secondaryContainer = container.siblings('.items.list').find('tbody')
  secondaryTemplate  = secondaryContainer.children('.template')
  sampleDataToGenerate = {tele2: 'A/S TELE2', delfi: 'A/S DELFI', yit: 'SIA YIT', hilti: 'SIA Hilti'}
  sampleData = $.map sampleDataToGenerate, (title, name) ->
    url: 'client.html'
    image_src_mobile:  "#{image_path 'sections'}/clients/#{name}.png"
    image_src_tablet:  "#{image_path 'sections'}/clients/#{name}--tablet.png"
    image_src_desktop: "#{image_path 'sections'}/clients/#{name}--desktop.png"
    title: title
    description: 'Mobilo sakaru pakalpojumi'
    address: 'Mukusalas 41b'
    phone: '+371 200 200 00'


  # init
  form.ajaxFilter [container, secondaryContainer], [template, secondaryTemplate],
    data: window.itemsData || null
    sampleData: window.itemsSampleFirstData && sampleData || []
    sampleFirstData: window.itemsSampleFirstData || []
    dataFilter: (data, formData) ->
      f = formData

      data = $.map data, (item,i)->
        if f.letter
          return null if f.letter.constructor == String && f.letter != 'all' && item.title.charAt(0).toLowerCase() != f.letter
          return null if f.letter.constructor == Array && f.letter.indexOf('all') == -1 && f.letter.indexOf(item.title.charAt(0).toLowerCase()) == -1
        if f.search
          return null if item.title.toLowerCase().indexOf(f.search.toLowerCase()) == -1
        item


      data


  # search clear
  form.find('.clear').click ->
    $(this).siblings('input').val('').change()

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

