angular.module('agenda.calendars', ['agenda.grandfather','ui.calendar'])
.controller("CalendarsSidebarCtrl", ['$scope', '$rootScope', 'calendars',
  function($scope, $rootScope, calendars) {

    console.log("CalendarsSidebarCtrl");

    $scope.tv_professionals = true // Set to start menu opened
    $scope.startDate;
    $scope.endDate;
    $scope.currentDate;
    $scope.calendars = calendars;
    $scope.active_calendars_count = calendars.length;

    var selectCurrentWeek = function(target) {
      setTimeout(function() {
        $(target).find('td.active').parent().addClass('active')
      }, 1);
    }

    $scope.datepickerOptions = {
      format: 'dd/mm/yyyy',
      language: 'pt-BR',
      init: function(element, settings) {
        element.on('changeDate', function(event, settings) {
          $scope.currentDate = event.date;
          $scope.startDate = new Date($scope.currentDate.getFullYear(), $scope.currentDate.getMonth(), $scope.currentDate.getDate() - $scope.currentDate.getDay());
          $scope.endDate = new Date($scope.currentDate.getFullYear(), $scope.currentDate.getMonth(), $scope.currentDate.getDate() - $scope.currentDate.getDay() + 6);
          // console.log($.fn.datepicker.DPGlobal.formatDate( startDate, settings.format, settings.language )
          //   + ' - ' + $.fn.datepicker.DPGlobal.formatDate( endDate, settings.format, settings.language));
          selectCurrentWeek(event.target);
          $rootScope.$emit('calendar-week-changed', $scope.startDate, $scope.endDate, $scope.currentDate);

        }).on('changeMonth', function(event) {
          selectCurrentWeek(event.target);
        });
      }
    }

  }
])

.controller("CalendarsCtrl", ['$scope', '$rootScope', 'calendars', 'CalendarService', 'TaskService',
  function($scope, $rootScope, calendars, CalendarService, TaskService) {

    $rootScope.page = {title: "Administração", subtitle: "Contas"};
    $scope.calendars = calendars;
    $scope.eventSources = [];
    $scope.$fullcalendar = '#fullcalendar';
    $scope.errors = {};
    $scope.laddaModalLoading = false;

    $scope.newTask = {};

    $scope.newTaskReset = function() {
      $scope.newTask = {};
      if (calendars.length < 2)
        $scope.newTask.calendar_id = calendars[0].id
    }
    $scope.newTaskReset();

    $scope.resetFormErrors = function() {
      $scope.form.calendar.$setValidity('server', true);
      $scope.form.title.$setValidity('server', true);
      $scope.form.end_at.$setValidity('server', true);
      $scope.form.start_at.$setValidity('server', true);
      $scope.errors = {};
      $scope.laddaLoading = false;
    }

    $scope.createTask = function(newTask) {
      $scope.resetFormErrors();

      if (newTask.calendar_id === undefined) {
        $scope.form.calendar.$setValidity('server', false);
        $scope.errors.calendar = "Deve selecionar um Profissional!";
        return;
      }
      console.log(newTask.startdate + newTask.starttime);
      console.log(newTask.enddate + newTask.endtime);
      var success = function(data) {
        console.log(data);
        var events = $scope.eventSources.findById(newTask.calendar_id).events;
        events.push(TaskService.toFullCalendar(data));
        $scope.newTaskReset();
        $('#createTaskModal').modal('hide');
      };
      var error = function(data) {
        console.log(data.errors);
        angular.forEach(data.errors, function(errors, field) {
          console.log(errors, field);
          $scope.form[field].$setValidity('server', false);
          $scope.errors[field] = errors.join(', ');
        })
      }
      promise = TaskService.save(newTask.calendar_id, TaskService.modalToTask(newTask));
      promise.success(success).error(error).finally(function() {
        $scope.laddaLoading = false;
      })
    }

    $scope.reloadTasks = function() {
      $scope.$emit("loading_start");
      $scope.eventSources = [];
      angular.forEach($scope.calendars, function(calendar) {
        var source = {events: [], color: calendar.color || "#909090", id: calendar.id};
        TaskService.all(calendar.id).success(function(data) {
          angular.forEach(data, function(task) {
            source.events.push(TaskService.toFullCalendar(task));
          })
        }).finally(function() {
          $scope.$emit("loading_stop");
        });
        $scope.eventSources.push(source);
      })
    }
    $scope.reloadTasks();

    $scope.onSelectCalendar = function(start, end, allDay) {
      console.log(start, end, allDay);
      $scope.newTask.enddate = end.format('DD/MM/YYYY');
      $scope.newTask.endtime = end.format('HH:mm');
      $scope.newTask.startdate = start.format('DD/MM/YYYY');
      $scope.newTask.starttime = start.format('HH:mm');
      $('#createTaskModal').modal('show');
      $('#createTaskModal').find('input:first').focus();
    }
    $scope.alertEventOnClick = function() {
      console.log(arguments);
    }
    $scope.alertOnResize = function() {
      console.log(arguments);
    }

    $scope.calendarOptions = {
      lang: 'pt-br',
      useNgLocale: false,
      allDaySlot: false,
      editable: true,
      defaultView: 'agendaWeek',
      defaultDate: new Date(),
      slotDuration: "00:15:00",
      scrollTime: new Date().getTimeStr(),
      axisFormat: 'HH:mm',
      editable: true,
      selectable: true,
      selectHelper: true,
      header:{
        left: 'month agendaWeek agendaDay',
        center: 'title',
        right: 'today prev,next'
      },
      views: {
        agendaWeek: {
          titleRangeSeparator: ' à '
        }
      },
      select: $scope.onSelectCalendar,
      dayClick: $scope.alertEventOnClick,
      eventDrop: $scope.alertOnDrop,
      eventResize: $scope.alertOnResize
    }

    $rootScope.$on('calendar-week-changed', function(event, startDate, endDate, currentDate) {
      $scope.$apply(function() {
        $scope.startDate = startDate;
        $scope.endDate = endDate;
        $scope.currentDate = currentDate;
        $($scope.$fullcalendar).fullCalendar('gotoDate', currentDate);
      })
    })

  }
])

.controller("NewCalendarCtrl", ['$scope', '$state', '$rootScope', 'CalendarService', 'newCalendar', 'users',
  function($scope, $state, $rootScope, CalendarService, newCalendar, users) {

    console.log("NewCalendarCtrl")

    $rootScope.page = {title: "Administração", subtitle: "Contas"};

    $rootScope.page.subtitle += " > Nova Conta";

    $scope.laddaLoading = false;
    $scope.form_title = "Adicionar Conta";
    $scope.account = newCalendar;
    $scope.users = users;
    $scope.errors = {};

    console.log();

    $scope.saveCalendar = function(account) {
      $scope.laddaLoading = true;
      $scope.errors = {};
      CalendarService.save(account, $state.current.data.edit)
        .success(function(data) {
          updateCalendar(data);
          $state.go('^');
        })
        .error(function(data) {
          angular.forEach(data, function(errors, field) {
            $scope.form[field].$setValidity('server', false);
            $scope.errors[field] = errors.join(', ');
          })
        })
        .finally(function() {
          $scope.laddaLoading = false;
        })
        ;
    }

    var updateCalendar = function(data) {
      var idx = $scope.$parent.calendars.indexOfById(data);
      $scope.$parent.calendars[idx] = data;
    }
  }
])

.controller("ShowCalendarCtrl", ['$scope', '$rootScope', 'account',
  function($scope, $rootScope, account) {

    $rootScope.page = {title: "Administração", subtitle: "Contas > " + account.name};
    $scope.account = account;

  }
]);

