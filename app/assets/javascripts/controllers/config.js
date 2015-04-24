angular.module('agenda.account-configs', ['agenda.grandfather'])
.controller("AccountConfigHomeCtrl", ['$scope', '$rootScope', 'current_account', 'AccountService',
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