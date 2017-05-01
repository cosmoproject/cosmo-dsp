/*
 *cosmo.js
 */

var app = angular.module('cosmoApp', []);
var prefix= 'pot'
app.controller('cosmoCtrl', function($scope, $http) {
    $http.get('webapp/scripts/cosmo-controls.json').then(function(data) {
	$scope.cosmoCtrls = angular.fromJson(data.data);
    });
    $http.get('webapp/scripts/effects.json').then(function(data) {
	$scope.cosmoEffects = angular.fromJson(data.data);
	console.log($scope.cosmoEffects)
    });
    $scope.orderProp = 'ctrlId';
    $scope.placeholders = [0, 1, 2, 3, 4, 5, 6, 7]
    $scope.out_json = {};
    $scope.selection = -1;
    $scope.select_controller = function(element_id){
	console.log("selecting "+ element_id);
	$scope.selection = element_id;
	$scope.$apply();
    }
});

function allowDrop(ev) {
    ev.dataTransfer.dropEffect = 'move';
    ev.preventDefault();
    scope = getControllerScope();
    scope.select_controller(ev.target.id);
}

function drag(ev) {
    ev.dataTransfer.setData("draggedId", ev.target.id);
    scope = getControllerScope();
    scope.select_controller(ev.target.id);
}

function drop(ev) {
    ev.preventDefault();
    console.log(ev.target.className);
    if (ev.target.className.split(' ')[0] != 'placeholder')
	return;
    var data = ev.dataTransfer.getData("draggedId");
    var nodeCopy = document.getElementById(data).cloneNode(true);
    nodeCopy.id = prefix+ev.target.id;
    ev.target.append(nodeCopy);
    scope = getControllerScope();
    scope.select_controller(ev.target.id);
    if (!is_warehouse_element(data)){
	var dataNode = document.getElementById(data);
	dataNode.parentNode.removeChild(dataNode);
    }
}


function is_warehouse_element(id) {
    if (id.substring(0,4) != 'ctrl')
	return false;
    else
	return true;
}

function trash(ev) {
    ev.preventDefault();
    var data = ev.dataTransfer.getData("draggedId");
    if (!is_warehouse_element(data)){
	var dataNode = document.getElementById(data);
	scope = getControllerScope();
	dataNode.parentNode.removeChild(dataNode);
    }else{
	console.log('not removing, control object');
    }
}

function getControllerScope() {
    var appElement = document.querySelector('[ng-app=cosmoApp]');
    var appScope = angular.element(appElement).scope();
    var controllerScope = appScope.$$childHead;
    return appScope;
}
