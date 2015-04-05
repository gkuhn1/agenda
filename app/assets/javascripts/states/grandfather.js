angular.module('agenda.grandfather', ['ui.router', 'agenda.authservice'])
.config(['$stateProvider', function ($stateProvider) {
  $stateProvider
    .state('public', {
      abstract: true,
      data: {
        access: accessLevels.public
      }
    })
    .state('app', {
      abstract: true,
      data: {
        access: accessLevels.user
      }
    })
    .state('app.admin', {
      abstract: true,
      data: {
        access: accessLevels.admin
      }
    })
    .state('app.sysadmin', {
      abstract: true,
      data: {
        access: accessLevels.sysadmin
      }
    })
}]);