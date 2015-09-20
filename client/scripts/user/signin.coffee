define(['app','logger'],->
    ['$scope','$localStorage','$location','Users','logger'
        ($scope,$localStorage,$location,Users,logger)->
            $scope.signin = ->
                formData = {
                    email: $scope.email,
                    password: $scope.password
                }
                Users.signin(formData,(res)->
                    if res.type is false
                        logger.logError(res.data)
                    else
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
