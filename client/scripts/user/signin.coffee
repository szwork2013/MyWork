define(['app','logger'],->
    ['$scope','$localStorage','$location','Users','SiteConfig','logger'
        ($scope,$localStorage,$location,Users,SiteConfig,logger)->
            $scope.signin = ->
                formData = {
                    email: $scope.email,
                    password: $scope.password
                }
                Users.signin(formData,(res)->
                    if res.type is false
                        logger.logError(res.data)
                    else
                        if SiteConfig.authMethod is 'token'
                            $localStorage.token = res.data.token
                        $scope.$emit('reload-user',res);
                        $location.path('/')
                ,
                    ->logger.logError('Failed to signin')
                )
            $scope.me = ->
                Users.me((res)->
                    $scope.myDetails = res
                ,
                    ->logger.logError('Failed to Give Userinfo')
                )
    ]
)
