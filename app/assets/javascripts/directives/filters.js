angular.module('agenda-filters', [])

.filter('yesno', function() {
  return function(input) {
    return input ? 'Sim' : 'Não';
  };
})

.filter('yesnoicon', function() {
  return function(input) {
    return (
      input ?
        "<i class='fa fa-check-circle text-green' title='Sim'></i>"
      :
        "<i class='fa fa-times-circle text-red' title='Não'></i>"
    );
  }
})

.filter('htmlsafe', ['$sce', function($sce) {
  // Retorna o valor como html
  // defe ser usado da seguinte forma
  // <td ng-bind-html='user.has_calendar | yesnoicon | htmlsafe'></td>
  // o conteúdo da TD será preenchido com o valor que foi passado para o safe
  return function(input) {
    return $sce.trustAsHtml(input);
  }
}])


/**
 * AngularJS default filter with the following expression:
 * "person in people | filter: {name: $select.search, age: $select.search}"
 * performs a AND between 'name: $select.search' and 'age: $select.search'.
 * We want to perform a OR.
 */
.filter('propsFilter', function() {
  return function(items, props) {
    var out = [];

    if (angular.isArray(items)) {
      items.forEach(function(item) {
        var itemMatches = false;

        var keys = Object.keys(props);
        for (var i = 0; i < keys.length; i++) {
          var prop = keys[i];
          var text = props[prop].toLowerCase();
          if (item[prop].toString().toLowerCase().indexOf(text) !== -1) {
            itemMatches = true;
            break;
          }
        }

        if (itemMatches) {
          out.push(item);
        }
      });
    } else {
      // Let the output be the input untouched
      out = items;
    }

    return out;
  };
})

.filter('taskStatusClass', function() {
  return function(task) {
    switch (task.status) {
      case 1:
        return 'default';
      case 2:
        return 'success';
      case 3:
        return 'danger';
    }
  }
})

;