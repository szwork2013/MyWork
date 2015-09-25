'use strict';
define(["angularAMD"],(angularAMD)->
    angularAMD.publicRouter=[
        {name:'signin',url:'/user/signin',text:'登录',icon:'fa-pencil',show:true,wide:true}
        {name:'signup',url:'/user/signup',text:'注册',icon:'fa-pencil',show:true,wide:true}
        {name:'404',url:'/404',text:'错误页面',icon:'fa-pencil',show:true,wide:true}
        {name:'500',url:'/500',text:'服务器错误',icon:'fa-pencil',show:false,wide:true}
        {name:'blank',url:'/user/blank',text:'空白页',icon:'fa-pencil',show:false,wide:true}
        {name:'forgot-password',url:'/user/forgot-password',text:'忘记密码',icon:'fa-pencil',show:true,wide:true}
        {name:'lock-screen',url:'/user/lock-screen',text:'锁屏',icon:'fa-pencil',show:true,wide:true}
        {name:'profile',url:'/user/profile',text:'个人配置',icon:'fa-pencil',show:true,wide:false}
    ]
    angularAMD.authMethod = 'token'
    angularAMD.domian = 'http://localhost:3003'
    return angularAMD
)
