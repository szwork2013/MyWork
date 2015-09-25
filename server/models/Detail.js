var mongoose     = require('mongoose');
var Schema       = mongoose.Schema;

var DetailSchema   = new Schema({
    link:String,
    product:Object,
    thumbnail:String,
    remote:String,
    width:Number,
    thumbnail_local:String,
    local:String,
    height:Number
});

module.exports = mongoose.model('Detail', DetailSchema);