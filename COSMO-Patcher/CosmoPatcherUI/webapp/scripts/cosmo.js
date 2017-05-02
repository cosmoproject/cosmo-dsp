/*
 *cosmo.js
 */

var app = angular.module('cosmoApp',  ['ng-sortable']);
app.constant('ngSortableConfig',
	     {onEnd: function() {
		 console.log('default onEnd()');
	     }});
app.config( [
    '$compileProvider',
    function( $compileProvider )
    {   
        $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|file|blob):/);
    }
]);
//    .constant('ngSortableConfig'
var prefix= 'pot'
app.controller('cosmoCtrl', function($scope, $http, $timeout) {
    $http.get('webapp/scripts/cosmo-controls.json').then(function(data) {
	$scope.cosmoCtrls = angular.fromJson(data.data);
    });
    $http.get('webapp/scripts/effects.json').then(function(data) {
	$scope.cosmoEffects = angular.fromJson(data.data);
	console.log(data)
    });
    $http.get('webapp/scripts/COSMO-Patch-example.json').then(function(data) {
	$scope.json_object = angular.fromJson(data.data);
	$scope.json_export = JSON.stringify($scope.json_object, null, 2);
	console.log($scope.json_export)
    });
    $scope.orderProp = 'ctrlId';
    $scope.placeholders = [0, 1, 2, 3, 4, 5, 6, 7]
    $scope.out_json = {};
    $scope.selection = -1;
    $scope.selected_udo = -1;
    $scope.selected_effects = {}
    $scope.arguments = [];    
    $scope.select_controller = function(element_id){
	console.log("selecting "+ element_id);
	$scope.selection = element_id;
	if (element_id != -1){
	    channel = prefix + element_id;
	    console.log($scope.json_object["COSMO-Patch"])
	    if (!$scope.json_object["COSMO-Patch"][channel]){
		$scope.json_object["COSMO-Patch"][channel] = {};
	    }
	    $scope.selected_effects = $scope.json_object["COSMO-Patch"][channel];
    	    console.log($scope.json_object["COSMO-Patch"][channel]);
	}
	$timeout(); //.$scope.$apply();
    }
    $scope.select_udo = function(udo, args){
	$scope.selected_udo = udo;
	$scope.arguments = args;
	$timeout(); //.$scope.$apply();
    }
    $scope.save = function()
    {
	$scope.json_export = JSON.stringify($scope.json_object, null, 2);
	var textToWrite = $scope.json_export;
	var textFileAsBlob = new Blob([textToWrite], {type:'text/plain'});
	var fileNameToSaveAs = 'COSMO_patch.json'
	//var save_link = document.getElementById('save');
	/*if (window.webkitURL != null)
	    $scope.savelink  = window.webkitURL.createObjectURL(textFileAsBlob);
	else*/
	$scope.savelink = window.URL.createObjectURL(textFileAsBlob);
    }
    $scope.save();
    $scope.add_effect = function(arg){
	console.log($scope.selected_udo + '-' + arg);
	$scope.selected_effects[$scope.selected_udo] = arg;
	channel = prefix + $scope.selection;
	$scope.json_object["COSMO-Patch"][channel] = $scope.selected_effects;
	$scope.save();
    }
    $scope.reset = function(){
	scope.select_controller(-1);
	$scope.selected_udo = -1;
	$scope.selected_effects = {}
	$scope.arguments = [];    
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
    scope = getControllerScope();
    scope.select_controller(ev.target.id);
    if (ev.target.className.split(' ')[0] != 'placeholder')
	return;
    var data = ev.dataTransfer.getData("draggedId");
    var nodeCopy = document.getElementById(data).cloneNode(true);
    nodeCopy.id = prefix+ev.target.id;
    ev.target.append(nodeCopy);
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
	delete scope.json_object["COSMO-Patch"][channel];
	scope.reset();
	scope.save();
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
