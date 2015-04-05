angular.module('agenda.states-admin', ['agenda.grandfather'])
.config(['$stateProvider',
  function($stateProvider) {

    $stateProvider
      .state('home.admin', {
          url: "admin/",
          views: {
            'sidebarmenu@home': {
              templateUrl: "/templates/admin/sidebar_menu.html"
            },
            'content@home': {
              controller: "AdminCtrl",
              templateUrl: "/templates/admin/home.html"
            }
          }
      })

  }
]);