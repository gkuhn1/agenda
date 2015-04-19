angular.module('agenda', [
  // Services
  'agenda.authservice',
  'agenda.userservice',
  'agenda.accountservice',
  'agenda.adminservice',
  'agenda.calendarservice',

  // Controllers
  'agenda.accounts',
  'agenda.admin',
  'agenda.home',
  'agenda.login',
  'agenda.users',
  'agenda.calendars',

  // States
  'agenda.grandfather',
  'agenda.states-home',
  'agenda.states-error',
  'agenda.states-login',
  'agenda.states-users',
  'agenda.states-accounts',
  'agenda.states-calendars',

  'agenda.states-admin',

  // Components
  'httpq',
  'agenda.checklist',
  'agenda.ng-really-click',
  'ng-bootstrap-datepicker',
  'agenda.server-error',
  'doowb.angular-pusher',
  'ui.utils.masks',
  'ui.calendar',
  'angular-ladda'
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
        var user = angular.fromJson(localStorage.getItem('currentUser'));
        var account = angular.fromJson(localStorage.getItem('currentAccount'));
        var auth_string = "";

        if (user)
          auth_string = user.token + ":";
        if (account)
          auth_string += (account.id || account._id);

        request.headers.Authorization = 'Basic ' + btoa(auth_string);
        console.log(request);
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


.run(['$rootScope', '$state', '$stateParams', '$timeout', 'Auth',
    function ($rootScope,   $state,   $stateParams, $timeout,  Auth) {

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

        var selectAccountState = 'app.select_account';
        if (Auth.current_account() === null && Auth.current_user() !== null && to.name != selectAccountState) {
          // Se current account for null deve redirecionar para a busca de conta
          event.preventDefault();
          $rootScope.$broadcast("loading_stop");
          console.info("redirecting to" + selectAccountState);
          $state.go(selectAccountState, {}, {});
        }

        Auth.authorize(event, to, toParams, from, fromParams);
      });

      $rootScope.$on('$stateChangeSuccess', function(e, curr, prev) {
        // Hide loading message
        $rootScope.$broadcast("loading_stop");
        contentWrapperHeight();

        $rootScope.current_account = Auth.current_account();
        $rootScope.current_user = Auth.current_user();
      });

      $rootScope.$on('loading_start', function() {
        $rootScope.loadingView = true;
      });

      $rootScope.$on('loading_stop', function() {
        $timeout(function() {
          $rootScope.loadingView = false;
        });
      });

      $rootScope.$on('currentAccountSelected', function(event, account) {
        console.log('current_account selected', account);
        $state.go('app.header.sidebar.home', {}, {reload: true});
      })

      $rootScope.$on('currentUserSelected', function(event, user) {
        console.log('current_user selected', user);
        $rootScope.current_user = Auth.current_user();
      })

    }
])

Array.prototype.findById = function(elem) {
  if (elem.id !== undefined) elem = elem.id;
  return $.grep(this, function(element, index){ return element.id == elem; })[0];
}

Array.prototype.indexOfById = function(elem) {
  if (elem.id !== undefined) elem = elem.id;
  return this.map(function(el) { return el.id }).indexOf(elem);
}
