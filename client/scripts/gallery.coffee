'use strict';
define(["app","common","angular-resource"],->
  [
    '$scope', '$filter','$resource','SiteConfig'
    ($scope, $filter,$resource,SiteConfig) ->
# filter
      $scope.config={}
      $scope.config.url = '{domain}/other/gallery'
      $scope.config.sizelist = [12,18,24,30]

  ])
