angular.module('agenda.notificationservice', ['httpq'])
.factory('NotificationService', ['$httpq', '$http',
  function($httpq, $http){

    var pub = {
      base_url: "/api/v1/notifications"
    };

    pub.get_url = function() {
      return pub.base_url;
    }

    // load
    pub.all = function(options) {
      return $httpq.get(pub.get_url())
    }

    pub.mark_as_read = function(obj) {
      return $http.put(pub.get_url()+'/'+obj.id+'/mark_as_read');
    }

    pub.mark_as_unread = function(obj) {
      return $http.put(pub.get_url()+'/'+obj.id+'/mark_as_unread');
    }

    return pub;

  }
])
