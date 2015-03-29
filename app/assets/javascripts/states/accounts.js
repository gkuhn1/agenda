app.config(function($stateProvider) {

  $stateProvider
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
            templateUrl: "/templates/admin/accounts/form.html"
          },
          menu: {templateUrl: "/templates/admin/menu.html"}
        },
        resolve: {
          users: function(UserService) {
            return UserService.all();
          },
          newAccount: function(AccountService) {
            return AccountService.new();
          }
        },
        data: {
          edit: false
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
          content: {
            controller: "NewAccountCtrl",
            templateUrl: "/templates/admin/accounts/form.html"
          },
          menu: {templateUrl: "/templates/admin/menu.html"}
        },
        resolve: {
          users: function(UserService) {
            return UserService.all();
          },
          newAccount: function(AccountService, $stateParams) {
            return AccountService.get($stateParams.id);
          }
        },
        data: {
          edit: true
        }
      })
})