define(['angularAMD'],(angularAMD)->
    'use strict'
    # English, Español, 日本語, 中文, Deutsch, français, Italiano, Portugal, Русский язык, 한국어
    # English:          EN-US
    # Spanish:          Español ES-ES
    # Japanese:         日本語 JA-JP
    # Chinese:          简体中文 ZH-CN
    # Chinese:          繁体中文 ZH-TW
    # German:           Deutsch DE-DE
    # French:           français FR-FR
    # Italian:          Italiano IT-IT
    # Portugal:         Portugal PT-BR
    # Russian:          Русский язык RU-RU
    # Korean:           한국어 KO-KR

    # thanks for the icons: https://www.iconfinder.com/search/?q=iconset%3Aflags_gosquared

    angularAMD.factory('localize', [
        '$http', '$rootScope', '$window'
        ($http, $rootScope, $window) ->
            localize =
                language: ''                    # use the $window service to get the language of the user's browser
                url: undefined                  # location of the resource file
                resourceFileLoaded: false       # flag to indicate if the service has loaded the resource file

                successCallback: (data) ->
                    localize.dictionary = data
                    localize.resourceFileLoaded = true
                    $rootScope.$broadcast('localizeResourcesUpdated')

                setLanguage: (value) ->
                    localize.language = value.toLowerCase().split("-")[0]
                    localize.initLocalizedResources()

                setUrl: (value) ->
                    localize.url = value
                    localize.initLocalizedResources()

                buildUrl: ->
                    if !localize.language
                        # window.navigator.userLanguage is IE only, and window.navigator.language for the rest.
                        localize.language = ($window.navigator.userLanguage || $window.navigator.language).toLowerCase()
                        localize.language = localize.language.split("-")[0] # get just the language for now
                    return '/i18n/resources-locale_' + localize.language + '.js'

                # loads the language resource file from the server
                initLocalizedResources: ->
                    url = localize.url || localize.buildUrl()

                    $http( { method: "GET", url: url, cache: false } )
                    .success( localize.successCallback )
                    .error( ->
                        $rootScope.$broadcast('localizeResourcesUpdated')
                    )

                getLocalizedString: (value) ->
                    result = undefined
                    if (localize.dictionary && value)
                        valueLowerCase = value.toLowerCase()
                        if localize.dictionary[valueLowerCase] is ''
                            result = value
                        else
                            result = localize.dictionary[valueLowerCase]
                    else
                        result = value

                    return result

            # localize on init, for auto l18n and l10n
            # localize.initLocalizedResources()

            return localize
    ])

    # filter will be called on and on, so directive is preferred
    # .filter('i18n', [
    #     'localize'
    #     (localize) ->
    #         return (input) ->
    #             return localize.getLocalizedString(input)
    # ])

    .directive('i18n', [
        'localize'
        (localize) ->
            i18nDirective =
                restrict: "EA"
                updateText: (ele, input, placeholder) ->
                    result = undefined

                    if input is 'i18n-placeholder'
                        result = localize.getLocalizedString(placeholder)
                        ele.attr('placeholder', result)
                    else if input.length >= 1
                        result = localize.getLocalizedString(input)
                        ele.text(result)

                link: (scope, ele, attrs) ->
                    scope.$on('localizeResourcesUpdated', ->
                        i18nDirective.updateText(ele, attrs.i18n, attrs.placeholder)
                    )

                    attrs.$observe('i18n', (value) ->
                        i18nDirective.updateText(ele, value, attrs.placeholder)
                    )

            return i18nDirective
    ])

)