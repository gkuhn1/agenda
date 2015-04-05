angular.module('httpq', []).factory('$httpq', ['$http', '$q', function($http, $q) {
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
}]);