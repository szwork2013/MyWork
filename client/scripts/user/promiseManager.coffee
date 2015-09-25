'use strict';
define(["app","common","datatable"],->
  [
    '$scope', '$filter'
    ($scope, $filter) ->
      $scope.config={}
      $scope.config.url = '{domain}/user/promiseManager'
      $scope.config.fields = [
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
  ])
