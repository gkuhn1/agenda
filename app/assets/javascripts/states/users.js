angular.module('agenda.states-users', ['agenda.grandfather'])
.config(['$stateProvider',
  function($stateProvider) {

    $stateProvider
      .state('app.header.admin-sidebar.home.users', {
        url: "/users",
        templateUrl: "/templates/admin/users/index.html",
        controller: "UsersCtrl",
        resolve: {
          users: ['UserService', function(UserService){
            return UserService.all();
          }]
        }
      })
        .state('app.header.admin-sidebar.home.users.new', {
          url: "/new",
          controller: "NewUserCtrl",
          templateUrl: "/templates/admin/users/form.html",
          resolve: {
            users: ['UserService', function(UserService) {
              return UserService.all();
            }],
            newUser: ['UserService', function(UserService) {
              return UserService.new();
            }]
          },
          data: {
            edit: false
          }
        })
        .state('app.header.admin-sidebar.home.users.show', {
          url: "/:id",
          controller: 'ShowUserCtrl',
          templateUrl: "/templates/admin/users/show.html",
          resolve: {
            account: ['$stateParams', 'UserService', function($stateParams, UserService) {
              return UserService.get($stateParams.id)
            }]
          }
        })
        .state('app.header.admin-sidebar.home.users.edit', {
          url: "/:id/edit",
          controller: "NewUserCtrl",
          templateUrl: "/templates/admin/users/form.html",
          resolve: {
            users: ['UserService', function(UserService) {
              return UserService.all();
            }],
            newAccount: ['UserService', '$stateParams', function(UserService, $stateParams) {
              return UserService.get($stateParams.id);
            }]
          },
          data: {
            edit: true
          }
        })

  }
]);