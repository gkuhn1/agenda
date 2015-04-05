/**
 * A generic confirmation for risky actions.
 * Usage: Add attributes: ng-really-message="Are you sure?" ng-really-click="takeAction()" ng-really-cancel-click="cancelAction()" function
 */
angular.module('agenda.ng-really-click', []).directive('ngReallyClick', [function() {
    return {
        restrict: 'A',
        link: function(scope, element, attrs) {
            element.bind('click', function() {
                var message = attrs.ngReallyMessage;
                if (!message){
                    return;
                }
                if (confirm(message)) {
                    scope.$apply(attrs.ngReallyClick);
                } else {
                    scope.$apply(attrs.ngReallyCancelClick);
                }
            });
        }
    }
}]);