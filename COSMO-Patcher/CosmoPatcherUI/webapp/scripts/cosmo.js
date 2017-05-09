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
	$scope.json_default = JSON.parse(
	    JSON.stringify($scope.json_object [$scope.patchname]));
    });
    $timeout();
    $scope.orderProp = 'ctrlId';
    $scope.patchname = "COSMO-Patch";
    $scope.analog_placeholders = range(8, 'pot');
    $scope.digital_placeholders = range(8,'switch');
    $scope.out_json = {};
    $scope.selection = -1;
    $scope.selected_udo = -1;
    $scope.selected_effects = {}
    $scope.arguments = [];    
    $scope.select_controller = function(element_id){
	if (!is_warehouse_element(element_id)){
	    $scope.selection = element_id;
	    if (element_id != -1){
		channel =  element_id;
		$scope.selected_effects = $scope.json_object[$scope.patchname][channel];
    		console.log($scope.json_object[$scope.patchname][channel]);
	    }
	    $timeout();
	}
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
	$timeout();
    }
    $scope.save();
    $scope.add_effect = function(arg){
	if (!$scope.selected_effects) $scope.selected_effects = {};
	$scope.selected_effects[$scope.selected_udo] = arg;
	channel = $scope.selection;	//add image
	$scope.json_default[channel] = '';
	if (!$scope.json_object[$scope.patchname][channel]){
	    $scope.json_object[$scope.patchname][channel] = {};
	}
	$scope.json_object[$scope.patchname][channel] = $scope.selected_effects;
	$scope.json_object[$scope.patchname] = sortObject($scope.json_object[$scope.patchname]);
	$scope.save();
    }
    $scope.delete_effect = function(element_id){
	console.log('Deleting effect: ' +element_id);
	channel = $scope.selection;
	//the list element is named like channel_effect_arg
	effect_key = element_id.split("_")[1];
	delete $scope.selected_effects[effect_key];
	console.log($scope.selected_effects);
	delete $scope.json_object[$scope.patchname][channel][effect_key];
	$scope.save();
	if ( !Object.keys($scope.selected_effects).length > 0) {
	    //if the controller has no keys, also delete the controller
	    console.log('Number of children: '+ $scope.selected_effects.length);
	    console.log('Deleting controller: '+channel);
	    $scope.delete_controller(channel);
	}
	$timeout();
    }

    $scope.reset = function(){
	scope.select_controller(-1);
	$scope.selected_udo = -1;
	$scope.selected_effects = {}
	$scope.arguments = [];    
    }
    $scope.delete_controller = function (element_id){
	console.log('Deleting: ' +element_id);
    	var dataNode = document.getElementById(element_id);
	console.log(dataNode);
	console.log(dataNode.parentNode);	
	dataNode.parentNode.removeChild(dataNode);
	delete $scope.json_object[$scope.patchname][element_id];
	$scope.reset();
	$scope.save();
    }
    $scope.default_load = function (i){
	if ($scope.json_default){
	    if (i in $scope.json_default)
		return true;
	}
	return false;
    }
    $scope.is_control = function(i){
	return is_warehouse_element(i);
    }
    $scope.control_class = function(i){
	if (is_warehouse_element(i))
	    return 'control';
	return '';
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
    if (ev.target.className.split(' ')[0] != 'placeholder')
	return;
    var data = ev.dataTransfer.getData("draggedId");
    var nodeCopy = document.getElementById(data).cloneNode(true);
    nodeCopy.id = ev.target.id.slice(1); /* remove the a prefix for the image*/
    console.log(scope.json_object[scope.patchname][data]);
    ev.target.append(nodeCopy);

    if (scope.json_object[scope.patchname][data]){
	if (!scope.json_object[scope.patchname][nodeCopy.id]){
	    scope.json_object[scope.patchname][nodeCopy.id] = {};
	}
	scope.json_object[scope.patchname][nodeCopy.id] =
	    scope.json_object[scope.patchname][data];
	scope.selected_effects = scope.json_object[scope.patchname][nodeCopy.id];
    }
    scope.json_object[scope.patchname] =
	sortObject(scope.json_object[scope.patchname]);
    //$scope.save();
    if (!is_warehouse_element(data)){
	//var dataNode = document.getElementById(data);
	//dataNode.parentNode.removeChild(dataNode);
	scope.delete_controller(data);
    }
    
    scope.select_controller(nodeCopy.id);

}


function is_warehouse_element(id) {
    id = id+'';
    if (id.substring(0,4) != 'ctrl')
	return false;
    else
	return true;
}

function trash(ev) {
    ev.preventDefault();
    ev.stopPropagation();
    var data = ev.dataTransfer.getData("draggedId");
    scope = getControllerScope();
    if (!is_warehouse_element(data)){
	if (scope.analog_placeholders.slice(1).includes(data) ||
	    scope.digital_placeholders.slice(1).includes(data)){
	    //removing selected controller
	    scope.delete_controller(data);
	}else{
	    //removing selected effects
	    scope.delete_effect(data);
	}
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

function sortObject(o) {
    return Object.keys(o).sort().reduce((r, k) => (r[k] = o[k], r), {});
}

function range(n, prefix='') {
    if (n<= 0) return null;
    var arr = ['ctrl_'+prefix];
    for (i = 0; i < n; i++) {
	arr.push(prefix+i);
    }
    return arr;
}
