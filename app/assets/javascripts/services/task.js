angular.module('agenda.taskservice', ['httpq'])
.factory('TaskService', ['$httpq', '$http',
  function($httpq, $http){

    var pub = {
      base_url: "/api/v1/calendars/:calendar_id/tasks"
    };

    pub.get_url = function(calendar_id) {
      return pub.base_url.replace(":calendar_id", calendar_id);
    }

    // load
    pub.all = function(calendar_id, options) {
      console.log(options);
      data = {};
      if (options.start !== undefined && options.end !== undefined) {
        data = {start_at: options.start.toISOString(), end_at: options.end.toISOString()};
      }
      return $http.get(pub.get_url(calendar_id),data)
    }

    pub.get = function(calendar_id, id) {
      return $httpq.get(pub.get_url(calendar_id)+'/'+id+'.json');
    }

    pub.new = function(calendar_id) {
      return $httpq.get(pub.get_url(calendar_id)+'/new.json')
    }

    pub.save = function(calendar_id, obj, edit) {
      if (edit) {
        return pub.update(calendar_id, obj);
      } else {
        return pub.create(calendar_id, obj);
      }
    }

    pub.create = function(calendar_id, obj) {
      return $http.post(pub.get_url(calendar_id), {task: obj});
    }

    pub.update = function(calendar_id, obj) {
      return $http.put(pub.get_url(calendar_id)+'/'+obj.id+'.json', {task: obj});
    }

    pub.destroy = function(calendar_id, id) {
      return $http.delete(pub.get_url(calendar_id)+'/'+id+'.json');
    }

    pub.toFullCalendar = function(task) {
      return {
        title: task.title,
        // start: moment(task.startdate + task.starttime, "DD/MM/YYYYHH:mm"),
        // end: moment(task.enddate + task.endtime, "DD/MM/YYYYHH:mm"),
        start: moment(task.start_at),
        end: moment(task.end_at),
        allDay: false,
      }
    }

    pub.modalToTask = function(task) {
      data = {
        title: task.title,
        stick: true
      }
      if (task.startdate + task.starttime !== "")
        data.start_at = moment(task.startdate + task.starttime, "DD/MM/YYYYHH:mm").toISOString()

      if (task.enddate + task.endtime !== "")
        data.end_at = moment(task.enddate + task.endtime, "DD/MM/YYYYHH:mm").toISOString()

      return data;
    }

    return pub;

  }
])
