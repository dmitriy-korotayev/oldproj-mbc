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

  # ----- Sizing of window-height modals -----
  $('.remodal.window-height').on 'opened', ->
    vmargin =
      parseInt($(this).css('margin-top')) +
      parseInt($(this).css('margin-bottom'))
    $(this).css('height', "#{$(window).height()-vmargin}px")

  # --- Modal: mailable forms ---
  $('.remodal form.mailable').mailable
    url: window.env == 'dev' && 'http://localhost:3000/mail' || 'http://mbc-mailer.herokuapp.com/mail'
