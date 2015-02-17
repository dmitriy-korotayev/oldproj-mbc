#= require jquery

#= require js-breakpoints
#= require remodal

#= require headroom.js/dist/headroom.js
#= require headroom.js/dist/jQuery.headroom.js

#= require vendor/jquery.mailable

$ ->
  window.env = document.location.hostname && 'dev' || 'prod'

  # ----- Header -----

  # hiding
  header = $('header.main')
  header.headroom()
  # sidebar
  header.find('.sidebar-toggle').click ->
    $('body').      toggleClass('sidebar-active')
    $('aside.main').toggleClass('active')


  # ----- Location link hiding -----
  $('.location-link').headroom()

  # ----- Modals -----
  # Sizing of text-content-containing modals
  $('.remodal:has(.contents)').on 'opened', ->
    vmargin =
      parseInt($(this).css('margin-top')) +
      parseInt($(this).css('margin-bottom'))
    height = $(this).height()
    windowHeight = $(window).height()
    if height+vmargin > windowHeight
      $(this).css('height', "#{windowHeight-vmargin}px")

  # Mailable forms
  $('.remodal form.mailable').mailable
    url: window.env == 'dev' && 'http://localhost:3000/mail' || 'http://mbc-mailer.herokuapp.com/mail'

