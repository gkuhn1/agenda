angular.module('agenda.admin', ['agenda.grandfather'])

.controller("AdminHomeCtrl", ['$scope', 'dashboard_data',
  function($scope, dashboard_data) {

    console.info("AdminHomeCtrl");

    $scope.panels = dashboard_data.panels;

  }
])

.controller("AdminSidebarCtrl", ['$scope', 'Auth',
  function($scope, Auth) {
    console.info("AdminSidebarCtrl");

    $scope.current_user = Auth.current_user();

  }
])
