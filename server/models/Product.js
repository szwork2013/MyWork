var mongoose     = require('mongoose');
var Schema       = mongoose.Schema;

var ProductSchema   = new Schema({
    cat:Object,
    link:String,
    thumbnail:String,
    title:String,
    tags:Object,
    time:String
});

module.exports = mongoose.model('Product', ProductSchema);