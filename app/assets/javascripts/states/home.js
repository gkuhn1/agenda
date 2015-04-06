angular.module('agenda.states-home', ['agenda.grandfather'])
.config(['$stateProvider','$urlRouterProvider',
  function($stateProvider , $urlRouterProvider) {
    $urlRouterProvider.otherwise('/');

    $stateProvider
      .state('app.header', {
        abstract: true,
        templateUrl: "/templates/header.html",
        controller : 'HeaderCtrl'
      })
      .state('app.header.sidebar', {
        abstract: true,
        templateUrl: "/templates/sidebar.html",
        controller: 'SidebarCtrl'
      })
      .state('app.header.sidebar.home', {
        url: "/",
        controller: 'HomeCtrl',
        templateUrl: "/templates/application.html"
      })

  }
]);
