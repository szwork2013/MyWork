'use strict';
define(["app","common","datatable"],->
    [
        '$scope', '$filter'
        ($scope, $filter) ->
            $scope.config={}
            $scope.config.url = '{domain}/other/product'
            $scope.config.fields = [
                {
                    name:'title'
                    text:'标题'
                    type:'string'
                    show:true
                    link:false
                    sort:true
                    required:true
                }
                {
                    name:'tags'
                    text:'标签'
                    type:'tags'
                    show:true
                    link:false
                    sort:true
                    required:true
                }
                {
                    name:'time'
                    text:'日期'
                    type:'date'
                    show:true
                    link:false
                    sort:true
                    required:true
                }
            ]
            $scope.config.plus = {
                edit:true
                delete:true
            }
    ])
