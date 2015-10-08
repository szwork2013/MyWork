'use strict';
define(["app","common","datatable","hightGallery","hightGallery-thumbnail","hightGallery-fullscreen"],->
    [
        '$scope', '$filter','$http'
        ($scope, $filter,$http) ->
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
                viewGallery:true
            }
            $scope.config.viewDetail = (store)->
                $http.post('{domain}/other/detail',{product:store._id}).success(
                    (detail)->
                        dynamicEl = []
                        for item in detail.data
                            dynamicEl.push(
                                {
                                    src:'http://218.5.112.56:3003/'+item.local,
                                    thumb:'http://218.5.112.56:3003/'+item.thumbnail_local
                                    subHtml:'<p>'+store.title+'</p>'+'<p>尺寸:'+item.width+'*'+item.height+'</p>'
                                }
                            )
                        $('#'+store._id).lightGallery(
                            {
                                loop:false
                                escKey:true
                                dynamic: true
                                hideBarsDelay:2000
                                dynamicEl:dynamicEl
                            }
                        )
                        $scope.config.detailView = detail.data
                )
    ])
