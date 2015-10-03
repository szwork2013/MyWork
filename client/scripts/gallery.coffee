'use strict';
define(["app","common","angular-resource","hightGallery","hightGallery-thumbnail"],->
  [
    '$scope', '$filter','$http','$timeout'
    ($scope, $filter,$http,$timeout) ->
# filter
      $scope.config={}
      $scope.config.url = '{domain}/other/gallery'
      $scope.config.sizelist = [12,18,24,30]
      $scope.config.mainShow = true
      $scope.config.rangeid = +new Date
      $scope.config.viewDetail = (store)->
        $http.post('{domain}/other/detail',{product:store._id}).success(
            (detail)->
                dynamicEl = []
                for item in detail.data
                    dynamicEl.push({src:item.local,thumb:item.thumbnail_local})
                $('#'+$scope.config.rangeid).lightGallery(
                    {
                        dynamic: true
                        dynamicEl:dynamicEl
                    }
                )
                $scope.config.detailView = detail.data
                $scope.config.mainShow = false
        )
  ])
