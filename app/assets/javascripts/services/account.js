angular.module('agenda.accountservice', ['httpq']).factory('AccountService', ['$httpq', '$http',
  function ($httpq, $http) {

    var base_url = '/api/v1/accounts';

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

    pub.save = function(account, edit) {
      if (edit) {
        return pub.update(account);
      } else {
        return pub.create(account);
      }
    }

    pub.create = function(account) {
      return $http.post(base_url+'.json', {account: account});
    }

    pub.update = function(account) {
     return $http.put(base_url+'/'+account.id+'.json', {account: account});
    }

    pub.destroy = function(id) {
      return $http.delete(base_url+'/'+id+'.json');
    }


    return pub;
  }

]);