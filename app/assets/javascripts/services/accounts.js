app.factory('AccountService', function ($httpq, $http) {

  var pub = {};

  // load
  pub.all = function() {
    return $httpq.get('/admin/accounts.json')
  }

  pub.get = function(id) {
    return $httpq.get('/admin/accounts/'+id+'.json');
  }

  pub.new = function() {
    return $httpq.get('/admin/accounts/new.json')
  }

  pub.save = function(account, edit) {
    if (edit) {
      return pub.update(account);
    } else {
      return pub.create(account);
    }
  }

  pub.create = function(account) {
    return $http.post('/admin/accounts.json', account);
  }

  pub.update = function(account) {
   return $http.put('/admin/accounts/'+account.id+'.json', account);
  }

  pub.destroy = function(id) {
    return $http.delete('/admin/accounts/'+id+'.json');
  }


  return pub;
})