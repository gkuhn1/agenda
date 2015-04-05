angular.module('agenda.userservice', ['httpq'])
.factory('UserService', ['$httpq', '$http',
  function ($httpq, $http) {

    var base_url = '/api/v1/users';

    var pub = {};

    // load
    pub.all = function() {
      return $httpq.get(base_url+'.json')
    }

    pub.current = function() {
      return $httpq.get(base_url+'/current.json');
    }

    pub.get = function(id) {
      return $httpq.get(base_url+'/'+id+'.json');
    }

    pub.new = function() {
      return $httpq.get(base_url+'/new.json')
    }

    pub.save = function(user, edit) {
      if (edit) {
        return pub.update(user);
      } else {
        return pub.create(user);
      }
    }

    pub.create = function(user) {
      return $http.post(base_url+'/users.json', {user: user});
    }

    pub.update = function(user) {
     return $http.put(base_url+'/'+user.id+'.json', {user: user});
    }

    pub.destroy = function(id) {
      return $http.delete(base_url+'/'+id+'.json');
    }


    return pub;
  }
]);