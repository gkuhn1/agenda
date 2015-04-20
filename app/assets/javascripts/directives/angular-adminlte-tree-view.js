angular.module('ng-adminlte-treeview', [])

.directive('ngTreeview', ['$state',
  function($state) {
    return {
      restrict: 'A',
      scope: {
        ngModel: '=',
        activeState: '='
      },
      link: function(scope, el, attrs) {
        scope.ngModel = $state.inc(scope.activeState) || scope.ngModel || false;
        state = $state;
        sc = scope;
        e = el;
        console.log(scope.ngModel);

        var toggle_close = function() {
          el.removeClass('active')
          el.find('ul.treeview-menu').removeClass('menu-open');
          scope.ngModel = false;
        }

        var toggle_open = function() {
          el.addClass('active')
          el.find('ul.treeview-menu').addClass('menu-open');
          scope.ngModel = true;
        }

        var toggle_class = function() {
          scope.ngModel ? toggle_close() : toggle_open();
        }

        el.bind('click', toggle_class);
        el.children('ul').bind('click', function(e) { e.stopPropagation() });
        if (scope.ngModel) toggle_open();
      }
    };
  }
]);