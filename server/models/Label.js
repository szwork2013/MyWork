var mongoose     = require('mongoose');
var Schema       = mongoose.Schema;

var LabelSchema   = new Schema({
	link:String,
    title:String
});

module.exports = mongoose.model('Label', LabelSchema);