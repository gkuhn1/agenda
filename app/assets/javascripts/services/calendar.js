angular.module('agenda.calendarservice', ['httpq']).factory('CalendarService', ['$httpq', '$http',
  function ($httpq, $http) {

    var base_url = '/api/v1/calendars';

    var pub = {};

    // load
    pub.all = function() {
      return $httpq.get(base_url+'.json', {cache: true, params: {tasks: 'true'}});
    }

    pub.get = function(id) {
      return $httpq.get(base_url+'/'+id+'.json');
    }

    pub.save = function(calendar, edit) {
      if (edit) {
        return pub.update(calendar);
      } else {
        return pub.create(calendar);
      }
    }

    pub.update = function(calendar) {
     return $http.put(base_url+'/'+calendar.id+'.json', {calendar: calendar});
    }

    return pub;
  }

]);