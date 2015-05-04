angular.module('agenda.searchservice', ['httpq'])
.factory('SearchService', ['$httpq', '$http',
  function($httpq, $http){

    var pub = {
      base_url: "/api/v1/searches"
    };

    pub.get_url = function() {
      return pub.base_url;
    }

    // load
    pub.all_places = function() {
      // return $httpq.get(pub.get_url());
      return [
        {name: "Local 1", id: "1"},
        {name: "Local 2", id: "2"},
        {name: "Local 3", id: "3"},
        {name: "Local 4", id: "4"},
        {name: "Local 5", id: "5"},
        {name: "Local 6", id: "6"},
        {name: "Local 7", id: "7"},
        {name: "Local 8", id: "8"}
      ]
    }

    pub.all_specialties = function() {
      return $httpq.get(pub.get_url()+'/specialties');
    }

    pub.search = function(search) {
      var data = {}
      if (search.end_at === undefined) search.end_at = '23:59'
      if (search.start_at === undefined) search.start_at = '00:00'

      data.start_at = moment(search.date+search.start_at, 'DD/MM/YYYYHH:mm').toISOString()
      data.end_at = moment(search.date+search.end_at, 'DD/MM/YYYYHH:mm').toISOString()
      data.specialty_id = search.specialty_id
      return $http.get(pub.get_url(), {params: data});
    }

    return pub;

  }
])
