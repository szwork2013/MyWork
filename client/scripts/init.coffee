require.config({
    baseUrl: "scripts"
    paths: {
        "angular": "../bower_components/angular/angular.min"
        "async":"../bower_components/requirejs/as"
        "angularAMD": "../bower_components/angularAMD/angularAMD.min"
        "ngload":"../bower_components/angularAMD/ngload.min"
        "angular-route": "../bower_components/angular-route/angular-route.min"
        "angular-animate": "../bower_components/angular-animate/angular-animate.min"
        "angular-resource":"../bower_components/angular-resource/angular-resource.min"
        "jquery":"../bower_components/jquery/dist/jquery.min"
        "highcharts":"../bower_components/highcharts/highcharts"
        "highcharts-ng":"../bower_components/highcharts-ng/dist/highcharts-ng.min"
        "bootstrap":"../bower_components/angular-bootstrap/ui-bootstrap-tpls.min"
        "spinner":"../bower_components/jquery-spinner/dist/jquery.spinner.min"
        "slider":"../bower_components/seiyria-bootstrap-slider/dist/bootstrap-slider.min"
        "toastr":"../bower_components/toastr/toastr"
        "file-input":"../bower_components/bootstrap-file-input/bootstrap.file-input"
        "slimscroll":"../bower_components/jquery.slimscroll/jquery.slimscroll.min"
        "gauge":"../bower_components/gauge.js/dist/gauge.min"
        "rangy":"../bower_components/rangy/rangy-selectionsaverestore.min"
        "textAngular":"../bower_components/textAngular/dist/textAngular.min"
        "textAngular-sanitize":"../bower_components/textAngular/dist/textAngular-sanitize.min"
        "tag-input":"../bower_components/ng-tags-input/ng-tags-input.min"
        "ngInfiniteScroll":"../bower_components/ngInfiniteScroll/build/ng-infinite-scroll.min"
        "ngStorage":"../bower_components/ngstorage/ngStorage.min"
        "main":"shared/main"
        "logger":"UI/UIService"
        'promise':'user/promise'
        'datatable':'shared/datatable'
        'date':'element/date'
        'hightGallery':'../bower_components/lightgallery/dist/js/lightgallery.min'
        'hightGallery-thumbnail':'../bower_components/lightgallery/dist/js/lg-thumbnail.min'
    },
    shim: {
        "angular":["jquery"]
        "angularAMD": ["angular"]
        "angular-route": ["angular"]
        "angular-animate":['angular']
        "promise":['angular']
        'ngload': ['angularAMD']
        'bootstrap':['angular']
        'slimscroll':['jquery']
    },
    deps: ["app"]
})
