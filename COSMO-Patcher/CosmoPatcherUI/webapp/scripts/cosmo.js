/*
 *cosmo.js
 */

var app = angular.module('cosmoApp', []);
var prefix= 'pot'
app.controller('cosmoCtrl', function($scope, $http) {
    $http.get('webapp/scripts/cosmo-controls.json').then(function(data) {
	$scope.cosmoCtrls = angular.fromJson(data.data);//Object.values(data.data); // data.data;
    });
    $scope.orderProp = 'ctrlId';
    $scope.placeholders = [0, 1, 2, 3, 4, 5, 6, 7]
    $scope.updateControls = function(){
	console.log('Loaded: ');
	return true;
    }
    $scope.out_json = {};
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
    console.log(ev.target.className);
    if (ev.target.className.split(' ')[0] != 'placeholder')
	return;
    var data = ev.dataTransfer.getData("draggedId");
    var nodeCopy = document.getElementById(data).cloneNode(true);
    console.log(ev.target.id)
    nodeCopy.id = prefix+ev.target.id;
    scope = getControllerScope();
    if (scope.updateControls()){
	ev.target.append(nodeCopy);
    }
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
