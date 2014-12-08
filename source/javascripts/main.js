// header
var header  = $('header.main'),
    wrapper = $('.wrapper');
// -horizontal scroll
$(window).on('load scroll resize', function(){
    if(header.width() != $(this).width())
        // (header width - window width) * (left scroll / (full width - window width)) 
        header.css('left', 
            -(header.width() - $(this).width()) * 
            ($(this).scrollLeft() / 
                ( wrapper.width() - $(this).width())
            )
        );
    else if(header.css('left') != '0px')
        header.css('left', 0);
});
// -wrapper height > header height
$(window).on('ready resize', function(){
    if(wrapper.width() < header.width())
        wrapper.css('width',header.width());
});

// Search input slide
$('header.main .search-toggle').click(function(){
    var form = $(this).siblings('.search-form');
    if(form.is(':hidden'))
        form.show().animate({width: form.find('form input').outerWidth()+'px'}, 500);
    else {
        form.animate({width: 0}, 500);
        setTimeout(function(){ form.hide() } , 500);
    }
});
$('.input-reset').click(function(){
    $(this).prev('input').val('').focus();
    return false;
})

// Navigation
$('header.main nav>ul>li').hover(
    function(){$(this).has('div.submenu').children('div.submenu').show()},
    function(){$(this).has('div.submenu').not(":has(li.active)") .children('div.submenu').hide()}
);
$('section.main nav>ul>li').has('li.active').addClass('active').children('ul').show();

// Slider 
if($.fn.unslider)
    $('.unslider').unslider({
        speed: 700,               //  The speed to animate each slide (in milliseconds)
        delay: 6000,              //  The delay between slide animations (in milliseconds)
        dots: true,               //  Display dot navigation
        fluid: false              //  Support responsive design. May break non-responsive designs
    });

// vflex        
if($.fn.vflex)
    $('.vflex').vflex();

// popup
if($.fn.magnificPopup)
    $('section.brands .deals .clip .title a').add
     ('section.brands .deals .clip .image a').magnificPopup({
        type: 'inline',
        mainClass: 'popup deal',
    });

// Other
$('input.remove,textarea.remove').click(function(){$(this).val('')});
