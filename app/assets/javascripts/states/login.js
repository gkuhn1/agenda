angular.module('agenda.states-login', ['agenda.grandfather'])
.config(['$stateProvider',
  function($stateProvider) {

    $stateProvider

      .state('public.login', {
        url: "/login",
        controller: 'LoginCtrl',
        templateUrl: "/templates/login/application.html",
        resolve: {
          current_user: ['Auth', function(Auth){
            return Auth.current_user();
          }]
        }
      })

      .state('public.register', {
        url: "/register",
        controller: 'RegisterCtrl',
        templateUrl: "/templates/login/register.html",
      })

      .state('app.select_account', {
        url: "/login/select_account",
        controller: 'LoginCtrl',
        templateUrl: "/templates/login/select_account.html"
      })

      .state('app.logout', {
        url: "/logout",
        controller: ['Auth', '$state', function(Auth, $state) {
          console.log('logout controller');
          Auth.logout();
          $state.go('public.login', {}, {inherit: false});
        }]
      })

  }
]);