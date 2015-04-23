angular.module('agenda.states-configs', ['agenda.grandfather'])
.config(['$stateProvider',
  function($stateProvider) {

    $stateProvider
      .state('app.header.config-sidebar', {
        abstract: true,
        templateUrl: "/templates/config/sidebar.html"
      })
      .state('app.header.config-sidebar.home', {
        url: "/account",
        controller: 'AccountConfigHomeCtrl',
        templateUrl: "/templates/config/home.html",
        resolve: {
        }
      })

  }
]);