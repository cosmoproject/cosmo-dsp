/*
 *cosmo.js
 */

var app = angular.module('cosmoApp',  ['ng-sortable']);
app.constant('ngSortableConfig',
	     {onEnd: function() {
		 console.log('default onEnd()');
	     }})
//    .constant('ngSortableConfig'
var prefix= 'pot'
app.controller('cosmoCtrl', function($scope, $http, $timeout) {
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
    $scope.selected_effect = -1;
    $scope.arguments = [];    
    $scope.select_controller = function(element_id){
	console.log("selecting "+ element_id);
	if (element_id == -1){
	    $scope.arguments = [];
	    $scope.selected_effect = -1;
	}
	$scope.selection = element_id;
	$timeout(); //.$scope.$apply();
    }
    $scope.select_effect = function(effect, args){
	$scope.selected_effect = effect;
	$scope.arguments = args;
	$timeout(); //.$scope.$apply();
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
	scope = getControllerScope();
	scope.select_controller(-1);
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

/* 
angular.module('todoApp', ['ng-sortable'])
    .constant('ngSortableConfig', {onEnd: function() {
	console.log('default onEnd()');
    }})
    .controller('TodoController', ['$scope', function ($scope) {
	$scope.todos = [
	    {text: 'learn angular', done: true},
	    {text: 'build an angular app', done: false}
	];

	$scope.addTodo = function () {
	    $scope.todos.push({text: $scope.todoText, done: false});
	    $scope.todoText = '';
	};

	$scope.remaining = function () {
	    var count = 0;
	    angular.forEach($scope.todos, function (todo) {
		count += todo.done ? 0 : 1;
	    });
	    return count;
	};

	$scope.archive = function () {
	    var oldTodos = $scope.todos;
	    $scope.todos = [];
	    angular.forEach(oldTodos, function (todo) {
		if (!todo.done) $scope.todos.push(todo);
	    });
	};
    }])
    .controller('TodoControllerNext', ['$scope', function ($scope) {
	$scope.todos = [
	    {text: 'learn Sortable', done: true},
	    {text: 'use ng-sortable', done: false},
	    {text: 'Enjoy', done: false}
	];

	$scope.remaining = function () {
	    var count = 0;
	    angular.forEach($scope.todos, function (todo) {
		count += todo.done ? 0 : 1;
	    });
	    return count;
	};

	$scope.sortableConfig = { group: 'todo', animation: 150 };
	'Start End Add Update Remove Sort'.split(' ').forEach(function (name) {
	    $scope.sortableConfig['on' + name] = console.log.bind(console, name);
	});
    }]);
})();
*/
