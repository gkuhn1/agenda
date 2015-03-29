app.controller("AccountsCtrl", function($scope, accounts, $controller) {

  $controller("AdminCtrl", {$scope: $scope});

  $scope.page = {title: "Administração", subtitle: "Contas"};

  $scope.accounts = accounts;

});

app.controller("NewAccountCtrl", function($scope, $controller, AccountService) {

  $scope.page.subtitle += " > Nova Conta";

});

app.controller("ShowAccountCtrl", function($scope, account, $controller) {

  $controller("AdminCtrl", {$scope: $scope});

  $scope.account = account;

});

