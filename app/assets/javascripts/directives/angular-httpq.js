app.factory('$httpq', function($http, $q) {
  return {
    get: function() {
      var deferred = $q.defer();
      $http.get.apply(null, arguments)
        .success(function(data) {
          deferred.resolve(data)
        })
        .error(deferred.reject);
      return deferred.promise;
    }
  }
});