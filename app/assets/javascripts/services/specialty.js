angular.module('agenda.specialtyservice', ['httpq'])
.factory('SpecialtyService', ['$httpq', '$http',
  function($httpq, $http){

    var pub = {
      base_url: "/api/v1/specialties"
    };

    pub.get_url = function() {
      return pub.base_url;
    }

    // load
    pub.all = function() {
      return $httpq.get(pub.get_url());
    }

    pub.get = function(id) {
      return $httpq.get(pub.get_url()+'/'+id+'.json');
    }

    pub.new = function() {
      return $httpq.get(pub.get_url()+'/new.json')
    }

    pub.save = function(obj, edit) {
      if (edit) {
        return pub.update(obj);
      } else {
        return pub.create(obj);
      }
    }

    pub.create = function(obj) {
      return $http.post(pub.get_url(), {specialty: obj});
    }

    pub.update = function(obj) {
      return $http.put(pub.get_url()+'/'+obj.id+'.json', {specialty: obj});
    }

    pub.destroy = function(id) {
      return $http.delete(pub.get_url()+'/'+id+'.json');
    }

    return pub;

  }
])
