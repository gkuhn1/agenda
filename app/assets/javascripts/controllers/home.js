angular.module('agenda.home', ['agenda.grandfather'])

.controller("HomeCtrl", ['$rootScope', '$scope',
  function($rootScope, $scope) {

    console.log('HomeCtrl');

    $scope.page = {};
    $scope.page.title = "Home";
  }
])

.controller("HeaderCtrl", ['$rootScope', '$scope', 'Auth',
  function($rootScope, $scope, Auth) {

    console.log('HeaderCtrl');

    $scope.page = {};
    $scope.page.title = "Home";

    $scope.accounts = Auth.current_user().accounts;
    $scope.current_account = Auth.current_account();
    $scope.current_user = Auth.current_user();

    console.log($scope.current_account);

    $scope.changeCurrentAccount = function(account) {
      console.log("change_account()");
      Auth.select_current_account(account);
    }

  }
])

.controller("SidebarCtrl", ['$rootScope',
  function($rootScope) {

    console.log("SidebarCtrl");

  }
])