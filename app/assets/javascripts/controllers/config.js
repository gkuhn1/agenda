angular.module('agenda.account-configs', ['agenda.grandfather'])

.controller("AccountConfigHomeCtrl", ['$scope', '$rootScope',
    'current_account', 'AccountService',
  function($scope, $rootScope, current_account, AccountService) {
  }
])

.controller("EditAccountConfigHomeCtrl", ['$scope', '$rootScope',
    '$state', 'current_account', 'AccountService', 'Auth',
  function($scope, $rootScope, $state, current_account, AccountService, Auth) {

    $scope.form_title = "Editar informações da conta atual";
    $scope.account = {}
    angular.copy(current_account, $scope.account);
    $scope.errors = {};

    $scope.saveAccount = function(account) {
      $scope.laddaLoading = true;
      $scope.errors = {};
      AccountService.save(account, true)
        .success(function(data) {
          angular.copy(account, current_account);
          Auth.select_current_account(account);
          // force stop loading
          $rootScope.$broadcast("loading_stop");
          $state.go('^');
        })
        .error(function(data) {
          angular.forEach(data.errors, function(errors, field) {
            $scope.form[field].$setValidity('server', false);
            $scope.errors[field] = errors.join(', ');
          })
        })
        .finally(function() {
          $scope.laddaLoading = false;
        })
        ;
    }

  }
])


.controller("AccountUsersCtrl", ['$scope', '$rootScope',
    '$state', 'users', 'AccountService', 'Auth',
  function($scope, $rootScope, $state, users, AccountService, Auth) {
    $scope.users = users;

    $scope.destroyUser = function(user) {
      AccountService.remove_user(user.id)
        .success(function() {
          $scope.users.splice($scope.users.indexOfById(user), 1);
        });
    }
  }
])

.controller("AccountUsersEditCtrl", ['$scope', '$rootScope',
    '$state', 'user', 'UserService', 'AccountService',
  function($scope, $rootScope, $state, user, UserService, AccountService) {
    $scope.user = user;
    $scope.errors = {};
    $scope.addNewUser = false;
    $scope.addExistingUser = false;
    $scope.laddaSearchLoading = false;

    $('#task_colorpicker').colorpicker({
      color: user.task_color,
      format: 'hex',
      afterUpdate: function(elem, val) {
        $scope.user.task_color = val;
      }
    });

    $scope.searchUser = function(email) {
      $scope.laddaSearchLoading = true;

      UserService.getByEmail(email)
        .success(function(data) {
          $scope.addNewUser = false;
          $scope.addExistingUser = true;
          $scope.user.user_id = data.id;
        })
        .error(function(data) {
          console.log("error", data);
          $scope.addExistingUser = false;
          $scope.addNewUser = true;
        })
        .finally(function() {
          $scope.laddaSearchLoading = false;
        })
    }

    $scope.saveUser = function(user) {
      if ($scope.addNewUser || $state.current.data.edit) $scope.addNewAccountUser(user);
      if ($scope.addExistingUser) $scope.addAccountUser(user);
    }

    $scope.addAccountUser = function(user) {
      $scope.laddaLoading = true;
      $scope.errors = {};

      AccountService.add_user(user)
        .success(function(data) {
          $state.go('^', {}, {reload: true});
        })
        .finally(function() {
          $scope.laddaLoading = false;
        })
    }

    $scope.addNewAccountUser = function(user){
      $scope.laddaLoading = true;
      $scope.errors = {};

      if ($state.current.data.edit == false)
        user.generate_password = true;

      UserService.save(user, $state.current.data.edit)
        .success(function(data) {
          updateUser(data);
          $state.go('^');
        })
        .error(function(data) {
          angular.forEach(data.errors, function(errors, field) {
            $scope.form[field].$setValidity('server', false);
            $scope.errors[field] = errors.join(', ');
          })
        })
        .finally(function() {
          $scope.laddaLoading = false;
        })
        ;
    }

    var updateUser = function(data) {
      if ($state.current.data.edit) {
        var idx = $scope.$parent.users.indexOfById(data);
        $scope.$parent.users[idx] = data;
      } else {
        $scope.$parent.users.push(data);
      }
    }

  }
])


.controller("AccountSpecialitiesCtrl", ['$scope', '$rootScope',
    '$state', 'specialties',
  function($scope, $rootScope, $state, specialties) {
    console.log(specialties);
    $scope.specialties = specialties;

    $scope.destroy = function() {
      console.log('destroy');
    }
  }
])

.controller("AccountSpecialitiesEditCtrl", ['$scope', '$rootScope',
    '$state', 'specialty', 'SpecialtyService',
  function($scope, $rootScope, $state, specialty, SpecialtyService) {
    $scope.specialty = specialty;
    $scope.errors = {};

    $scope.saveUser = function(specialty) {
      $scope.laddaLoading = true;
      $scope.errors = {};

      if ($state.current.data.edit == false)
        specialty.generate_password = true;

      SpecialtyService.save(specialty, $state.current.data.edit)
        .success(function(data) {
          update(data);
          $state.go('^');
        })
        .error(function(data) {
          angular.forEach(data.errors, function(errors, field) {
            $scope.form[field].$setValidity('server', false);
            $scope.errors[field] = errors.join(', ');
          })
        })
        .finally(function() {
          $scope.laddaLoading = false;
        })
        ;
    }

    var update = function(data) {
      if ($state.current.data.edit) {
        var idx = $scope.$parent.specialties.indexOfById(data);
        $scope.$parent.specialties[idx] = data;
      } else {
        $scope.$parent.specialties.push(data);
      }
    }

  }
])
