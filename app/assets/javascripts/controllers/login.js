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
      Auth.handle_login($state, data);
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

.controller("RegisterCtrl", ['$rootScope', '$scope', '$state', 'Auth', 'AccountService', 'UserService',
  function($rootScope, $scope, $state, Auth, AccountService, UserService) {

    $rootScope.login = true;

    $scope.errors = {};
    $scope.account = {};

    $scope.register = function(account) {
      console.log('register', account, $scope.form_error);
      $scope.errors = {};

      if (!account.name || !account.user_attributes.email || !account.user_attributes.password || !account.user_attributes.password_confirmation)
        $scope.form_error = "Todos os campos devem ser preenchidos";
      else {
        $scope.form_error = null;

        var success = function(data) {
          Auth.login({email: account.user_attributes.email, password: account.user_attributes.password}).success(function(data){
            Auth.handle_login($state, data);
          })
        }

        var error = function(data) {
          console.log(data.errors)
          angular.forEach(data.errors, function(errors, field) {
            console.log(field);
            $scope.form[field].$setValidity('server', false);
            $scope.errors[field] = errors.join(', ');
          })
        }

        AccountService.save(account, false).success(success).error(error);
      }
    }

  }
])

