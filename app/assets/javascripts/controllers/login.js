angular.module('agenda.login', ['agenda.grandfather'])
.controller("LoginCtrl", ['$rootScope', '$scope', 'Auth', '$state', function($rootScope, $scope, Auth, $state) {

  $rootScope.login = true;

  $scope.error = "";

  $scope.login = function(credentials) {
    console.log(credentials);
    var success = function(data) {
      console.log(data)
      $scope.login_form["email"].$setValidity('server', true);
      $scope.error = "";
      Auth.select_current_user(data);
      if (Auth.current_user().accounts.length == 1) {
        Auth.select_current_account(Auth.current_user().accounts[0]);
      } else {
        $state.go('app.select_account');
      }
    }
    var error = function (data) {
      $scope.login_form["email"].$setValidity('server', false);
      $scope.error = data.error;
      $scope.credential.password = "";
    }
    Auth.login(credentials).success(success).error(error);
  }

  if (Auth.current_user()) {
    $scope.accounts = Auth.current_user().accounts;
  }

  $scope.select_account = function(account) {
    console.log(account);
    Auth.select_current_account(account);
    $state.go('app.home');
  }

}])

