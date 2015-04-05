angular.module('agenda.authservice', ['ui.router'])
.factory('Auth', ['$rootScope', '$http', '$q', '$state',
  function ($rootScope, $http, $q, $state) {

    var errorState = 'app.error';
    var loginState = 'public.login';
    var storageUserKey = 'userData';
    var storageCurrentAccountKey = 'currentAccount';
    var is_loaded = false;

    var pub = {};
    var priv = {
      user: {
        role: accessLevels.public,
        data: null
      },
      account: {
        data: null
      }
    };

    priv.refresh_user_data = function() {
      priv.account.data = angular.fromJson(localStorage.getItem(storageCurrentAccountKey));

      priv.user.data = angular.fromJson(localStorage.getItem(storageUserKey));
      if (priv.user.data !== null) {
        is_loaded = true;
        priv.user.role = priv.user.data.admin ? accessLevels.admin : accessLevels.user;
      } else {
        is_loaded = false;
        priv.user.role = accessLevels.public;
      }
    }

    priv.loaded = function() {
      if (!is_loaded) {
        priv.refresh_user_data();
      }
    }

    pub.current_user = function() {
      priv.loaded()
      return priv.user.data;
    }

    pub.current_account = function() {
      priv.loaded()
      return priv.account.data;
    }

    pub.select_current_account = function(account) {
      priv.account.data = account;
      localStorage.setItem(storageCurrentAccountKey, angular.toJson(account));
      $rootScope.$broadcast("currentAccountSelected", priv.account.data);
    }

    pub.select_current_user = function(user) {
      localStorage.setItem(storageUserKey, angular.toJson(user));
      priv.refresh_user_data();
      $rootScope.$broadcast("currentUserSelected", user);
    }

    pub.login = function(credentials) {
      return $http.post("/api/v1/users/login", credentials);
    }

    pub.logout = function() {
      console.log("logout!!!!");
      localStorage.removeItem(storageUserKey);
      priv.refresh_user_data();
    }

    pub.authorize = function(event, to, toParams, from, fromParams) {
      console.log('authorize')

      if(!('data' in to) || !('access' in to.data)){
        console.error("Access undefined for this state");
        event.preventDefault();
      }

      priv.loaded()
      console.log(to);
      if (to.data.access.bitMask & priv.user.role.bitMask) {
        console.info("access granted ->", to.data.access)
        angular.noop(); // requested state can be transitioned to.
      } else {
        console.info("access denied ->", to.data.access)
        event.preventDefault();
        $rootScope.$emit('$statePermissionError');
        $state.go(loginState, {}, {reload: true,inherit: false});
      }

    }

    return pub;

  }
]);