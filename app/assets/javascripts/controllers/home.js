app.controller("HomeCtrl", ['$rootScope', '$scope', 'current_account', 'current_user',
  function($rootScope, $scope, current_account, current_user) {

    console.log('HomeCtrl');

    $scope.page = {};
    $scope.page.title = "Home";

    $rootScope.current_user = current_user;
    $rootScope.current_account = current_account;
  }
])

app.controller("HeaderCtrl", ['$rootScope', '$scope',
  function($rootScope, $scope) {

    console.log('HeaderCtrl');

    $scope.page = {};
    $scope.page.title = "Home";

  }
])