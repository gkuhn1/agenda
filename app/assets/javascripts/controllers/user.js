angular.module('agenda.users', ['agenda.grandfather'])
.controller("UsersCtrl", ['$scope', '$rootScope', 'users', 'UserService',
  function($scope, $rootScope, users, UserService) {

    $rootScope.page = {title: "Administração", subtitle: "Usuários"};
    $scope.users = users;

    $scope.destroyUser = function() {
      UserService.destroy(this.user.id)
      $scope.users.splice($scope.users.indexOf(this.user), 1);
    }

  }
])

.controller("NewUserCtrl", ['$scope', '$state', '$rootScope', 'Auth', 'UserService', 'newUser',
  function($scope, $state, $rootScope, Auth, UserService, newUser) {

    $rootScope.page = {title: "Administração", subtitle: "Usuários"};

    $rootScope.page.subtitle += " > Novo usuário";

    $scope.form_title = "Adicionar Usuário";
    $scope.user = newUser;
    $scope.user.generate_password = (newUser.generate_password === undefined ? true : newUser.generate_password);
    $scope.errors = {};

    $scope.saveUser = function(user) {
      $scope.errors = {};
      UserService.save(user, $state.current.data.edit)
        .success(function(data) {
          updateUser(data);
          $state.go('^');
        })
        .error(function(data) {
          angular.forEach(data, function(errors, field) {
            $scope.form[field].$setValidity('server', false);
            $scope.errors[field] = errors.join(', ');
          })
        })
        ;
    }

    var updateUser = function(data) {
      var idx = $scope.$parent.users.indexOfById(data);
      $scope.$parent.users[idx] = data;
      console.log(data.id, Auth.current_user().id);
      if (data.id == Auth.current_user().id) {
        Auth.select_current_user(data);
      }
    }

  }
])

.controller("ShowUserCtrl", ['$scope', '$rootScope', 'user',
  function($scope, $rootScope, user) {

    $rootScope.page = {title: "Administração", subtitle: "Usuários > " + user.name};
    $scope.user = user;

  }
]);