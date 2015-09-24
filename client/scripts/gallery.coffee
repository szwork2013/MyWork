'use strict';
define(["app","common","angular-resource"],->
  [
    '$scope', '$filter','$resource','SiteConfig'
    ($scope, $filter,$resource,SiteConfig) ->
# filter
      $scope.stores=[]
      table = $resource(SiteConfig.domain+SiteConfig.gallery.product)
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
      $scope.numPerPageOpt = [12, 18, 24, 30]
      $scope.numPerPage = $scope.numPerPageOpt[3]
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
