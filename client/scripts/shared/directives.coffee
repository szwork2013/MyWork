define(['angularAMD'],(angularAMD)->

    angularAMD.directive('imgHolder', [ ->
        return {
            restrict: 'A'
            link: (scope, ele, attrs) ->
                Holder.run(
                    images: ele[0]
                )
        }
    ])

    # switch stylesheet file
    .directive('uiColorSwitch', [ ->
        return {
            restrict: 'A'
            link: (scope, ele, attrs) ->
                ele.find('.color-option').on('click', (event)->
                    $this = $(this)
                    hrefUrl = undefined

                    style = $this.data('style')
                    if style is 'loulou'
                        hrefUrl = 'styles/main.css'
                        $('link[href^="styles/main"]').attr('href',hrefUrl)
                    else if style
                        style = '-' + style
                        hrefUrl = 'styles/main' + style + '.css'
                        $('link[href^="styles/main"]').attr('href',hrefUrl)
                    else
                        return false

                    event.preventDefault()
                )
        }
    ])
    # history back button
    .directive('goBack', [ ->
        return {
            restrict: "A"
            controller: [
                '$scope', '$element', '$window'
                ($scope, $element, $window) ->
                    $element.on('click', ->
                        $window.history.back()
                    )
            ]
        }
    ])
    # 时钟控件
    .directive('clockfusion', ['$interval', 'dateFilter'
        ($interval, dateFilter)->
            (scope, element, attrs)->
                format = 'y-M-d H:mm:ss'
                if attrs.clockfusion
                    format = attrs.clockfusion

                updateTime = ()->
                    element.text(dateFilter(new Date(),format))
                updateTime()
                stopTime = $interval(updateTime, 1000)
                element.on('$destroy',()->
                    $interval.cancel(stopTime)
                )
    ])

    .directive('natable',
        ()->
            {
                restrict: 'E'
                transclude: true,
                scope: { title:'@' }
                templateUrl:(elem, attr)->
                    return '/views/base-'+attr.type+'.html'
                link:(scope, element, attrs)->
                controller:($scope,$resource,SiteConfig,$attrs)->
                    $scope.fieds = [
                        {name:'title','text':'标题',type:'string',show:true,link:'link'}
                        {name:'link','text':'链接',type:'string',show:false,link:false}
                        {name:'thumbnail','text':'缩略图',type:'image',show:true,link:false}
                        {name:'time','text':'时间',type:'string',show:true,link:false}
                    ]
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
    #全屏功能
    # history back button
    .directive('fullscreen', [ ->
            return {
                restrict: "A"
                controller: [
                    '$scope', '$element','$document'
                    ($scope, $element,$document) ->
                        $element.on('click', ->
                            body =$document.find('#app')
                            if body.hasClass('body-wide')
                                body.removeClass('body-wide')
                            else
                                body.addClass('body-wide')
                        )
                ]
            }
    ])
)
