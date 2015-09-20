'use strict';
define(['angularAMD'],(angularAMD)->


    # swtich for mini style NAV, realted to 'collapseNav' directive
      angularAMD.directive('toggleNavCollapsedMin', [
        '$rootScope'
        ($rootScope) ->
            return {
                restrict: 'A'
                link: (scope, ele, attrs) ->
                    app = $('#app')

                    ele.on('click', (e) ->
                        if app.hasClass('nav-collapsed-min')
                            app.removeClass('nav-collapsed-min')
                        else
                            app.addClass('nav-collapsed-min')
                            $rootScope.$broadcast('nav:reset')

                        e.preventDefault()
                    )
            }
    ])
        # for accordion/collapse style NAV
        .directive('collapseNav', [ ->
            return {
                restrict: 'A'
                link: (scope, ele, attrs) ->
                    $window = $(window)
                    $lists = ele.find('ul').parent('li') # only target li that has sub ul
                    $lists.append('<i class="fa fa-angle-down icon-has-ul-h"></i><i class="fa fa-angle-right icon-has-ul"></i>')
                    $a = $lists.children('a')
                    $listsRest = ele.children('li').not($lists)
                    $aRest = $listsRest.children('a')

                    $app = $('#app')
                    $nav = $('#nav-container')

                    $a.on('click', (event) ->

                        # disable click event when Nav is mini style || DESKTOP horizontal nav
                        if ( $app.hasClass('nav-collapsed-min') || ($nav.hasClass('nav-horizontal') && $window.width() >= 768) ) then return false

                        $this = $(this)
                        $parent = $this.parent('li')
                        $lists.not( $parent ).removeClass('open').find('ul').slideUp()
                        $parent.toggleClass('open').find('ul').slideToggle()

                        event.preventDefault()
                    )

                    $aRest.on('click', (event) ->
                        $lists.removeClass('open').find('ul').slideUp()
                    )

                    # reset NAV, sub Ul should slideUp
                    scope.$on('nav:reset', (event) ->
                        $lists.removeClass('open').find('ul').slideUp()
                    )

                    # removeClass('nav-collapsed-min') when size < $screen-sm
                    # reset Nav when go from mobile to horizontal Nav
                    Timer = undefined
                    prevWidth = $window.width()
                    updateClass = ->
                        currentWidth = $window.width()
                        # console.log('prevWidth: ' + prevWidth)
                        # console.log('currentWidth: ' + currentWidth)
                        if currentWidth < 768 then $app.removeClass('nav-collapsed-min')
                        if prevWidth < 768 && currentWidth >= 768 && $nav.hasClass('nav-horizontal')
                            # reset NAV, sub Ul should slideUp
                            $lists.removeClass('open').find('ul').slideUp()

                        prevWidth = currentWidth


                    $window.resize( () ->
                        clearTimeout(t)
                        t = setTimeout(updateClass, 300)
                    )

            }
        ])
        # toggle on-canvas for small screen, with CSS
        .directive('toggleOffCanvas', [ ->
            return {
                restrict: 'A'
                link: (scope, ele, attrs) ->
                    ele.on('click', ->
                        $('#app').toggleClass('on-canvas')
                    )
            }
        ])
)
