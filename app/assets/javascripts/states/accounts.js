angular.module('agenda.states-accounts', ['agenda.grandfather'])
.config(['$stateProvider',
  function($stateProvider) {

    $stateProvider
      .state('app.header.admin-sidebar.home.accounts', {
        url: "/accounts",
        templateUrl: "/templates/admin/accounts/index.html",
        controller: "AccountsCtrl",
        resolve: {
          accounts: ['AccountService', function(AccountService){
            return AccountService.all();
          }]
        }
      })
        .state('app.header.admin-sidebar.home.accounts.new', {
          url: "/new",
          controller: "NewAccountCtrl",
          templateUrl: "/templates/admin/accounts/form.html",
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
        .state('app.header.admin-sidebar.home.accounts.show', {
          url: "/:id",
          controller: 'ShowAccountCtrl',
          templateUrl: "/templates/admin/accounts/show.html",
          resolve: {
            account: ['$stateParams', 'AccountService', function($stateParams, AccountService) {
              return AccountService.get($stateParams.id)
            }]
          }
        })
        .state('app.header.admin-sidebar.home.accounts.edit', {
          url: "/:id/edit",
          controller: "NewAccountCtrl",
          templateUrl: "/templates/admin/accounts/form.html",
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