// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap.min

$(document).ready(function(){
    $('.day-item, .menu-left-item, .my_button').mouseover(function(){
        $(this).fadeTo('medium', 0.5);
        $(this).css('cursor', 'pointer');
    });

    $('.day-item, .menu-left-item, .my_button').mouseleave(function(){
        $(this).fadeTo('medium', 1);
    });
    $('.pull-me-genre').click(function() {
        $('.panel-genre').slideToggle('slow');
    });
    $('.pull-me-duration').click(function() {
        $('.panel-duration').slideToggle('slow');
    });
    $('.pull-me-channels').click(function() {
        $('.panel-channels').slideToggle('slow');
    });

    $('.pull-me-producent').click(function() {
        $('.panel-producent').slideToggle('slow');
    });

    $('.pull-me-year').click(function() {
        $('.panel-year').slideToggle('slow');
    });

    $('.pull-me-filter').click(function() {
        $('.panel-filter').slideToggle('slow');
    });



    $('input[type="checkbox"]').checkbox();

});
