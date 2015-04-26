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

//= require jquery
//= require angular.min
//= require angular-ui-router.min

//= require bootstrap-sprockets
//= require iCheck/icheck.min
//= require routing-config
//= require moment/moment.min
//= require fullcalendar/fullcalendar
//= require fullcalendar/fullcalendar.pt-BR.min
//= require colorpicker/bootstrap-colorpicker
//= require datepicker/bootstrap-datepicker
//= require datepicker/locales/bootstrap-datepicker.pt-BR

// Angular extras
//= require angular-pusher.min
//= require angular-input-masks/angular-input-masks.br
//= require angular-mask/dist/ngMask.min
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
  $('.content-wrapper').css('minHeight', ($(window).height()-$('.main-header').height()));
  $('.main-sidebar').css('height', ($('.content-wrapper').height()+50));
}

/* center modal */
function centerModals(){
  $('.modal').each(function(i){
    var $clone = $(this).clone().css('display', 'block').appendTo('body');
    var top = Math.round(($clone.height() - $clone.find('.modal-content').height()) / 2);
    top = top > 0 ? top : 0;
    $clone.remove();
    $(this).find('.modal-content').css("margin-top", top);
  });
}

$(document).ready(function() {
  $(window).resize(contentWrapperHeight);

  // Centering modals in window
  $(document).on('shown.bs.modal', '.modal', centerModals);
  $(window).on('resize', centerModals);
})

