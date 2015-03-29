app.config([
          '$stateProvider','$urlRouterProvider',
  function($stateProvider , $urlRouterProvider) {

    $stateProvider
      .state('home', {
          url: "/",
          controller: 'AdminCtrl',
          views: {
            menu: {templateUrl: "/templates/admin/menu.html"},
            content: {templateUrl: "/templates/admin/home.html"}
          }
      })

    $urlRouterProvider.otherwise('/');
  }
])