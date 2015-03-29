var app = angular.module('agenda', ['ui.router', 'doowb.angular-pusher']);

app.factory('$httpq', function($http, $q) {
  return {
    get: function() {
      var deferred = $q.defer();
      $http.get.apply(null, arguments)
      .success(function(data) {
        deferred.resolve(data)
      })
      .error(deferred.reject);
      return deferred.promise;
    }
  }
});

routes = function(app_name) {

  if (app_name == 'Admin') {

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
          .state('accounts', {
            url: "/accounts",
            views: {
              content: {
                templateUrl: "/templates/admin/accounts/index.html",
                controller: "AccountsCtrl"
              },
              menu: {templateUrl: "/templates/admin/menu.html"}
            },
            resolve: {
              accounts: function(AccountService){
                return AccountService.all();
              }
            }
          })
            .state('accounts_new', {
              url: "/accounts/new",
              views: {
                content: {
                  controller: "NewAccountCtrl",
                  templateUrl: "/templates/admin/accounts/new.html"
                },
                menu: {templateUrl: "/templates/admin/menu.html"}
              }
            })
            .state('accounts_show', {
              url: "/accounts/:id",
              views: {
                content: {
                  controller: 'ShowAccountCtrl',
                  templateUrl: "/templates/admin/accounts/show.html"
                },
                menu: {templateUrl: "/templates/admin/menu.html"}
              },
              resolve: {
                account: function($stateParams, AccountService) {
                  return AccountService.get($stateParams.id)
                }
              }
            })
            .state('accounts_edit', {
              url: "/accounts/:id/edit",
              views: {
                content: {templateUrl: "/templates/admin/accounts/edit.html"},
                menu: {templateUrl: "/templates/admin/menu.html"}
              }
            })

        $urlRouterProvider.otherwise('/');
      }
    ])

  }

}

routes("Admin")


// CONFIGS

app.config(['PusherServiceProvider',
  function(PusherServiceProvider) {
    PusherServiceProvider
    .setToken('41811f1ba9ee13be83cd')
    .setOptions({});
  }
]);


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

    }
  ]
)