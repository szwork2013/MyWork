var mongoose     = require('mongoose');
var Schema       = mongoose.Schema;

var CatSchema   = new Schema({
	label:Object,
	link:String,
    title:String
});

module.exports = mongoose.model('Cat', CatSchema);