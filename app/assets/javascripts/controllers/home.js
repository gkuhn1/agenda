angular.module('agenda.home', ['agenda.grandfather'])

.controller("HomeCtrl", ['$rootScope', '$scope',
  function($rootScope, $scope) {

    console.log('HomeCtrl');

    $scope.page = {};
    $scope.page.title = "Home";
  }
])

.controller("HeaderCtrl", ['$rootScope', '$scope', '$timeout', 'Auth', 'Pusher', 'NotificationService', 'notifications',
  function($rootScope, $scope, $timeout, Auth, Pusher, NotificationService, notifications) {

    console.log('HeaderCtrl');

    $scope.page = {};
    $scope.page.title = "Home";

    console.log(notifications);

    $scope.ntf = notifications;
    $scope.notifications = notifications.notifications;

    $scope.current_user = Auth.current_user();
    $scope.accounts = $scope.current_user.accounts;

    Pusher.subscribe($scope.current_user.id + '_notifications', 'added', function (item) {
      // Notification was added.
      $scope.notifications.unshift(item);
      $scope.ntf.unread_count++;
    });

    // função para ajustar a contentwrapper para a altura correta da tela do usuário
    $timeout(function() {
      contentWrapperHeight();
    })

    $scope.toggleRead = function(notification) {
      var promise;
      if (notification.read) {
        promise = NotificationService.mark_as_unread(notification);
        $scope.ntf.unread_count++;
        $scope.ntf.read_count--;
      } else {
        promise = NotificationService.mark_as_read(notification);
        $scope.ntf.unread_count--;
        $scope.ntf.read_count++;
      }
      promise.success(function(data) {
        var idx = $scope.notifications.indexOfById(data);
        $scope.notifications[idx] = data;
      });
    }

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

.controller("SearchCtrl", ['$rootScope', '$scope',
  function($rootScope, $scope) {

    console.info('SEARCH CTRL');

    $scope.professionals = {};
    $scope.search = {};
    $scope.places = [
      {name: "Local 1", id: "1"},
      {name: "Local 2", id: "2"},
      {name: "Local 3", id: "3"},
      {name: "Local 4", id: "4"},
      {name: "Local 5", id: "5"},
      {name: "Local 6", id: "6"},
      {name: "Local 7", id: "7"},
      {name: "Local 8", id: "8"}
    ];
    $scope.specialties = [
      {name: "Especialidade 1", id: "1"},
      {name: "Especialidade 2", id: "2"},
      {name: "Especialidade 3", id: "3"},
      {name: "Especialidade 4", id: "4"},
      {name: "Especialidade 5", id: "5"},
      {name: "Especialidade 6", id: "6"},
      {name: "Especialidade 7", id: "7"},
      {name: "Especialidade 8", id: "8"}
    ];

    $scope.doSearch = function() {
      console.log($scope.search);
      $scope.professionals = [
        {name: "Professional 1", id: 1},
        {name: "Professional 2", id: 2},
        {name: "Professional 3", id: 3},
        {name: "Professional 5", id: 5},
        {name: "Professional 4", id: 4},
        {name: "Professional 6", id: 6},
        {name: "Professional 7", id: 7},
        {name: "Professional 8", id: 8},
        {name: "Professional 9", id: 9}
      ]
    }

    $scope.datepickerOptions = {
      format: 'dd/mm/yyyy',
      language: 'pt-BR'
    }

  }
])