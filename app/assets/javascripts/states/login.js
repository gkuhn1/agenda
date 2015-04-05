angular.module('agenda.states-login', ['agenda.grandfather'])
.config(['$stateProvider',
  function($stateProvider) {

    $stateProvider

      .state('public.login', {
        url: "/login",
        views: {
          'wrapper@': {
            controller: 'LoginCtrl',
            templateUrl: "/templates/login/application.html"
          },
          header: {template: ""}
        },
        resolve: {
          current_user: ['Auth', function(Auth){
            return Auth.current_user();
          }]
        }
      })

      .state('app.select_account', {
        url: "/login/select_account",
        views: {
          'wrapper@': {
            controller: 'LoginCtrl',
            templateUrl: "/templates/login/select_account.html"
          },
          header: {template: ""}
        }
      })

      .state('app.logout', {
        url: "/logout",
        views: {
          'wrapper@': {
            controller: ['Auth', '$state', function(Auth, $state) {
              console.log('logout controller');
              Auth.logout();
              $state.go('public.login', {}, {inherit: false});
            }]
          }
        }
      })

  }
]);