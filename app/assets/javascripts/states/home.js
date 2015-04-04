app.config(['$stateProvider','$urlRouterProvider',
  function($stateProvider , $urlRouterProvider) {
    $urlRouterProvider.otherwise('/');

    $stateProvider
      .state('home', {
        url: "/",
        views: {
          wrapper: {
            controller: 'HomeCtrl',
            templateUrl: "/templates/application.html"
          },
          header: {
            controller: 'HeaderCtrl',
            templateUrl: "/templates/header.html"
          },
          'sidebar@home': {
            templateUrl: "/templates/sidebar.html"
          }
        },
        resolve: {
          current_account: ['AccountService', function(AccountService){
            return AccountService.current();
          }],
          current_user: ['UserService', function(UserService){
            return UserService.current();
          }]
        }
      })

  }
]);