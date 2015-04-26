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

;