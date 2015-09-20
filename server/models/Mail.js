var mongoose     = require('mongoose');
var Schema       = mongoose.Schema;

var MailSchema   = new Schema({
    from:Object,
    cc:Object,
    to:Object,
    title:String,
    time: { type: Date, default: Date.now},
    mailContent:String,
    paperclip:{type:Boolean,default:false},
    starred:{type:Boolean,default:false},
    read:{type:Boolean,default:false},
    spam:{type:Boolean,default:false}
});

module.exports = mongoose.model('Mail', MailSchema);