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
      return $http.get(pub.get_url(calendar_id)+'/'+id+'.json');
    }

    pub.new = function(calendar_id) {
      return $httpq.get(pub.get_url(calendar_id)+'/new.json')
    }

    pub.save = function(calendar_id, obj, edit) {
      console.log(edit);
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
        id: task.id,
        calendar_id: task.calendar_id,
        title: task.title,
        // start: moment(task.startdate + task.starttime, "DD/MM/YYYYHH:mm"),
        // end: moment(task.enddate + task.endtime, "DD/MM/YYYYHH:mm"),
        start: moment(task.start_at),
        end: moment(task.end_at),
        allDay: false,
      }
    }

    pub.modalToTask = function(task) {
      console.log(task);
      var data = angular.copy(task, {});
      data.stick = true

      var start_at = (task.startdate + task.starttime) || "";
      if (start_at !== "")
        data.start_at = moment(start_at, "DD/MM/YYYYHH:mm").toISOString()

      var end_at = (task.enddate + task.endtime) || "";
      if (end_at !== "")
        data.end_at = moment(end_at, "DD/MM/YYYYHH:mm").toISOString()

      console.log(data);
      return data;
    }

    pub.taskToModal = function(task) {
      var data = angular.copy(task, {});

      var end = moment(task.end_at);
      var start = moment(task.start_at);
      data.enddate = end.format('DD/MM/YYYY');
      data.endtime = end.format('HH:mm');
      data.startdate = start.format('DD/MM/YYYY');
      data.starttime = start.format('HH:mm');
      return data;
    }

    return pub;

  }
])
