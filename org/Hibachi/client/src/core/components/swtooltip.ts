/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWTooltipController {

    public rbKey; 
    public text; 
    public position; 
    public showTooltip:boolean = false; 

    // @ngInject
	constructor(public rbkeyService){
        this.text = rbkeyService.getRBKey(this.rbKey);
	}
}

class SWTooltip implements ng.IDirective{

	public templateUrl;
    public transclude=false;
	public restrict = "E";
	public scope = {}

	public bindToController = {
        rbKey:"@",
        position:"@",
        showTooltip:"=?"
	}
	public controller=SWTooltipController;
	public controllerAs="swTooltip";

    // @ngInject
	constructor( public $document, private corePartialsPath, hibachiPathBuilder){
	   this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "tooltip.html";
    }

	public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any, controller:any, transclude:any) =>{
	   this.$document.on("mouseenter", ()=>{
           scope.swTooltip.showTooltip = true;
       });
       
       this.$document.exit("mouseenter", ()=>{
           scope.swTooltip.showTooltip = false;
       });
    }
    
	public static Factory(){
		var directive:ng.IDirectiveFactory = ($document,corePartialsPath,hibachiPathBuilder) => new SWTooltip($document,corePartialsPath,hibachiPathBuilder);
		directive.$inject = ["$document","corePartialsPath","hibachiPathBuilder"];
		return directive;
	}
}
export{
	SWTooltip,
	SWTooltipController
}
