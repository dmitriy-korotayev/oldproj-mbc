#= require jquery
#= require js-breakpoints
#= require headroom.js/dist/headroom.js
#= require headroom.js/dist/jQuery.headroom.js

$ ->
  # ----- Navigation hiding -----

  header = $('header.main')
  header.headroom()

  header.find('.sidebar-toggle').click ->
    $('body').      toggleClass('sidebar-active')
    $('aside.main').toggleClass('active')
