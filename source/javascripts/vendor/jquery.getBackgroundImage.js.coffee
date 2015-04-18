#= require imagesloaded/imagesloaded.pkgd
$.fn.useBackgroundImage = (callback = ((image)->))->
  image = new Image
  image_url = $(this).css('background-image')
  image.src = image_url.replace(/url\(|\)$/ig, "")
  imagesLoaded image, (instance)->
    if instance.elements.length
      callback(instance.elements[0])
    else
      console.log 'useBackgroundImage: no images loaded'
