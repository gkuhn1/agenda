angular.module('agenda.account-configs', ['agenda.grandfather'])
.controller("AccountConfigHomeCtrl", ['$scope', '$rootScope',
    'current_account', 'AccountService',
  function($scope, $rootScope, current_account, AccountService) {
  }
])

.controller("EditAccountConfigHomeCtrl", ['$scope', '$rootScope',
    '$state', 'current_account', 'AccountService', 'Auth',
  function($scope, $rootScope, $state, current_account, AccountService, Auth) {

    $scope.form_title = "Editar informações da conta atual";
    $scope.account = {}
    angular.copy(current_account, $scope.account);
    $scope.errors = {};

    $scope.saveAccount = function(account) {
      $scope.laddaLoading = true;
      $scope.errors = {};
      AccountService.save(account, true)
        .success(function(data) {
          angular.copy(account, current_account);
          Auth.select_current_account(account);
          $state.go('^');
        })
        .error(function(data) {
          angular.forEach(data.errors, function(errors, field) {
            $scope.form[field].$setValidity('server', false);
            $scope.errors[field] = errors.join(', ');
          })
        })
        .finally(function() {
          $scope.laddaLoading = false;
        })
        ;
    }

  }
])


.controller("AccountUsersCtrl", ['$scope', '$rootScope',
    '$state', 'users', 'AccountService', 'Auth',
  function($scope, $rootScope, $state, users, AccountService, Auth) {
    $scope.users = users;
  }
])

.controller("AccountUsersEditCtrl", ['$scope', '$rootScope',
    '$state', 'user', 'UserService',
  function($scope, $rootScope, $state, user, UserService) {
    $scope.user = user;
    $scope.errors = {};

    $('#task_colorpicker').colorpicker({
      color: user.task_color,
      format: 'hex',
      afterUpdate: function(elem, val) {
        $scope.user.task_color = val;
      }
    });

    $scope.saveUser = function(user) {
      $scope.laddaLoading = true;
      $scope.errors = {};

      if ($state.current.data.edit == false)
        user.generate_password = true;

      UserService.save(user, $state.current.data.edit)
        .success(function(data) {
          updateUser(data);
          $state.go('^');
        })
        .error(function(data) {
          angular.forEach(data.errors, function(errors, field) {
            $scope.form[field].$setValidity('server', false);
            $scope.errors[field] = errors.join(', ');
          })
        })
        .finally(function() {
          $scope.laddaLoading = false;
        })
        ;
    }

    var updateUser = function(data) {
      if ($state.current.data.edit) {
        var idx = $scope.$parent.users.indexOfById(data);
        $scope.$parent.users[idx] = data;
      } else {
        $scope.$parent.users.push(data);
      }
    }

  }
])

