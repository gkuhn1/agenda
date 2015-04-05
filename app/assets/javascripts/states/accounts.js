angular.module('agenda.states-accounts', ['agenda.grandfather'])
.config(['$stateProvider',
  function($stateProvider) {

    $stateProvider
      .state('admin.accounts', {
        url: "/accounts",
        views: {
          content: {
            templateUrl: "/templates/admin/accounts/index.html",
            controller: "AccountsCtrl"
          },
          menu: {templateUrl: "/templates/admin/menu.html"}
        },
        resolve: {
          accounts: ['AccountService', function(AccountService){
            return AccountService.all();
          }]
        }
      })
        .state('admin.accounts_new', {
          url: "/accounts/new",
          views: {
            content: {
              controller: "NewAccountCtrl",
              templateUrl: "/templates/admin/accounts/form.html"
            },
            menu: {templateUrl: "/templates/admin/menu.html"}
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
        .state('admin.accounts_show', {
          url: "/accounts/:id",
          views: {
            content: {
              controller: 'ShowAccountCtrl',
              templateUrl: "/templates/admin/accounts/show.html"
            },
            menu: {templateUrl: "/templates/admin/menu.html"}
          },
          resolve: {
            account: ['$stateParams', 'AccountService', function($stateParams, AccountService) {
              return AccountService.get($stateParams.id)
            }]
          }
        })
        .state('admin.accounts_edit', {
          url: "/accounts/:id/edit",
          views: {
            content: {
              controller: "NewAccountCtrl",
              templateUrl: "/templates/admin/accounts/form.html"
            },
            menu: {templateUrl: "/templates/admin/menu.html"}
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