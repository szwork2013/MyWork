'use strict';
define(["app","common","angular-resource"],->
  [
    '$scope', '$filter','$resource','SiteConfig'
    ($scope, $filter,$resource,SiteConfig) ->
# filter
      $scope.stores=[]
      $scope.fieds = [
        {
          name:'name'
          text:'标识'
          type:'string'
          show:true
          link:false
        }
        {
          name:'url'
          text:'地址'
          type:'string'
          show:true
          link:false
        }
        {
          name:'text'
          text:'文本'
          type:'string'
          show:true
          link:false
        }
        {
          name:'show'
          text:'显示'
          type:'boolean'
          show:true
          link:false
        }
        {
          name:'icon'
          text:'图标'
          type:'string'
          show:true
          link:false
        }
        {
          name:'wide'
          text:'全屏展示'
          type:'boolean'
          show:true
          link:false
        }
      ]
      table = $resource('{domain}/user/promiseManager');
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
      $scope.numPerPageOpt = [5, 10, 20, 30]
      $scope.numPerPage = $scope.numPerPageOpt[1]
      $scope.currentPage = 1
      $scope.currentPageStores = []
      $scope.nextPre = ->
        $scope.currentPage = $scope.currentPage+1
        $scope.select($scope.currentPage)
      # init
      init = ->
        $scope.search()
      init()
  ])
