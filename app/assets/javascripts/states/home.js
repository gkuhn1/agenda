angular.module('agenda.states-home', ['agenda.grandfather'])
.config(['$stateProvider','$urlRouterProvider',
  function($stateProvider , $urlRouterProvider) {
    $urlRouterProvider.otherwise('/');

    $stateProvider
      .state('app.header', {
        abstract: true,
        templateUrl: "/templates/header.html",
        controller : 'HeaderCtrl',
        resolve: {
          notifications: ['NotificationService', function(NotificationService) {
            return NotificationService.all();
          }]
        }
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

      .state('app.header.sidebar.home.search', {
        url: "search",
        controller: 'SearchCtrl',
        templateUrl: "/templates/search.html",
        resolve: {
          places: ['SearchService', function(SearchService) {
            return SearchService.all_places();
          }],
          specialties: ['SearchService', function(SearchService) {
            return SearchService.all_specialties();
          }]
        }
      })

  }
]);
