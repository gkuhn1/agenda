angular.module('agenda.states-users', ['agenda.grandfather'])
.config(['$stateProvider',
  function($stateProvider) {

    $stateProvider
      .state('app.header.admin-sidebar.home.users', {
        url: "/users",
        templateUrl: "/templates/admin/users/index.html",
        controller: "UsersCtrl",
        resolve: {
          users: ['UserAdminService', function(UserAdminService){
            return UserAdminService.all();
          }]
        }
      })
        .state('app.header.admin-sidebar.home.users.new', {
          url: "/new",
          controller: "NewUserCtrl",
          templateUrl: "/templates/admin/users/form.html",
          resolve: {
            users: ['UserAdminService', function(UserAdminService) {
              return UserAdminService.all();
            }],
            newUser: ['UserAdminService', function(UserAdminService) {
              return UserAdminService.new();
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
            user: ['UserAdminService', '$stateParams', function(UserAdminService, $stateParams) {
              return UserAdminService.get($stateParams.id);
            }]
          }
        })
        .state('app.header.admin-sidebar.home.users.edit', {
          url: "/:id/edit",
          controller: "NewUserCtrl",
          templateUrl: "/templates/admin/users/form.html",
          resolve: {
            users: ['UserAdminService', function(UserAdminService) {
              return UserAdminService.all();
            }],
            newUser: ['UserAdminService', '$stateParams', function(UserAdminService, $stateParams) {
              return UserAdminService.get($stateParams.id);
            }]
          },
          data: {
            edit: true
          }
        })

  }
]);