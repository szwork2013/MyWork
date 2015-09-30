'use strict';
define(["app","common","datatable","date"],->
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
          sort:true
        }
        {
          name:'url'
          text:'地址'
          type:'string'
          show:true
          link:false
          sort:true
        }
        {
          name:'text'
          text:'文本'
          type:'string'
          show:true
          link:false
          sort:false
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
          type:'icon'
          show:true
          link:false
          sort:false
        }
        {
          name:'wide'
          text:'全屏展示'
          type:'boolean'
          show:true
          link:false
          sort:true
        }
      ]
      $scope.config.plus = {
        edit:true
        delete:true
      }
  ])
