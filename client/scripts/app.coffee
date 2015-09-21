define(['common'
        'shared/localize'
        'shared/directives'
        'shared/Nav'
        'UI/UIDirective'
        'main'
    ],
    (angularAMD)->
        app = angular.module('app', [
            'ngRoute'
            'ngAnimate'
            'ui.bootstrap'
            'ngStorage'
        ])
        .config([
              '$routeProvider','$httpProvider','$provide'
              ($routeProvider,$httpProvider,$provide) ->
                  routes = []
                  publicRouter = [
                      {name:'signin',url:'/user/signin',text:'登录',icon:'fa-pencil',show:true,wide:true}
                      {name:'signup',url:'/user/signup',text:'注册',icon:'fa-pencil',show:true,wide:true}
                      {name:'404',url:'/404',text:'错误页面',icon:'fa-pencil',show:true,wide:true}
                      {name:'500',url:'/500',text:'服务器错误',icon:'fa-pencil',show:false,wide:true}
                      {name:'blank',url:'/user/blank',text:'空白页',icon:'fa-pencil',show:false,wide:true}
                      {name:'forgot-password',url:'/user/forgot-password',text:'忘记密码',icon:'fa-pencil',show:true,wide:true}
                      {name:'lock-screen',url:'/user/lock-screen',text:'锁屏',icon:'fa-pencil',show:true,wide:true}
                      {name:'profile',url:'/user/profile',text:'个人配置',icon:'fa-pencil',show:true,wide:false}
                  ]

                  getRouter = (name)->
                      for item in publicRouter
                          if item.name is name
                              return item
                  setRoutes = (route) ->
                      url = route
                      config =
                          templateUrl: '/views' + route + '.html'
                          controllerUrl:'/scripts'+route+'.js'
                      $routeProvider.when(url, angularAMD.route(config))
                      return $routeProvider

                  initRouter = (ru)->
                    ru.forEach((route)->
                      setRoutes(route.url)
                    )
                    $routeProvider
                    .otherwise( redirectTo: ru[0].url )

                  initRouter(publicRouter)

                  $provide.factory('SiteConfig',->
                      {
                          route : routes
                          publicRouter:publicRouter
                          routerRoot:routes.concat(publicRouter)
                          domain:'http://192.168.1.106:3001',
                          getRouter:getRouter
                          setRoutes:setRoutes
                          gallery:{
                              product:'/api/gallery'
                          }
                          routeProvider:$routeProvider
                          initRouter:initRouter
                      }
                  )
                  #$locationProvider.html5Mode(true);
                  $httpProvider.interceptors.push([
                      '$q', '$location', '$localStorage'
                      ($q, $location, $localStorage)->
                          {
                          'request':(config)->
                              config.headers = config.headers or {}
                              if $localStorage.token
                                  config.headers.Authorization = 'Bearer ' + $localStorage.token
                              config
                          'responseError':(response)->
                              if response.status is 401 or response.status is 403 or response.status is 0
                                  $location.path(getRouter('signin').url)
                              if response.status is 423
                                  $location.path(getRouter('lock-screen').url)
                              $q.reject(response)
                          }
                  ])
        ])
        angularAMD.bootstrap(app)
)
