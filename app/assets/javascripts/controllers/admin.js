angular.module('agenda.admin', ['agenda.grandfather'])
.controller("AdminCtrl", ['$scope', function($scope) {

  $scope.page = {};
  $scope.page.title = "Administração";

}])

