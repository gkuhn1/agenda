app.config(['$stateProvider',
  function($stateProvider) {

    $stateProvider
      .state('login', {
          url: "/login/",
          views: {
            wrapper: {
              controller: 'LoginCtrl',
              templateUrl: "/templates/login/application.html"
            },
            header: {template: ""}
          }
      })

  }
]);