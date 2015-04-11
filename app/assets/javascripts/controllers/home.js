angular.module('agenda.home', ['agenda.grandfather'])

.controller("HomeCtrl", ['$rootScope', '$scope',
  function($rootScope, $scope) {

    console.log('HomeCtrl');

    $scope.page = {};
    $scope.page.title = "Home";
  }
])

.controller("HeaderCtrl", ['$rootScope', '$scope', '$timeout', 'Auth',
  function($rootScope, $scope, $timeout, Auth) {

    console.log('HeaderCtrl');

    $scope.page = {};
    $scope.page.title = "Home";

    $scope.accounts = Auth.current_user().accounts;
    // $scope.current_account = Auth.current_account();
    // $scope.current_user = Auth.current_user();

    // console.log($scope.current_account);

    // função para ajustar a contentwrapper para a altura correta da tela do usuário
    $timeout(function() {
      contentWrapperHeight();
    })

    $scope.changeCurrentAccount = function(account) {
      console.log("change_account()");
      Auth.select_current_account(account);
    }

    $scope.toggleSidebar = function() {
      $rootScope.sidebarOpen = !$rootScope.sidebarOpen;
    }

  }
])

.controller("SidebarCtrl", ['$rootScope', '$scope', 'Auth',
  function($rootScope, $scope, Auth) {

    $scope.current_user = Auth.current_user();

    console.log("SidebarCtrl");

  }
])