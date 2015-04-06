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
        templateUrl: "/templates/admin/home.html"
      })
      // .state('app.sysadmin.home', {
      //   url: "/admin",
        // views: {
        //   'wrapper@': {
        //     templateUrl: "/templates/application.html"
        //   },
        //   'header@': {
        //     controller: 'HeaderCtrl',
        //     templateUrl: "/templates/header.html"
        //   },
        //   'content@app.sysadmin.home': {
        //     controller: 'AdminHomeCtrl',
        //     templateUrl: "/templates/admin/home.html"
        //   },
        //   'sidebar@app.sysadmin.home': {
        //     controller: 'AdminSidebarCtrl',
        //     templateUrl: "/templates/admin/sidebar_menu.html"
        //   }
        // }
      // })

  }
]);