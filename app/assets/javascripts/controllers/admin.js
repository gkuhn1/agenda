angular.module('agenda.admin', ['agenda.grandfather'])

.controller("AdminHomeCtrl", ['$scope',
  function($scope) {

    console.info("AdminHomeCtrl");

  }
])

.controller("AdminSidebarCtrl", ['$scope', 'Auth',
  function($scope, Auth) {
    console.info("AdminSidebarCtrl");

    $scope.current_user = Auth.current_user();

  }
])
