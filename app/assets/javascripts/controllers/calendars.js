angular.module('agenda.calendars', ['agenda.grandfather','ui.calendar'])
.controller("CalendarsSidebarCtrl", ['$scope', '$rootScope', 'calendars', 'specialties',
  function($scope, $rootScope, calendars, specialties) {

    console.log("CalendarsSidebarCtrl");

    $scope.tv_professionals = true // Set to start menu opened
    $scope.startDate;
    $scope.endDate;
    $scope.currentDate;
    $scope.calendars = calendars;
    $scope.active_calendars_count = calendars.length;
    $scope.specialties = specialties;
    $scope.active_specialties_count = specialties.length;

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

.controller("CalendarsCtrl", ['$scope', '$rootScope', '$timeout', 'Pusher', 'CalendarService', 'TaskService', 'calendars',
  function($scope, $rootScope, $timeout, Pusher, CalendarService, TaskService, calendars) {

    $rootScope.page = {title: "Administração", subtitle: "Contas"};
    $scope.calendars = calendars;
    $scope.eventSources = [];
    $scope.$fullcalendar = '#fullcalendar';
    $scope.errors = {};
    $scope.laddaModalLoading = false;
    $scope.laddaModalDeleteLoading = false;

    $scope.newTask = {};

    $scope.closeModal = function() {
      $scope.newTaskReset();
      $('#createTaskModal').modal('hide');
    }

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

      var success = function(data) {
        console.log(data);
        $scope.addOrUpdateTask(data);
        $scope.closeModal();
      };
      var error = function(data) {
        console.log(data.errors);
        angular.forEach(data.errors, function(errors, field) {
          $scope.form[field].$setValidity('server', false);
          $scope.errors[field] = errors.join(', ');
        })
      }
      promise = TaskService.save(TaskService.modalToTask(newTask), newTask.updating);
      promise.success(success).error(error).finally(function() {
        $scope.laddaLoading = false;
      })
    }

    $scope.addOrUpdateTask = function(data) {
      var events = $scope.eventSources[0].events;
      var idx = events.indexOfById(data.id);
      var calendar_task_data = TaskService.toFullCalendar(data);
      if ( idx == -1 ) {
        events.push(calendar_task_data);
      } else {
        console.log('updating ', angular.equals(events[idx], calendar_task_data));
        console.log(events[idx], calendar_task_data);
        if ( !angular.equals(events[idx], calendar_task_data) ) {
          events[idx] = calendar_task_data;
        }
      }
    }

    $scope.destroyTask = function(task) {
      console.log(task);
      TaskService.destroy(task.id)
        .success(function(data) {
          var events = $scope.eventSources[0].events;
          events.splice(events.indexOfById(task), 1);
          $scope.closeModal();
        })
    }

    $scope.reloadTasks = function(element, view) {
      $scope.$emit("loading_start");

      if (element === undefined) {
        element = $('#fullcalendar').fullCalendar('getView');
      }

      TaskService.promise_all(element.start, element.end)
        .success(function(data) {
          $scope.eventSources.splice(0,$scope.eventSources.length)
          $scope.tasks = data;
          var source = {events: []};
          angular.forEach($scope.tasks, function(task) {
            source.events.push(TaskService.toFullCalendar(task));
          })
          console.log(source);
          $scope.eventSources.push(source);
        })

      $scope.$emit("loading_stop", {timeout: false});
    }

    $scope.onSelectCalendar = function(start, end, allDay) {
      $scope.newTask.enddate = end.format('DD/MM/YYYY');
      $scope.newTask.endtime = end.format('HH:mm');
      $scope.newTask.startdate = start.format('DD/MM/YYYY');
      $scope.newTask.starttime = start.format('HH:mm');
      $('#createTaskModal').modal('show');
      $('#createTaskModal').find('input:first').focus();
    }

    $scope.eventClick = function(cal_task, event, calendar) {
      TaskService.get(cal_task.id)
        .success(function(data) {
          $scope.newTask = TaskService.taskToModal(data);
          $scope.newTask.updating = true;
          console.log($scope.newTask);
          $('#createTaskModal').modal('show');
          $('#createTaskModal').find('input:first').focus();
        });
    }

    $scope.dropOrResize = function(event, delta, revertFunc) {
      event.updating = true
      console.log(event, delta);
      TaskService.save(TaskService.eventToTask(event), true);
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
      height: 600,
      editable: true,
      selectable: true,
      selectHelper: true,
      minTime: '08:00:00',
      maxTime: '20:00:00',
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
      beforeViewRender: $scope.reloadTasks,
      select: $scope.onSelectCalendar,
      eventClick: $scope.eventClick,
      dayClick: $scope.alertEventOnClick,
      eventDrop: $scope.dropOrResize,
      eventResize: $scope.dropOrResize
    }

    $timeout(function() {
      $('#fullcalendar').fullCalendar('option','height', ($(window).height() - $('.main-header').height()));
    });

    $(window).resize(function() {
      $(".sidebar").slimScroll({destroy: true}).height("auto");
      $timeout(function() {
        addSlimScroll();
      });
    })

    var addSlimScroll = function() {
      $(".sidebar").slimscroll({
        height: 'auto',
        color: "#FFF",
        opacity: .7,
        alwaysVisible: true,
        railVisible: true,
        railColor: '#FFF',
        railOpacity: .3,
        size: "4px"
      });
    }
    addSlimScroll();

    Pusher.subscribe($rootScope.current_user.id + '_tasks', 'added', function (item) {
      console.info('coming from pusher');
      $scope.addOrUpdateTask(item);
    });
    Pusher.subscribe($rootScope.current_user.id + '_tasks', 'changed', function (item) {
      console.info('coming from pusher');
      $scope.addOrUpdateTask(item);
    });

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

