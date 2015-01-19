#= require jquery.customSelect/jquery.customSelect
#= require jquery-ui
#= require jquery.scrollTo/jquery.scrollTo
#= require helpers/images
#= require vendor/jquery.ajaxFilter

$ ->
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


  $('select').customSelect()

  # Dynamic items filter
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
  container = form.siblings('.items')
  template = container.children('a.item.template')
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


  form.ajaxFilter container, template,
    sampleData: sampleData
