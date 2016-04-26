/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class RouterController{
	//@ngInject
	constructor(
		$scope,
		$routeParams,
		$location,
		$log,
		partialsPath,
		baseURL
	){
		$scope.$id="routerController";
		$scope.partialRoute = '';

		$log.debug($routeParams);
		$log.debug($location);
		var path = $location.path();
		$scope.controllerType = path.split('/')[1];
		var type;

		if($scope.controllerType === 'entity'){
            //remove all dashes
			$scope.entityName = $routeParams.entityName.replace(/-/g, '');
			if(angular.isDefined($routeParams.entityID)){
				$scope.entityID = $routeParams.entityID || '';
			}

		}
	}
}
export{
	RouterController
}