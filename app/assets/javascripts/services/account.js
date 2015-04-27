angular.module('agenda.accountservice', ['httpq'])
.factory('AccountService', ['$httpq', '$http',
  function ($httpq, $http) {

    var pub = {
      base_url: '/api/v1/accounts'
    }

    pub.set_url = function(url) {
      pub.base_url = url;
    }

    // load
    pub.all = function() {
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

    pub.save = function(account, edit) {
      if (edit) {
        return pub.update(account);
      } else {
        return pub.create(account);
      }
    }

    pub.create = function(account) {
      return $http.post(pub.base_url+'.json', {account: account});
    }

    pub.update = function(account) {
     return $http.put(pub.base_url+'/'+account.id+'.json', {account: account});
    }

    pub.destroy = function(id) {
      return $http.delete(pub.base_url+'/'+id+'.json');
    }


    return pub;
  }

])

.factory('AccountAdminService', ['AccountService',
  function(AccountService){

    var extended = {};
    angular.copy(AccountService, extended);
    extended.set_url('/admin/accounts');
    return extended;

  }
])

;