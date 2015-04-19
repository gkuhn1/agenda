angular.module('agenda.calendars', ['agenda.grandfather'])
.controller("CalendarsSidebarCtrl", ['$scope', '$rootScope',
  function($scope, $rootScope) {

    console.log("CalendarsSidebarCtrl");

    $scope.startDate;
    $scope.endDate;
    $scope.currentDate;

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

.controller("CalendarsCtrl", ['$scope', '$rootScope', 'calendars', 'CalendarService',
  function($scope, $rootScope, calendars, CalendarService) {

    $rootScope.page = {title: "Administração", subtitle: "Contas"};
    $scope.calendars = calendars;

    $rootScope.$on('calendar-week-changed', function(event, startDate, endDate, currentDate) {
      $scope.$apply(function() {
        $scope.startDate = startDate;
        $scope.endDate = endDate;
        $scope.currentDate = currentDate;
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

