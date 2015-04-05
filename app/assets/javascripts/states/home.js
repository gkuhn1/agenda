angular.module('agenda.states-home', ['agenda.grandfather'])
.config(['$stateProvider','$urlRouterProvider',
  function($stateProvider , $urlRouterProvider) {
    $urlRouterProvider.otherwise('/');

    $stateProvider
      .state('app.home', {
        url: "/",
        views: {
          'wrapper@': {
            controller: 'HomeCtrl',
            templateUrl: "/templates/application.html"
          },
          'header@': {
            controller: 'HeaderCtrl',
            templateUrl: "/templates/header.html"
          },
          'sidebar@app.home': {
            controller: 'SidebarCtrl',
            templateUrl: "/templates/sidebar.html"
          }
        }
      })

  }
]);
