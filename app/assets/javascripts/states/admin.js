angular.module('agenda.states-admin', ['agenda.grandfather'])
.config(['$stateProvider',
  function($stateProvider) {

    $stateProvider
      .state('app.header.admin-sidebar', {
        abstract: true,
        templateUrl: "/templates/admin/sidebar.html"
      })
      .state('app.header.admin-sidebar.home', {
        url: "/admin",
        controller: 'AdminHomeCtrl',
        templateUrl: "/templates/admin/home.html",
        resolve: {
          dashboard_data: ['AdminService', function(AdminService) {
            return AdminService.get_dashboard_data();
          }]
        }
      })

  }
]);