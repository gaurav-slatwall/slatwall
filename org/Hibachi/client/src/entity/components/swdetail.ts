class SWDetail{
	public static Factory(){
		var directive = (
			$location,
			$log,
			$hibachi,
			coreEntityPartialsPath,
			pathBuilderConfig
		)=> new SWDetail(
			$location,
			$log,
			$hibachi,
			coreEntityPartialsPath,
			pathBuilderConfig
		);
		directive.$inject = [
			'$location',
			'$log',
			'$hibachi',
			'coreEntityPartialsPath',
			'pathBuilderConfig'
		];
		return directive;
	}
	constructor(
		$location,
		$log,
		$hibachi,
		coreEntityPartialsPath,
		pathBuilderConfig
	){
		return {
	        restrict: 'E',
	        templateUrl:pathBuilderConfig.buildPartialsPath(coreEntityPartialsPath)+'/detail.html',
	        link: function (scope, element, attr) {
	        	scope.$id="slatwallDetailController";
	        	$log.debug('slatwallDetailController');

				/*Sets the view dirty on save*/
				scope.setDirty = function(entity){
					angular.forEach(entity.forms,function(form){
						form.$setSubmitted();
					});
				};
	        	var setupMetaData = function(){
	        		scope[scope.entityName.toLowerCase()] = scope.entity;
	        		scope.entity.metaData.$$getDetailTabs().then(function(value){
                        scope.detailTabs = value.data;
                        $log.debug('detailtabs');
                        $log.debug(scope.detailTabs);
                    });


	        	};

	        	var propertyCasedEntityName = scope.entityName.charAt(0).toUpperCase() + scope.entityName.slice(1);

	        	scope.tabPartialPath = pathBuilderConfig.buildPartialsPath(coreEntityPartialsPath);

	        	scope.getEntity = function(){

	        		if(scope.entityID === 'null'){
	        			scope.entity = $hibachi['new'+propertyCasedEntityName]();
	        			setupMetaData();
	        		}else{
	        			var entityPromise = $hibachi['get'+propertyCasedEntityName]({id:scope.entityID});
	        			entityPromise.promise.then(function(){
	        				scope.entity = entityPromise.value;
	        				setupMetaData();
	        			});
	        		}

	        	};
	        	scope.getEntity();
	        	scope.deleteEntity = function(){
	        		var deletePromise = scope.entity.$$delete();
	        		deletePromise.then(function(){
	        			$location.path( '/entity/'+propertyCasedEntityName+'/' );
	        		});
	        	};
	        	scope.allTabsOpen = false;
	        }
	    };
	}
}
export{
	SWDetail
}