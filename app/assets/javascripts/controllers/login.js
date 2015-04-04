app.controller("LoginCtrl", ['$rootScope', '$scope', function($rootScope, $scope) {

  console.log('LOGIN');

  $rootScope.login = true;

  $(function () {
    $('input').iCheck({
      checkboxClass: 'icheckbox_square-blue',
      radioClass: 'iradio_square-blue',
      increaseArea: '20%' // optional
    });
  });

}])

