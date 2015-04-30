angular.module('agenda.home', ['agenda.grandfather'])

.controller("HomeCtrl", ['$rootScope', '$scope',
  function($rootScope, $scope) {

    console.log('HomeCtrl');

    $scope.page = {};
    $scope.page.title = "Home";
  }
])

.controller("HeaderCtrl", ['$rootScope', '$scope', '$timeout', 'Auth', 'NotificationService', 'notifications',
  function($rootScope, $scope, $timeout, Auth, NotificationService, notifications) {

    console.log('HeaderCtrl');

    $scope.page = {};
    $scope.page.title = "Home";

    console.log(notifications);

    $scope.ntf = notifications;
    $scope.notifications = notifications.notifications;

    $scope.accounts = Auth.current_user().accounts;

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