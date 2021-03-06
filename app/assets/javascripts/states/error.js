angular.module('agenda.states-error', ['agenda.grandfather'])
.config(['$stateProvider', function ($stateProvider) {
  $stateProvider
    .state('app.error', {
      url: '/error/:error',
      views: {
        wrapper: {
          templateUrl: "/templates/error.html"
        }
      },
      accessLevel: accessLevels.public
    });
}]);
