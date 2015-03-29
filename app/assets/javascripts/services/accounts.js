app.factory('AccountService', function ($httpq) {

  var accountServices = {};

  // load
  accountServices.all = function() {
    return $httpq.get('/admin/accounts.json')
  }

  accountServices.get = function(id) {
    return $httpq.get('/admin/accounts/'+id+'.json');
  }


  return accountServices;
})