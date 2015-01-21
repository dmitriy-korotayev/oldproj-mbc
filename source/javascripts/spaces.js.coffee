#= require jquery.customSelect/jquery.customSelect
#= require jquery-ui
#= require jquery.scrollTo/jquery.scrollTo
#= require helpers/images
#= require vendor/jquery.ajaxFilter
#= require remodal
#= require purl

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
          $.scrollTo 'section.spaces', 1500,
            easing: 'easeInOutQuart'
            offset: -50
        , 500)


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
  template = container.children('.item.template')
  sampleData = Array.apply(null, new Array(3)).map ->
    image_url: "#{image_path 'spaces'}/1.jpg"
    info_area_number: 200
    info_price_number: 8
    info_building_number: 2
    extra_html: """
      <li>
        <div class="number">3</div>
        <div class="text">stāvs</div>
      </li>
      <li>
        <div class="number">7</div>
        <div class="text">autostāvvieta</div>
      </li>
      <li>
        <i class="check"></i>
        <div class="text">mēbeles</div>
      </li>
      <li>
        <i class="cross"></i>
        <div class="text">pārlukošana</div>
      </li>"""

  form.ajaxFilter container, template,
    sampleData: sampleData


  # Filter -> type change if given in hash
  changeFilterType = ->
    filter_type = $.url().fparam('filter_type')
    if filter_type
      form.find('[name="type"]').val(filter_type).change()
  changeFilterType()
  $(window).on('hashchange', changeFilterType)
