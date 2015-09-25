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
