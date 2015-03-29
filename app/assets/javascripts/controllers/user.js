app.controller("UsersCtrl", function($scope, $rootScope, users, UserService) {

  $rootScope.page = {title: "Administração", subtitle: "Usuários"};
  $scope.users = users;

  $scope.destroyUser = function() {
    UserService.destroy(this.user.id)
    $scope.users.splice($scope.users.indexOf(this.user), 1);
  }

});

app.controller("NewUserCtrl", function($scope, $state, $rootScope, UserService, newUser) {

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
        $state.go('users');
      })
      .error(function(data) {
        angular.forEach(data, function(errors, field) {
          $scope.form[field].$setValidity('server', false);
          $scope.errors[field] = errors.join(', ');
        })
      })
      ;
  }

});

app.controller("ShowUserCtrl", function($scope, $rootScope, user) {

  $rootScope.page = {title: "Administração", subtitle: "Usuários > " + user.name};
  $scope.user = user;

});