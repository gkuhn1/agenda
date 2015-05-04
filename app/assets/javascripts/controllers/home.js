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

.controller("SearchCtrl", ['$rootScope', '$scope', 'SearchService', 'places', 'specialties',
  function($rootScope, $scope, SearchService, places, specialties) {

    console.info('SEARCH CTRL');
    $scope.professionals = {};
    $scope.search = {};
    $scope.errors = {};
    $scope.places = places;
    $scope.specialties = specialties;
    $scope.sercheabled = false;

    $scope.doSearch = function() {
      $scope.errors = {};
      if ($scope.search.date == "") {
        $scope.search.date = moment(new Date()).format('DD/MM/YYYY')
      }
      console.log($scope.search);
      var promise = SearchService.search($scope.search);
      promise.success(function(data) {
        $scope.professionals = data;
      }).error(function(data) {
        angular.forEach(data.errors, function(errors, field) {
          try {
            $scope.form[field].$setValidity('server', false);
            $scope.errors[field] = errors.join(', ');
          } catch(e) {
            console.log(field);
            console.log(e);
          }
        })
      });
      $scope.sercheabled = true;
    }

    $scope.datepickerOptions = {
      format: 'dd/mm/yyyy',
      language: 'pt-BR',
      startDate: moment().format('DD/MM/YYYY'),
      defaultDate: moment().format('DD/MM/YYYY')
    }

  }
])