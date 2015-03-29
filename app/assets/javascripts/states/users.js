app.config(function($stateProvider) {

  $stateProvider
    .state('users', {
      url: "/users",
      views: {
        content: {
          templateUrl: "/templates/admin/users/index.html",
          controller: "UsersCtrl"
        },
        menu: {templateUrl: "/templates/admin/menu.html"}
      },
      resolve: {
        users: function(UserService){
          return UserService.all();
        }
      }
    })
      .state('users_new', {
        url: "/users/new",
        views: {
          content: {
            controller: "NewUserCtrl",
            templateUrl: "/templates/admin/users/form.html"
          },
          menu: {templateUrl: "/templates/admin/menu.html"}
        },
        resolve: {
          newUser: function(UserService) {
            return UserService.new();
          }
        },
        data: {
          edit: false
        }
      })
      .state('users_show', {
        url: "/users/:id",
        views: {
          content: {
            controller: 'ShowUserCtrl',
            templateUrl: "/templates/admin/users/show.html"
          },
          menu: {templateUrl: "/templates/admin/menu.html"}
        },
        resolve: {
          user: function($stateParams, UserService) {
            return UserService.get($stateParams.id)
          }
        }
      })
      .state('users_edit', {
        url: "/users/:id/edit",
        views: {
          content: {
            controller: "NewUserCtrl",
            templateUrl: "/templates/admin/users/form.html"
          },
          menu: {templateUrl: "/templates/admin/menu.html"}
        },
        resolve: {
          newUser: function(UserService, $stateParams) {
            return UserService.get($stateParams.id);
          }
        },
        data: {
          edit: true
        }
      })

})