angular.module('agenda.accounts', ['agenda.grandfather'])
.controller("AccountsCtrl", ['$scope', '$rootScope', 'accounts', 'AccountService',
  function($scope, $rootScope, accounts, AccountService) {

    $rootScope.page = {title: "Administração", subtitle: "Contas"};
    $scope.accounts = accounts;

    $scope.destroyAccount = function() {
      AccountService.destroy(this.account.id)
      $scope.accounts.splice($scope.accounts.indexOfById(this.account), 1);
    }

  }
])

.controller("NewAccountCtrl", ['$scope', '$state', '$rootScope', 'AccountService', 'newAccount', 'users',
  function($scope, $state, $rootScope, AccountService, newAccount, users) {

    console.log("NewAccountCtrl")

    $rootScope.page = {title: "Administração", subtitle: "Contas"};

    $rootScope.page.subtitle += " > Nova Conta";

    $scope.laddaLoading = false;
    $scope.form_title = "Adicionar Conta";
    $scope.account = newAccount;
    if ($scope.account.user_ids == undefined) {
      $scope.account.user_ids = [];
    }
    $scope.users = users;
    $scope.errors = {};

    $scope.saveAccount = function(account) {
      $scope.laddaLoading = true;
      $scope.errors = {};

      AccountService.save(account, $state.current.data.edit)
        .success(function(data) {
          updateAccount(data);
          $state.go('^');
        })
        .error(function(data) {
          angular.forEach(data.errors, function(errors, field) {
            try {
              $scope.form[field].$setValidity('server', false);
              $scope.errors[field] = errors.join(', ');
            } catch(e) {
              console.log(field);
              console.log(e);
            }
          })
        })
        .finally(function() {
          $scope.laddaLoading = false;
        })
        ;
    }

    var updateAccount = function(data) {
      var idx = $scope.$parent.accounts.indexOfById(data);
      $scope.$parent.accounts[idx] = data;
    }
  }
])

.controller("ShowAccountCtrl", ['$scope', '$rootScope', 'account',
  function($scope, $rootScope, account) {

    $rootScope.page = {title: "Administração", subtitle: "Contas > " + account.name};
    $scope.account = account;

  }
]);

