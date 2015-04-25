angular.module('agenda.userservice', ['httpq'])
.factory('UserService', ['$httpq', '$http',
  function ($httpq, $http) {

    var pub = {
      base_url: '/api/v1/users'
    };

    pub.set_url = function(url) {
      pub.base_url = url;
    }

    // load
    pub.all = function() {
      console.log(pub.base_url+'.json')
      return $httpq.get(pub.base_url+'.json')
    }

    pub.current = function() {
      return $httpq.get(pub.base_url+'/current.json');
    }

    pub.get = function(id) {
      return $httpq.get(pub.base_url+'/'+id+'.json');
    }

    pub.new = function() {
      return $httpq.get(pub.base_url+'/new.json')
    }

    pub.save = function(user, edit) {
      if (edit) {
        return pub.update(user);
      } else {
        return pub.create(user);
      }
    }

    pub.create = function(user) {
      return $http.post(pub.base_url+'.json', {user: user});
    }

    pub.update = function(user) {
     return $http.put(pub.base_url+'/'+user.id+'.json', {user: user});
    }

    pub.destroy = function(id) {
      return $http.delete(pub.base_url+'/'+id+'.json');
    }


    return pub;
  }
])

.factory('UserAdminService', ['UserService',
  function(UserService){

    var extended = {};
    angular.copy(UserService, extended)
    extended.set_url('/admin/users');
    return extended;

  }
])

;