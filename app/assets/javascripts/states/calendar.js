angular.module('agenda.states-calendars', ['agenda.grandfather'])
.config(['$stateProvider',
  function($stateProvider) {

    $stateProvider
      .state('app.header.calendar-sidebar', {
        abstract: true,
        controller: "CalendarsSidebarCtrl",
        templateUrl: "/templates/calendars/sidebar.html",
        resolve: {
          calendars: ['CalendarService', function(CalendarService){
            return CalendarService.all();
          }]
        }
      })
      .state('app.header.calendar-sidebar.calendars', {
        url: "/calendars",
        templateUrl: "/templates/calendars/index.html",
        controller: "CalendarsCtrl",
        resolve: {
          calendars: ['CalendarService', function(CalendarService){
            return CalendarService.all();
          }]
        }
      })
        .state('app.header.calendar-sidebar.calendars.new', {
          url: "/new",
          controller: "NewCalendarCtrl",
          templateUrl: "/templates/calendars/form.html",
          resolve: {
            users: ['UserAdminService', function(UserAdminService) {
              return UserAdminService.all();
            }],
            newCalendar: ['CalendarService', function(CalendarService) {
              return CalendarService.new();
            }]
          },
          data: {
            edit: false
          }
        })
        .state('app.header.calendar-sidebar.calendars.show', {
          url: "/:id",
          controller: 'ShowCalendarCtrl',
          templateUrl: "/templates/calendars/show.html",
          resolve: {
            account: ['$stateParams', 'CalendarService', function($stateParams, CalendarService) {
              return CalendarService.get($stateParams.id)
            }]
          }
        })
        .state('app.header.calendar-sidebar.calendars.edit', {
          url: "/:id/edit",
          controller: "NewCalendarCtrl",
          templateUrl: "/templates/calendars/form.html",
          resolve: {
            users: ['UserAdminService', function(UserAdminService) {
              return UserAdminService.all();
            }],
            newCalendar: ['CalendarService', '$stateParams', function(CalendarService, $stateParams) {
              return CalendarService.get($stateParams.id);
            }]
          },
          data: {
            edit: true
          }
        })
  }
]);