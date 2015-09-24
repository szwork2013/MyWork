define(['common'
        'config'
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
                  publicRouter = angularAMD.publicRouter
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
                          domain:angularAMD.domian,
                          getRouter:getRouter
                          setRoutes:setRoutes
                          gallery:{
                              product:'/other/gallery'
                          }
                          routeProvider:$routeProvider
                          initRouter:initRouter
                          authMethod:angularAMD.authMethod
                      }
                  )
                  #$locationProvider.html5Mode(true);
                  $httpProvider.interceptors.push([
                      '$q', '$location', '$localStorage'
                      ($q, $location, $localStorage)->
                          {
                          'request':(config)->
                              config.headers = config.headers or {}
                              if $localStorage.token && angularAMD.authMethod is 'token'
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
