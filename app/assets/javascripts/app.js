var app = angular.module('agenda', ['ui.router', 'doowb.angular-pusher']);

// CONFIGS

app.config(['PusherServiceProvider',
  function(PusherServiceProvider) {
    PusherServiceProvider
    .setToken('41811f1ba9ee13be83cd')
    .setOptions({});
  }
]);


app.config(['$httpProvider', function($httpProvider) {

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


app.run(
  [          '$rootScope', '$state', '$stateParams',
    function ($rootScope,   $state,   $stateParams) {

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

      $rootScope.$on('$stateChangeStart', function(e, curr, prev) {
        // Show a loading message until promises are not resolved
        $rootScope.$broadcast("loading_start");
      });

      $rootScope.$on('$stateChangeSuccess', function(e, curr, prev) {
        // Hide loading message
        $rootScope.$broadcast("loading_stop");
        $rootScope.loadingView = false;
      });

      $rootScope.$on('loading_start', function() {
        $rootScope.loadingView = true;
      });

      $rootScope.$on('loading_stop', function() {
        $rootScope.loadingView = false;
      });

    }
  ]
)