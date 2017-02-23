/*
 *cosmo.js
 */

var app = angular.module('cosmoApp', []);

app.controller('cosmoCtrl', function($scope, $http) {
    $http.get('webapp/scripts/cosmo-controls.json').then(function(data) {
	$scope.cosmoCtrls = angular.fromJson(data.data);//Object.values(data.data); // data.data;
    });
    $scope.orderProp = 'ctrlId';
    $scope.maxControls=8;
    $scope.numControls=0;
    $scope.updateControls = function(){
	if ($scope.numControls < $scope.maxControls){
	    $scope.numControls ++;
	    console.log('added 1 - ' + $scope.numControls);
	    return true;
	}
	console.log($scope.numControls);
	return false;
    }
    
});
function allowDrop(ev) {
    ev.dataTransfer.dropEffect = 'move';
    ev.preventDefault();
}

function drag(ev) {
    ev.dataTransfer.setData("draggedId", ev.target.id);
}

function drop(ev) {
    ev.preventDefault();
    var data = ev.dataTransfer.getData("draggedId");
    var nodeCopy = document.getElementById(data).cloneNode(true);
    nodeCopy.id = "selected"+data; /* Need to make this unique */
    scope = getControllerScope();
    if (scope.updateControls())
	ev.target.append(nodeCopy);
}

function trash(ev) {
    ev.preventDefault();
    var data = ev.dataTransfer.getData("draggedId");
    if (data.substring(0,4) != 'ctrl'){
	var dataNode = document.getElementById(data);
	scope = getControllerScope();
	scope.numControls = scope.numControls - 1;
	dataNode.parentNode.removeChild(dataNode);
	console.log('removed 1 - ' + scope.numControls);
    }else{
	console.log('not removing, control object');
    }
}

function getControllerScope() {
    var appElement = document.querySelector('[ng-app=cosmoApp]');
    var appScope = angular.element(appElement).scope();
    //var controllerScope = appScope.$$childHead;
    return appScope;
}
