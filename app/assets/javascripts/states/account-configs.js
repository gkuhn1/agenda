angular.module('agenda.states-account-configs', ['agenda.grandfather'])
.config(['$stateProvider',
  function($stateProvider) {

    $stateProvider
      .state('app.header.config-sidebar', {
        abstract: true,
        templateUrl: "/templates/config/sidebar.html"
      })
        .state('app.header.config-sidebar.home', {
          url: "/account",
          controller: 'AccountConfigHomeCtrl',
          templateUrl: "/templates/config/home.html",
          resolve: {
            current_account: ['Auth', function(Auth) {
              return Auth.current_account();
            }]
          }
        })
          .state('app.header.config-sidebar.home.edit', {
            url: "/edit",
            controller: 'EditAccountConfigHomeCtrl',
            templateUrl: "/templates/config/edit.html",
            resolve: {
              current_account: ['Auth', function(Auth) {
                return Auth.current_account();
              }]
            }
          })


          .state('app.header.config-sidebar.home.users', {
            url: "/users",
            controller: 'AccountUsersCtrl',
            templateUrl: "/templates/config/users/index.html",
            resolve: {
              users: ['UserService', function(UserService) {
                return UserService.all();
              }]
            }
          })
            .state('app.header.config-sidebar.home.users.edit', {
              url: "/:id/edit",
              controller: 'AccountUsersEditCtrl',
              templateUrl: "/templates/config/users/form.html",
              resolve: {
                user: ['$stateParams', 'UserService', function($stateParams, UserService) {
                  return UserService.get($stateParams.id);
                }]
              },
              data: {
                edit: true
              }
            })
            .state('app.header.config-sidebar.home.users.new', {
              url: "/new",
              controller: 'AccountUsersEditCtrl',
              templateUrl: "/templates/config/users/new_form.html",
              resolve: {
                user: function() {return {}; }
              },
              data: {
                edit: false
              }
            })


          .state('app.header.config-sidebar.home.specialties', {
            url: "/specialties",
            controller: 'AccountSpecialitiesCtrl',
            templateUrl: "/templates/config/specialties/index.html",
            resolve: {
              specialties: ['SpecialtyService', function(SpecialtyService) {
                return SpecialtyService.all();
              }]
            }
          })
            .state('app.header.config-sidebar.home.specialties.edit', {
              url: "/:id/edit",
              controller: 'AccountSpecialitiesEditCtrl',
              templateUrl: "/templates/config/specialties/form.html",
              resolve: {
                specialty: ['$stateParams', 'SpecialtyService', function($stateParams, SpecialtyService) {
                  return SpecialtyService.get($stateParams.id);
                }]
              },
              data: {
                edit: true
              }
            })
            .state('app.header.config-sidebar.home.specialties.new', {
              url: "/new",
              controller: 'AccountSpecialitiesEditCtrl',
              templateUrl: "/templates/config/specialties/new_form.html",
              resolve: {
                specialty: function() {return {active: true}; }
              },
              data: {
                edit: false
              }
            })


  }
]);