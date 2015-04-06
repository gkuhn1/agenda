angular.module('agenda.states-accounts', ['agenda.grandfather'])
.config(['$stateProvider',
  function($stateProvider) {

    $stateProvider
      .state('app.sysadmin.home.accounts', {
        url: "accounts",
        views: {
          'content@app.sysadmin.home': {
            templateUrl: "/templates/admin/accounts/index.html",
            controller: "AccountsCtrl"
          }
        },
        resolve: {
          accounts: ['AccountService', function(AccountService){
            return AccountService.all();
          }]
        }
      })
        .state('app.sysadmin.home.accounts.new', {
          url: "new",
          views: {
            'content@app.sysadmin.home': {
              controller: "NewAccountCtrl",
              templateUrl: "/templates/admin/accounts/form.html"
            }
          },
          resolve: {
            users: ['UserService', function(UserService) {
              return UserService.all();
            }],
            newAccount: ['AccountService', function(AccountService) {
              return AccountService.new();
            }]
          },
          data: {
            edit: false
          }
        })
        .state('app.sysadmin.home.accounts.show', {
          url: ":id",
          views: {
            'content@app.sysadmin.home': {
              controller: 'ShowAccountCtrl',
              templateUrl: "/templates/admin/accounts/show.html"
            }
          },
          resolve: {
            account: ['$stateParams', 'AccountService', function($stateParams, AccountService) {
              return AccountService.get($stateParams.id)
            }]
          }
        })
        .state('app.sysadmin.home.accounts.edit', {
          url: ":id/edit",
          views: {
            'content@app.sysadmin.home': {
              controller: "NewAccountCtrl",
              templateUrl: "/templates/admin/accounts/form.html"
            }
          },
          resolve: {
            users: ['UserService', function(UserService) {
              return UserService.all();
            }],
            newAccount: ['AccountService', '$stateParams', function(AccountService, $stateParams) {
              return AccountService.get($stateParams.id);
            }]
          },
          data: {
            edit: true
          }
        })
  }
]);