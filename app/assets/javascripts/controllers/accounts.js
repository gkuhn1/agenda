app.controller("AccountsCtrl", function($scope, $rootScope, accounts, AccountService) {

  $rootScope.page = {title: "Administração", subtitle: "Contas"};
  $scope.accounts = accounts;

  $scope.destroyAccount = function() {
    AccountService.destroy(this.account.id)
    $scope.accounts.splice($scope.accounts.indexOf(this.account), 1);
  }

});

app.controller("NewAccountCtrl", function($scope, $state, $rootScope, AccountService, newAccount, users) {

  $rootScope.page = {title: "Administração", subtitle: "Contas"};

  $rootScope.page.subtitle += " > Nova Conta";

  $scope.form_title = "Adicionar Conta";
  $scope.account = newAccount;
  $scope.users = users;
  $scope.errors = {};

  $scope.saveAccount = function(account) {
    $scope.errors = {};
    AccountService.save(account, $state.current.data.edit)
      .success(function(data) {
        $state.go('accounts');
      })
      .error(function(data) {
        console.log('error');
        angular.forEach(data, function(errors, field) {
          $scope.form[field].$setValidity('server', false);
          $scope.errors[field] = errors.join(', ');
        })
      })
      ;
  }

});

app.controller("ShowAccountCtrl", function($scope, $rootScope, account) {

  $rootScope.page = {title: "Administração", subtitle: "Contas > " + account.name};
  $scope.account = account;

});

