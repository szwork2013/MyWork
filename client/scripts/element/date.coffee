define(['angularAMD'],(angularAMD)->
    angularAMD.directive('rangedate', [ ->
        {
            restrict: 'AE'
            transclude: true
            require: '^ngModel'
            scope: {
              ngModel: '='
            }
            templateUrl:(elem, attr)->
              '/static/views/element/base-date.html'
            link:(scope, element, attrs)->
            controller:($scope,$filter)->
                $scope.openStartTime = ($event)->
                  $event.preventDefault()
                  $event.stopPropagation()
                  $scope.status.openedStart = !0
                $scope.openEndTime = ($event)->
                  $event.preventDefault()
                  $event.stopPropagation()
                  $scope.status.openedEnd = !0
                $scope.getdateFilter = ->
                  $scope.nowTime = Date.UTC(new Date().getFullYear(), new Date().getMonth(), new Date().getDate()) - 8*3600*1000
                  switch $scope.dateFilter
                    when 1
                      $scope.ngModel.startTime = angular.copy($scope.nowTime)
                      $scope.ngModel.endTime = angular.copy($scope.nowTime)
                    when 2
                      $scope.ngModel.startTime = $scope.nowTime
                      $scope.ngModel.endTime = +new Date()
                    when 3
                      $scope.ngModel.startTime = $scope.nowTime - 24*3600*1000
                      $scope.ngModel.endTime = $scope.nowTime
                    when 4
                      $scope.ngModel.startTime = $scope.nowTime - 2*24*3600*1000
                      $scope.ngModel.endTime = $scope.nowTime - 24*3600*1000
                    when 5
                      days = new Date().getDay() == 0 ? 7 : new Date().getDay()
                      $scope.ngModel.startTime = new Date($scope.nowTime) - 24*3600*1000 * (days - 1)
                      $scope.ngModel.endTime = +new Date()
                    when 6
                      days = new Date().getDay() == 0 ? 7 : new Date().getDay()
                      $scope.ngModel.startTime = new Date($scope.nowTime) - 24*3600*1000 * (days - 1) - 7*24*3600*1000
                      $scope.ngModel.endTime = new Date($scope.nowTime) - 24*3600*1000 * (days - 1)
                    when 7
                      days = new Date().getDate();
                      $scope.ngModel.startTime = $scope.nowTime - 24*3600*1000 * (days - 1)
                      $scope.ngModel.endTime = +new Date()
                    when 8
                      days = new Date().getDate();
                      days_up = new Date(+new Date($scope.nowTime - 24*3600*1000 * days) - 24*3600*1000).getDate()
                      $scope.ngModel.startTime = $scope.nowTime - 24*3600*1000 * (days_up + days)
                      $scope.ngModel.endTime = $scope.nowTime - 24*3600*1000 * (days - 1)
                    when 9
                      $scope.ngModel.startTime = $scope.nowTime - 3*24*3600*1000
                      $scope.ngModel.endTime = +new Date()
                    when 10
                      $scope.ngModel.startTime = $scope.nowTime - 7*24*3600*1000
                      $scope.ngModel.endTime = +new Date()
                    when 11
                      $scope.ngModel.startTime = $scope.nowTime - 30*24*3600*1000
                      $scope.ngModel.endTime = +new Date()
                    when 12
                      $scope.ngModel.startTime = $scope.nowTime - 90*24*3600*1000
                      $scope.ngModel.endTime = +new Date()
                    when 13
                      $scope.ngModel.startTime = $scope.nowTime - 365*24*3600*1000
                      $scope.ngModel.endTime = +new Date()


                  list = ['任意日期','今日','昨天','前天','本周','上周','本月','上月','过去三天','过去七天','最近一个月','最近三个月','最近一年']
                  for i in [1..list.length]
                    $scope.dateFilter_List = []
                    $scope.dateFilter_List.push({id:i,text:list[i-1]})
                  $scope.dateFilter = 1
                  $scope.getdateFilter()
        }
    ])
)
