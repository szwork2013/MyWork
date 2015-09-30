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
                modalInstance.result.then ((store) ->
                  Source = $resource('{domain}/user/promise');
                  Source.get({_id:store._id}, (docs)->
                      docs.abc = true
                      docs.$save()
                  );
                  return
                )
              )
        ]
      }
  ).controller('tableEditCtrl',[
      '$scope','$modalInstance','item'
      ($scope,$modalInstance,item)->
        $scope.fields = item.fields
        $scope.store = item.store
        $scope.cancel = ->
          $modalInstance.dismiss "cancel"
          return
        $scope.submitForm = ->
          $modalInstance.close $scope.store
          return
  ])
)