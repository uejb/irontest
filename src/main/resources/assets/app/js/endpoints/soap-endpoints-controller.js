'use strict';

angular.module('iron-test').controller('SOAPEndpointsController', ['$scope', 'Endpoints', '$stateParams', '$state',
  function($scope, Endpoints, $stateParams, $state) {
    $scope.create = function(isValid) {
      if (isValid) {
        var endpoint = new Endpoints({
          environmentId: $stateParams.environmentId,
          name: this.name,
          type: 'SOAP',
          description: this.description,
          url: this.soapAddress,
          username: this.username,
          password: this.password
        });
        endpoint.$save(function(response) {
          $state.go('environment_edit', {environmentId: response.environmentId});
        }, function(error) {
          alert('Error');
        });
      } else {
        $scope.submitted = true;
      }
    };
  }
]);