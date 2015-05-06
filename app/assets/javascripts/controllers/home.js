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

    $scope.getBase64Data = function() {
      $scope.search.specialty = $scope.specialties.findById($scope.search.specialty_id);
      return objToBase64($scope.search);
    }

    $scope.datepickerOptions = {
      format: 'dd/mm/yyyy',
      language: 'pt-BR',
      startDate: moment().format('DD/MM/YYYY'),
      defaultDate: moment().format('DD/MM/YYYY')
    }

  }
])

.controller("SearchAddTaskCtrl", ['$rootScope', '$scope', '$state', '$location', 'SearchService', 'TaskService', 'params',
  function($rootScope, $scope, $state, $location, SearchService, TaskService, params) {

    $scope.initTask = function() {
      $scope.newTask = {
        title: params.specialty.description,
        specialty_id: params.specialty_id,
        account_id: $state.params.account_id,
        startdate: params.date,
        starttime: params.start_at,
        enddate: params.date,
        endtime: params.end_at
      };
      $scope.errors = {};
    }

    $scope.createTask = function(newTask) {
      var success = function(data) {
        $('#createTaskModal').off('hide.bs.modal');
        $state.go("app.header.calendar-sidebar.calendars", {showDay: moment(data.start_at).format('DD/MM/YYYY')});
      };
      var error = function(data) {
        console.log(data.errors);
        angular.forEach(data.errors, function(errors, field) {
          $scope.form[field].$setValidity('server', false);
          $scope.errors[field] = errors.join(', ');
        })
      }
      promise = SearchService.createTask(TaskService.modalToTask(newTask));
      promise.success(success).error(error).finally(function() {
        $scope.laddaLoading = false;
      })
      ;
    }

    $scope.initTask();
    $('#createTaskModal').modal('show');
    $('#createTaskModal').one('hide.bs.modal', function (e) {
      $state.go("^");
    })

  }
])
