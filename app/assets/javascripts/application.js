// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require angular.min
//= require angular-ui-router.min

//= require jquery
//= require bootstrap-sprockets
//= require iCheck/icheck.min
//= require routing-config
//= require moment/moment.min
//= require fullcalendar/fullcalendar.min
//= require fullcalendar/fullcalendar.pt-BR.min

//= require datepicker/bootstrap-datepicker
//= require datepicker/locales/bootstrap-datepicker.pt-BR

// Angular extras
//= require angular-pusher.min
//= require angular-input-masks/angular-input-masks.br
//= require ladda/js/spin
//= require ladda/js/ladda
//= require angular-ladda/dist/angular-ladda
//= require angular-ui-calendar/calendar

// Angular app
//= require_tree ./services
//= require_tree ./controllers
//= require_tree ./states
//= require_tree ./directives
//= require app

function contentWrapperHeight(e) {
  $('.content-wrapper').css('minHeight', $(window).height()-$('header.main-header').height());
}

$(document).ready(function() {
  $(window).resize(contentWrapperHeight);
})