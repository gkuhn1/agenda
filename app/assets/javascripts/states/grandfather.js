angular.module('agenda.grandfather', ['ui.router', 'agenda.authservice'])
.config(['$stateProvider', function ($stateProvider) {
  $stateProvider
    .state('public', {
      abstract: true,
      template: "<div ui-view></div>",
      data: {
        access: accessLevels.public
      }
    })
    .state('app', {
      abstract: true,
      template: "<div ui-view></div>",
      data: {
        access: accessLevels.user
      }
    })
}]);