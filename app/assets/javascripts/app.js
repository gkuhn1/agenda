angular.module('agenda', [
  // Services
  'agenda.authservice',
  'agenda.userservice',
  'agenda.accountservice',

  // Controllers
  'agenda.accounts',
  'agenda.admin',
  'agenda.home',
  'agenda.login',
  'agenda.users',

  // States
  'agenda.grandfather',
  'agenda.states-home',
  'agenda.states-error',
  'agenda.states-login',
  'agenda.states-users',
  'agenda.states-accounts',

  'agenda.states-admin',

  // Components
  'httpq',
  'agenda.checklist',
  'agenda.ng-really-click',
  'agenda.server-error',
  'doowb.angular-pusher'
])

// CONFIGS

.config(['PusherServiceProvider',
  function(PusherServiceProvider) {
    PusherServiceProvider
    .setToken('41811f1ba9ee13be83cd')
    .setOptions({});
  }
])


.config(['$httpProvider', function($httpProvider) {

  $httpProvider.interceptors.push(['$rootScope', '$q', function($rootScope, $q) {
    return {
      request: function(request) {
        $rootScope.$broadcast("loading_start");
        return request;
      },
      response: function(response) {
        $rootScope.$broadcast("loading_stop");
        return response;
      },
      responseError: function(rejection) {
        $rootScope.$broadcast("loading_stop");

        if (rejection.status == 403) {
          window.location.url('/');
        }

        return $q.reject(rejection);
      }
    }
  }])

}])


.run(['$rootScope', '$state', '$stateParams', 'Auth',
    function ($rootScope,   $state,   $stateParams,  Auth) {

      // It's very handy to add references to $state and $stateParams to the $rootScope
      // so that you can access them from any scope within your applications.For example,
      // <li ng-class="{ active: $state.includes('contacts.list') }"> will set the <li>
      // to active whenever 'contacts.list' or one of its decendents is active.
      $rootScope.$state = $state;
      $rootScope.$stateParams = $stateParams;

      $dbg = $rootScope;

      $rootScope.$state.inc = function(include) {
        return $state.current.name.indexOf(include) > -1
      }

      $rootScope.$on('$stateChangeStart', function (event, to, toParams, from, fromParams) {
        // Show a loading message until promises are not resolved
        $rootScope.$broadcast("loading_start");

        Auth.authorize(event, to, toParams, from, fromParams);
      });

      $rootScope.$on('$stateChangeSuccess', function(e, curr, prev) {
        // Hide loading message
        $rootScope.$broadcast("loading_stop");
      });

      $rootScope.$on('loading_start', function() {
        $rootScope.loadingView = true;
      });

      $rootScope.$on('loading_stop', function() {
        $rootScope.loadingView = false;
      });

      $rootScope.$on('currentAccountSelected', function(event, account) {
        console.log('current_account selected', account);
        $state.go('app.home', {}, {reload: true});
      })

      $rootScope.$on('currentUserSelected', function(event, user) {
        console.log('current_user selected', user);
      })

    }
])