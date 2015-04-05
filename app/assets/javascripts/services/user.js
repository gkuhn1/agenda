angular.module('agenda.userservice', ['httpq'])
.factory('UserService', ['$httpq', '$http',
  function ($httpq, $http) {

    var pub = {};

    // load
    pub.all = function() {
      return $httpq.get('/admin/users.json')
    }

    pub.current = function() {
      return $httpq.get('/api/v1/users/current.json');
    }

    pub.get = function(id) {
      return $httpq.get('/admin/users/'+id+'.json');
    }

    pub.new = function() {
      return $httpq.get('/admin/users/new.json')
    }

    pub.save = function(user, edit) {
      if (edit) {
        return pub.update(user);
      } else {
        return pub.create(user);
      }
    }

    pub.create = function(user) {
      return $http.post('/admin/users.json', {user: user});
    }

    pub.update = function(user) {
     return $http.put('/admin/users/'+user.id+'.json', {user: user});
    }

    pub.destroy = function(id) {
      return $http.delete('/admin/users/'+id+'.json');
    }


    return pub;
  }
]);