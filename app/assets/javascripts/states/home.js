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
        templateUrl: "/templates/search/index.html",
        resolve: {
          places: ['SearchService', function(SearchService) {
            return SearchService.all_places();
          }],
          specialties: ['SearchService', function(SearchService) {
            return SearchService.all_specialties();
          }]
        }
      })
        .state('app.header.sidebar.home.search.addtask', {
          url: "/add/:account_id/:base64_data",
          controller: 'SearchAddTaskCtrl',
          templateUrl: "/templates/search/add_task.html",
          resolve: {
            params: ["$stateParams", function($stateParams) {
              return $stateParams.base64_data.toObject();
            }]
          },
          onExit: function(){
            console.log('exit');
            $('#createTaskModal').modal('hide');
          }
        })

  }
]);
