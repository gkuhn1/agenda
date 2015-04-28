angular.module('agenda.calendarservice', ['httpq']).factory('CalendarService', ['$httpq', '$http',
  function ($httpq, $http) {

    var base_url = '/api/v1/calendars';

    var pub = {};

    // load
    pub._all = function($h, start, end) {
      var data = {tasks: true};
      if (start && end) {
        data.start_at  = start
        data.end_at = end
      }

      return $h.get(base_url+'.json', {params: data});
    }

    pub.all = function(start, end) {
      return pub._all($httpq, start, end);
    }

    pub.promise_all = function(start, end) {
      return pub._all($http, start, end);
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