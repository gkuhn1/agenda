angular.module('agenda.taskservice', ['httpq'])
.factory('TaskService', ['$httpq', '$http',
  function($httpq, $http){

    var pub = {
      base_url: "/api/v1/tasks",
      statuses: {
        1: "Aguardando confirmação",
        2: "Confirmado",
        3: "Cancelado"
      }
    };

    pub.get_url = function() {
      return pub.base_url;
    }

    // load
    pub._all = function($h, options) {
      console.log(options);
      data = {};
      if (options.start !== undefined && options.end !== undefined) {
        data = {start_at: options.start.toISOString(), end_at: options.end.toISOString()};
      }
      return $h.get(pub.get_url(), {params: data})
    }

    pub.all = function(start, end) {
      return pub._all($httpq, {start: start, end: end});
    }

    pub.promise_all = function(start, end) {
      return pub._all($http, {start: start, end: end});
    }

    pub.get = function(id) {
      return $http.get(pub.get_url()+'/'+id+'.json');
    }

    pub.new = function() {
      return $httpq.get(pub.get_url()+'/new.json')
    }

    pub.save = function(obj, edit) {
      console.log(edit);
      if (edit) {
        return pub.update(obj);
      } else {
        return pub.create(obj);
      }
    }

    pub.create = function(obj) {
      return $http.post(pub.get_url(), {task: obj});
    }

    pub.update = function(obj) {
      return $http.put(pub.get_url()+'/'+obj.id+'.json', {task: obj});
    }

    pub.destroy = function(id) {
      return $http.delete(pub.get_url()+'/'+id+'.json');
    }

    pub.toFullCalendar = function(task) {
      task.start = moment(task.start_at);
      task.end = moment(task.end_at);
      task.allDay = false;
      task.color = task.task_color;
      return task;
    }

    pub.eventToTask = function(event) {
      var task = {};
      task.id = event.id;
      task.account_id = event.account_id;
      task.calendar_id = event.calendar_id;
      task.title = event.title;
      task.where = event.where;
      task.status = event.status;
      task.description = event.description;
      task.end_at = event.end.toISOString();
      task.start_at = event.start.toISOString();
      return task;
    }

    pub.modalToTask = function(task) {
      console.log(task);
      var data = angular.copy(task, {});
      data.stick = true

      var start_at = (task.startdate + task.starttime) || "";
      if (start_at !== "")
        data.start_at = moment(start_at, "DD/MM/YYYYHH:mm").toISOString();

      var end_at = (task.enddate + task.endtime) || "";
      if (end_at !== "")
        data.end_at = moment(end_at, "DD/MM/YYYYHH:mm").toISOString();

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
