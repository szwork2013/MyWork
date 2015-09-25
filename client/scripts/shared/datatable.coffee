define(['angularAMD','angular-resource'],(angularAMD)->
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
        $scope.fields = $scope.datatable.fields
        $scope.stores=[]
        table = $resource($scope.datatable.url)
        $scope.searchKeywords = ''
        $scope.filteredStores = []
        $scope.row = ''
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
        $scope.numPerPageOpt = [3, 6, 9, 12]
        $scope.numPerPage = $scope.numPerPageOpt[2]
        $scope.currentPage = 1
        $scope.currentPageStores = []
        # init
        init = ->
          $scope.search()
        init()
      }
    )
)