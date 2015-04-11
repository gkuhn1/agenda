angular.module('agenda.adminservice', ['httpq']).factory('AdminService', ['$httpq', '$http',
  function ($httpq, $http) {

    var base_url = '/admin';

    var pub = {};

    pub.get_dashboard_data = function() {
      return $httpq.get(base_url+'/dashboard.json')
    }

    return pub;
  }

]);