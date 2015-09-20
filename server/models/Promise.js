var mongoose     = require('mongoose');
var Schema       = mongoose.Schema;

var PromiseSchema   = new Schema({
    name:String,
    url: String,
    text: String,
    icon:String,
    show:{type:Boolean,default:true},
    wide:{type:Boolean,default:true},
});

module.exports = mongoose.model('Promise', PromiseSchema);
