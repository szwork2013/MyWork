'use strict';
define(['angularAMD'],(angularAMD)->
    # overall control
    angularAMD.controller('AppCtrl', [
        '$scope', '$rootScope','$location','$localStorage','$document','$element','$modal','Users','localize','SiteConfig'
        ($scope, $rootScope,$location,$localStorage,$document,$element,$modal,Users,localize,SiteConfig) ->
            $scope.main =
                brand: 'BotSite'
                name: 'Lisa Doe' # those which uses i18n directive can not be replaced for now.

            $scope.pageTransitionOpts = [
                name: 'Scale up'
                class: 'ainmate-scale-up'
            ,
                name: 'Fade up'
                class: 'animate-fade-up'
            ,
                name: 'Slide in from right'
                class: 'ainmate-slide-in-right'
            ,
                name: 'Flip Y'
                class: 'animate-flip-y'
            ]

            $scope.admin =
                lang:'中文'
                layout: 'wide'                                  # 'boxed', 'wide'
                menu: 'vertical'                                # 'horizontal', 'vertical'
                fixedHeader: true                               # true, false
                fixedSidebar: false                             # true, false
                pageTransition: $scope.pageTransitionOpts[0]    # unlimited, check out "_animation.scss"

            $scope.loadsetting =false;

            $scope.locationAction = ->
                lo = ''
                for item in $location.path().split('/')
                    out = []
                    if item is ''
                        out.push({text:'Home',link:'/'})
                    else
                        lo = lo+item
                        out.push({text:item,link:lo})
                    out
            settingRouter = (pro_res)->
                SiteConfig.initRouter(pro_res)
                $scope.route  = pro_res
                $scope.$broadcast('reload-nav',pro_res)
                SiteConfig.routeProvider
                .when('/', { redirectTo: pro_res[0].url} )
                .otherwise( redirectTo: '/404' )
                if path() is SiteConfig.getRouter('signin').url
                    $location.path('/')

            $scope.location = $scope.locationAction()

            $scope.reset = (res)->
                $scope.main = res
                $scope.main.brand = 'BotSite'
                $scope.loadsetting = true
                $scope.admin = res.data.setting
                $scope.setLang($scope.admin.lang)
                Users.promise(settingRouter,->console.log('promise error'))

            $scope.$on('reload-user',(event,res)->
                $scope.reset(res)
            )
            $scope.$on('location',(event,res)->
                $scope.location = $scope.locationAction()
            )
            $scope.logout = ->
                Users.logout(->
                    $location.path(SiteConfig.getRouter('signin').url )
                ,
                    ->
                )
            $scope.lock = ->
                Users.lock(->
                    $location.path(SiteConfig.getRouter('lock-screen').url)
                ,
                    ->$location.path(SiteConfig.getRouter('lock-screen').url)
                )
            $scope.changePassword = ->
                modalInstance = $modal.open(
                    templateUrl: "/views/user/ch-password.html"
                    controller: 'passwordCtrl'
                )
            $scope.start = ->
                Users.me((res)->
                    $scope.reset(res)
                ,
                    ->
                )
            pa = ->
            switch $location.path()
                when SiteConfig.getRouter('signup').url then pa()
                when SiteConfig.getRouter('forgot-password').url then pa()
                else $scope.start()


            $scope.savesetting = ->
                if $scope.admin.server is true
                    Users.setting($scope.admin,->
                        console.log('save Successfull...');
                    ,
                        ->console.log('oh no...')
                    )


            path = ->
                return $location.path()

            addBg = (path) ->
    # remove all the classes
                $element.removeClass('body-wide body-lock')

                # add certain class based on path
                for item in SiteConfig.routerRoot
                    if item.wide is true and path is item.url
                        $element.addClass('body-wide')
                        break

                switch path
                    when SiteConfig.getRouter('lock-screen').url then $element.addClass('body-wide body-lock')

            addBg( $location.path() )

            $scope.$watch(path, (newVal, oldVal) ->
                if newVal is oldVal
                    return
                $scope.locationAction()
                addBg($location.path())
            )
            $scope.getRouter = SiteConfig.getRouter

            $scope.$watch('admin', (newVal, oldVal) ->
                if newVal.menu is 'horizontal' && oldVal.menu is 'vertical'
                    $rootScope.$broadcast('nav:reset')
                    return $scope.savesetting()
                if newVal.fixedHeader is false && newVal.fixedSidebar is true
                    if oldVal.fixedHeader is false && oldVal.fixedSidebar is false
                        $scope.admin.fixedHeader = true
                        $scope.admin.fixedSidebar = true
                    if oldVal.fixedHeader is true && oldVal.fixedSidebar is true
                        $scope.admin.fixedHeader = false
                        $scope.admin.fixedSidebar = false
                    return $scope.savesetting()
                if newVal.fixedSidebar is true
                    $scope.admin.fixedHeader = true
                if newVal.fixedHeader is false
                    $scope.admin.fixedSidebar = false
                return $scope.savesetting()

                return
            , true)
            $scope.setLang = (lang) ->
                switch lang
                    when 'English' then localize.setLanguage('EN-US')
                    when 'Español' then localize.setLanguage('ES-ES')
                    when '日本語' then localize.setLanguage('JA-JP')
                    when '中文' then localize.setLanguage('ZH-TW')
                    when 'Deutsch' then localize.setLanguage('DE-DE')
                    when 'français' then localize.setLanguage('FR-FR')
                    when 'Italiano' then localize.setLanguage('IT-IT')
                    when 'Portugal' then localize.setLanguage('PT-BR')
                    when 'Русский язык' then localize.setLanguage('RU-RU')
                    when '한국어' then localize.setLanguage('KO-KR')
                $scope.admin.lang = lang
            $scope.getFlag = () ->
                lang = $scope.admin.lang
                switch lang
                    when 'English' then return 'flags-american'
                    when 'Español' then return 'flags-spain'
                    when '日本語' then return 'flags-japan'
                    when '中文' then return 'flags-china'
                    when 'Deutsch' then return 'flags-germany'
                    when 'français' then return 'flags-france'
                    when 'Italiano' then return 'flags-italy'
                    when 'Portugal' then return 'flags-portugal'
                    when 'Русский язык' then return 'flags-russia'
                    when '한국어' then return 'flags-korea'
            $scope.color =
                primary:    '#248AAF'
                success:    '#3CBC8D'
                info:       '#29B7D3'
                infoAlt:    '#666699'
                warning:    '#FAC552'
                danger:     '#E9422E'
            $scope.setLang($scope.admin.lang)

    ])
    .factory('Users', [
          '$http', '$localStorage','SiteConfig'
          ($http, $localStorage)->
              {
                  signup:(data, success, error)->
                      $http.post('{domain}/public/signup', data).success(success).error(error)
                  signin:(data, success, error)->
                      $http.post('{domain}/public/authenticate', data).success(success).error(error)
                  lock:(success, error)->
                      $http.get('{domain}/user/lock').success(success).error(error)
                  promise:(success,error)->
                      $http.get('{domain}/user/promise').success(success).error(error)
                  unlock:(data, success, error)->
                      $http.post('{domain}/user/unlock', data).success(success).error(error)
                  setting:(data, success, error)->
                      $http.post('{domain}/user/setting', data).success(success).error(error)
                  chpasswd:(data, success, error)->
                      $http.post('{domain}/user/chpasswd', data).success(success).error(error)
                  me:(success, error)->
                      $http.get('{domain}/user/me').success(success).error(error)
                  logout:(success,error)->
                      if SiteConfig.authMethod is 'token'
                        delete $localStorage.token
                      else
                          $http.get( '{domain}/user/logout').success(success).error(error)
                      success()
              }
      ])

    .controller('HeaderCtrl', [
        '$scope'
        ($scope) ->
    ])

    .controller('NavContainerCtrl', [
        '$scope'
        ($scope) ->
    ])
    .controller('NavCtrl', [
        '$scope','$rootScope', 'filterFilter','$location','$element'
        ($scope,$rootScope, filterFilter,$location,$element) ->
            $scope.nav = []
            $scope.$on('reload-nav',(event,res)->
                $scope.nav=res
            )
            $scope.local = $location.path()
            links = $element.find('a')
            path = () ->
                return $location.path()


            $scope.$watch(path, (newVal, oldVal) ->
                if newVal is oldVal
                    return
                #添加手机上自动缩合
                app = $('#app')
                app.removeClass('on-canvas')
                $scope.$emit('location',true)
                angular.forEach($element.find('a'),(link)->
                    $link = angular.element(link)
                    $li = $link.parent('li')
                    href = $link.attr('href')
                    if ($li.hasClass('active'))
                        $li.removeClass('active')
                    if href.indexOf($location.path()) > 0
                        $li.addClass('active')
                )
            )
    ])
    .controller('passwordCtrl',['$scope','$modalInstance','$interval','Users'
        ($scope,$modalInstance,$interval,Users)->
            $scope.cancel = ->
                $modalInstance.dismiss "cancel"
                return
            $scope.alert = {
                'type':'info'
                'show':false
                'message':'wall'
            }
            setMessage = (type,message,show)->
                $scope.alert.type=type
                $scope.alert.message=message
                $scope.alert.show = show
            time = 5
            startRelogin = (mess)->
                time = time-1
                $scope.alert.message = pubmessage+'，'+time+'秒后重新登录'
                if time is 0
                    window.location = '/'

            pubmessage = ''
            $scope.submit = ->
                Users.chpasswd($scope.user,(res)->
                    if res.type is true
                        type = 'success'
                        pubmessage = res.massage
                        $interval(startRelogin,1000)
                    else
                        type = 'danger'
                    setMessage(type,res.massage,true)
                ,()->
                    setMessage('danger','未知网络错误',true)
                )
    ])
    return angularAMD
)
