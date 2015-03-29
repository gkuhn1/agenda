// app.factory('MenuService', function ($http) {

//   var menuServices = {};

//   // load
//   menuServices.load = function() {
//     return $http
//       .post('/menus', credentials)
//       .then(function (res) {
//         Session.create(res.data.id, res.data.user.id,
//                        res.data.user.role);
//         return res.data.user;
//       });
//   }


//   return menuServices;
// })