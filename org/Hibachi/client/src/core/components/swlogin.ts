/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />


class SWLoginController{
    public account_login;
    constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private corePartialsPath, private $hibachi, private dialogService){
        this.$hibachi = $hibachi;
        this.$window = $window;
        this.$route = $route;
        this.account_login = $hibachi.newEntity('Account_Login');
    }
    public login = ():void =>{
        var loginPromise = this.$hibachi.login(this.account_login.data.emailAddress, this.account_login.data.password);
        loginPromise.then((loginResponse)=>{
            if(loginResponse && loginResponse.data && loginResponse.data.token){
                this.$window.localStorage.setItem('token',loginResponse.data.token);
                this.$route.reload();
                this.dialogService.removeCurrentDialog();
            }
        });
    }
}

class SWLogin implements ng.IDirective{

    public restrict:string = 'E';
    public scope = {};
    public bindToController={
    };
    public controller=SWLoginController
    public controllerAs="SwLogin";
    public templateUrl;

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            $route,
            $log:ng.ILogService,
            $window:ng.IWindowService,
            corePartialsPath,
            $hibachi,
            dialogService,
			pathBuilderConfig
        )=>new SWLogin(
            $route,
            $log,
            $window,
            corePartialsPath,
            $hibachi,
            dialogService,
			pathBuilderConfig
        );
        directive.$inject = [
            '$route',
            '$log',
            '$window',
            'corePartialsPath',
            '$hibachi',
            'dialogService',
			'pathBuilderConfig'
        ]
        return directive;
    }

    constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private corePartialsPath, private $hibachi, private dialogService,
			pathBuilderConfig ){
        this.templateUrl = pathBuilderConfig.buildPartialsPath(this).corePartialsPath+'/login.html';
    }

    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

    }
}
export{
    SWLogin
}
