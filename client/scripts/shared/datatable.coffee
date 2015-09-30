define(['angularAMD','angular-resource','logger'],(angularAMD)->
  angularAMD.directive('datatable',
    ()->
      {
        restrict: 'EAC'
        transclude: true,
        scope: {
          datatable: '='
        }
        templateUrl:(elem, attr)->
          return '/views/table/base-'+attr.type+'.html'
        link:(scope, element, attrs)->
        controller:($scope,$resource,$attrs)->
          $scope.fields = angular.copy($scope.datatable.fields)
          $scope.stores=[]
          table = $resource($scope.datatable.url)
          $scope.searchKeywords = ''
          $scope.filteredStores = []
          $scope.row = ''

          if typeof $scope.datatable.plus isnt 'undefined'
            $scope.fields.push({
                name:'edit'
                text:'操作'
                type:'edit'
                show:true
                link:false
                sort:false
            })

          $scope.select = (page) ->
            start = (page - 1) * $scope.numPerPage
            end = start + $scope.numPerPage
            query = {start:start,end:end}
            if $scope.searchKeywords isnt ''
              query.search = $scope.searchKeywords
            if $scope.row isnt ''
              query.order = $scope.row
            store = table.get(query,->
              $scope.currentPageStores = store.data
              $scope.currentPageCount = store.count
            )
          # on page change: change numPerPage, filtering string
          $scope.onFilterChange = ->
            $scope.currentPage = 1
            $scope.row = ''
            $scope.select($scope.currentPage)
          $scope.onNumPerPageChange = ->
            $scope.select(1)
            $scope.currentPage = 1
          $scope.onOrderChange = ->
            $scope.currentPage = 1
            $scope.select($scope.currentPage)
          $scope.search = ->
            $scope.currentPageStores=[]
            $scope.onFilterChange()
          # orderBy
          $scope.order = (rowName)->
            if $scope.row == rowName
              return
            $scope.row = rowName
            $scope.onOrderChange()
          # pagination
          $scope.$on('remove',(event,index)->
            $scope.currentPageStores.splice(index)
          )
          if typeof $scope.datatable.sizelist is 'undefined'
            $scope.numPerPageOpt = [3, 6, 9, 12]
          else
            $scope.numPerPageOpt = $scope.datatable.sizelist
          $scope.numPerPage = $scope.numPerPageOpt[1]
          $scope.currentPage = 1
          $scope.currentPageStores = []
          # init
          init = ->
            $scope.search()
          init()
      }
    )
  .directive('edittable',
    ()->
      {
        restrict: 'EAC'
        require:'ngModel'
        scope: {
          edittable: '='
          ngModel:'='
        }
        link:(scope, element, attrs, ngModel,controller)->
        controller:['$scope','$element','$modal','logger','$resource'
            ($scope,$element,$modal,logger,$resource)->
              $element.on('click',()->
                modalInstance = $modal.open(
                  templateUrl:"/views/edit/base-"+$element.attr('type')+".html"
                  controller: $element.attr('type')+'EditCtrl'
                  size: 'lg'
                  resolve: {
                    item: ()->
                      {
                        fields:$scope.edittable
                        store:$scope.ngModel
                      }
                  }
                )
                modalInstance.result.then ((res) ->
                  if res.seccuss is true
                    logger.logSuccess('保存成功!')
                  return
                )
              )
        ]
      }
  ).directive('deltable',
    ()->
      {
      restrict: 'EAC'
      require:'ngModel'
      scope: {
        ngModel:'='
        topindex:'@'
      }
      link:(scope, element, attrs, ngModel,controller)->
      controller:['$scope','$element','$modal','logger','$resource'
        ($scope,$element,$modal,logger,$resource)->
          $element.on('click',()->
            modalInstance = $modal.open(
              templateUrl:"/views/edit/base-"+$element.attr('type')+".html"
              controller: $element.attr('type')+'Ctrl'
              resolve: {
                item: ()->
                  {
                    store:$scope.ngModel
                  }
              }
            )
            modalInstance.result.then ((res) ->
              $scope.$emit('remove',$scope.topindex)
              logger.logSuccess('保存成功!')
              return
            )
          )
      ]
      }
  ).controller('tableEditCtrl',[
      '$scope','$modalInstance','item','$resource'
      ($scope,$modalInstance,item,$resource)->
        $scope.fields = item.fields
        Source = $resource('{domain}/user/promise')
        Source.get({_id:item.store._id}, (docs)->
          $scope.store = docs
        )
        $scope.cancel = ->
          $modalInstance.dismiss "cancel"
          return

        $scope.submitForm = ->
          store = $scope.store.toJSON()
          $scope.store.$save((res,header)->
            res = res.toJSON()
            if res.seccuss is true
              for key,value of store
                  item.store[key] = value
            $modalInstance.close res
          )
          return
  ]).controller('confirmCtrl',[
    '$scope','$modalInstance','item','$resource'
    ($scope,$modalInstance,item,$resource)->
      $scope.fields = item.fields
      Source = $resource('{domain}/user/promise',{},{remove: {method:'DELETE', params:{_id:'@_id'}}})
      Source.get({_id:item.store._id}, (docs)->
        $scope.store = docs
      )
      $scope.cancel = ->
        $modalInstance.dismiss "cancel"
        return
      $scope.submitForm = ->
        store = $scope.store.toJSON()
        $scope.store.$remove((res,header)->
          res = res.toJSON()
          $modalInstance.close store
        )
        return
  ])
)

