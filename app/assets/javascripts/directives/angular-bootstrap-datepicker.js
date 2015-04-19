angular.module('ng-bootstrap-datepicker', [])

.directive('ngDatepicker', function() {
  return {
    restrict: 'A',
    replace: true,
    scope: {
      ngOptions: '=',
      ngModel: '='
    },
    link: function(scope, el) {
      scope.inputHasFocus = false;
      var element = $(el);
      var settings = $.extend($.fn.datepicker.defaults, scope.ngOptions);
      element.datepicker(scope.ngOptions).on('changeDate', function(e) {
        if (scope.ngOptions.onSelect !== undefined) scope.ngOptions.onSelect.call(this, e, settings);
        return scope.$apply(function() {
          scope.ngModel = $.fn.datepicker.DPGlobal.formatDate(e.date, settings.format, settings.language);
        });
      });
      if (scope.ngOptions.init !== undefined) scope.ngOptions.init.call(element, element, settings);
    }
  };
});