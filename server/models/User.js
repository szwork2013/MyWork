var mongoose     = require('mongoose');
var Schema       = mongoose.Schema;

var UserSchema   = new Schema({
    realname:String,
    email: String,
    password: String,
    role:{type:String,default:'Admin'},
    lock:{type:Boolean,default:false},
    setting:{type:Object,default:{
        layout: 'wide',
        menu: 'vertical',
        fixedHeader: true,
        fixedSidebar: false,
        server:true,
        pageTransition: {
            name: 'Scale up',
            class: 'ainmate-scale-up'
        },
        lang:"中文"
    }},
    token: String,
    photo:{type:String,default:'/images/g1.jpg'},

});

module.exports = mongoose.model('User', UserSchema);