angular.module('agenda.states-accounts', ['agenda.grandfather'])
.config(['$stateProvider',
  function($stateProvider) {

    $stateProvider
      .state('app.header.admin-sidebar.home.accounts', {
        url: "/accounts",
        templateUrl: "/templates/admin/accounts/index.html",
        controller: "AccountsCtrl",
        resolve: {
          accounts: ['AccountAdminService', function(AccountAdminService){
            return AccountAdminService.all();
          }]
        }
      })
        .state('app.header.admin-sidebar.home.accounts.new', {
          url: "/new",
          controller: "NewAccountCtrl",
          templateUrl: "/templates/admin/accounts/form.html",
          resolve: {
            users: ['UserAdminService', function(UserAdminService) {
              return UserAdminService.all();
            }],
            newAccount: ['AccountAdminService', function(AccountAdminService) {
              return AccountAdminService.new();
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
            account: ['$stateParams', 'AccountAdminService', function($stateParams, AccountAdminService) {
              return AccountAdminService.get($stateParams.id)
            }]
          }
        })
        .state('app.header.admin-sidebar.home.accounts.edit', {
          url: "/:id/edit",
          controller: "NewAccountCtrl",
          templateUrl: "/templates/admin/accounts/form.html",
          resolve: {
            users: ['UserAdminService', function(UserAdminService) {
              return UserAdminService.all();
            }],
            newAccount: ['AccountAdminService', '$stateParams', function(AccountAdminService, $stateParams) {
              return AccountAdminService.get($stateParams.id);
            }]
          },
          data: {
            edit: true
          }
        })
  }
]);