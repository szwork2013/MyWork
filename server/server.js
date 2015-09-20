// Required Modules
var express    = require("express");
var morgan     = require("morgan");
var bodyParser = require("body-parser");
var jwt        = require("jsonwebtoken");
var mongoose   = require("mongoose");
var app        = express();

var port = process.env.PORT || 3001;
var User     = require('./models/User');
var Mail     = require('./models/Mail');
var Product  = require('./models/Product');
var Promise  = require('./models/Promise');
// Connect to DB
mongoose.connect('mongodb://localhost/zhuoku');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(morgan("dev"));

app.use(express.static("../dist"));
app.get("/", function(req, res) {
    res.sendFile("../dist/index.html");
});

app.use(function(req, res, next) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST');
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type, Authorization');
    next();
});

app.get('/api/gallery',ensureAuthorized,function(req,res){
    var query = {start:0,end:20};
    if(parseInt(req.query.start)!=NaN){
        query.start = parseInt(req.query.start);
    }

    if(parseInt(req.query.end)!=NaN){
        query.end = parseInt(req.query.end);
    }
    query.condition={}
    if(req.query.search!=undefined) {
        query.condition = {title:new RegExp(req.query.search)};
    }

    query.limit = query.end - query.start;

    Product.find(query.condition).count().exec(function(errs,count){
        Product.find(query.condition).skip(query.start).limit(query.limit).exec(function(err,docs){
            res.json({
                type:true,
                data:docs,
                count:count
            })
        })
    })
});

app.post('/authenticate', function(req, res) {
    if(req.body.email==undefined || req.body.password==undefined){
        return res.json({
            type: false,
            data: "Need Field"
        });
    }
    User.findOne({email: req.body.email, password: req.body.password}, function(err, user) {
        if (err) {
            res.json({
                type: false,
                data: "Error occured: " + err
            });
        } else {
            if (user) {
                user.password=null;
               res.json({
                    type: true,
                    data: user,
                    token: user.token
                });
            } else {
                res.json({
                    type: false,
                    data: "Incorrect email/password"
                });
            }
        }
    });
});

app.post('/chpasswd', ensureAuthorized, function(req, res) {
    err = function(){
        res.json({type:false,massage:' 输入错误'});
    }
    if(typeof req.body.oldpassword == 'undefined' || typeof req.body.password == 'undefined'){
        return err();
    }

    if(typeof req.body.oldpassword.length <6 || typeof req.body.password.length <6){
        return err();
    }

    User.findOne({token: req.token,password:req.body.oldpassword}, function(err, user) {

        if (err) {
            res.json({
                type: false,
                data: "Error occured: " + err
            });
        } else {
            if(user==null){
                return res.json({type:false,massage:'原密码错误'});
            }
            user.password = req.body.password;
            user.token = jwt.sign(user, 'sdf1as5f4asdf46as5d4f65as4df65s4ad6f');
            user.save(function(er,ur){
                if(er==null){
                    res.json({type:true,massage:'密码已更改'});
                }else{
                    err()
                }
            });
        }
    })
})

app.post('/signin', function(req, res) {

    User.findOne({email: req.body.email}, function(err, user) {
        if (err) {
            res.json({
                type: false,
                data: "Error occured: " + err
            });
        } else {
            if (user) {
                res.json({
                    type: false,
                    data: "User already exists!"
                });
            } else {

                var userModel = new User();
                userModel.email = req.body.email;
                userModel.password = req.body.password;
                userModel.realname=req.body.realname;
                userModel.save(function(err, user) {
                    user.token = jwt.sign(user, 'sdf1as5f4asdf46as5d4f65as4df65s4ad6f');
                    user.save(function(err, user1) {
                        user1.password=null;
                        res.json({
                            type: true,
                            data: user1,
                            token: user1.token
                        });
                    });
                })
            }
        }
    });
});

app.get('/me', ensureAuthorized, function(req, res) {
    User.findOne({token: req.token}, function(err, user) {
        if (err) {
            res.json({
                type: false,
                data: "Error occured: " + err
            });
        } else {
            if(user==null)return res.send(403)
            user.password=null;
            if(user.lock == true) {
                res.sendStatus(423)
            }
            res.json({
                type: true,
                data: user
            });
        }
    });
});

app.post('/setting', ensureAuthorized, function(req, res) {
    User.findOne({token: req.token}, function(err, user) {
        if (err) {
            res.json({
                type: false,
                data: "Error occured: " + err
            });
        } else {
            User.update({token: req.token},{$set:{'setting':req.body}},{},function(err,docs){
                res.json('seccuss');
            });
        }
    })
})


app.get('/lock', ensureAuthorized, function(req, res) {
    User.findOne({token: req.token}, function(err, user) {
        if (err) {
            res.json({
                type: false,
                data: "Error occured: " + err
            });
        } else {
            User.update({token: req.token},{$set:{'lock':true}},{},function(err,docs){
                res.send(423);
            });
        }
    })
})

app.post('/sendmail',ensureAuthorized,function(req,res){
    User.findOne({email:req.body.to},function(err,touser){
        if(touser==null){
            return res.json({
                type:false,
                data:req.body.to+' No Email ...'
            })
        }

        var mailModel = new Mail();
        mailModel.to = {_id:touser.id,realname:touser.realname,email:touser.email};
        mailModel.from = {_id:req.user.id,realname:req.user.realname,email:req.user.email};
        mailModel.title = req.body.title;
        mailModel.mailContent = req.body.mailContent;
        mailModel.save(function(err, mail) {
            if(err==null){
                res.json({
                    type:true,
                    data:"success"
                })
            }
        })

    });
});

app.post('/inbox',ensureAuthorized,function(req,res){
    var query = {'to._id':req.user._id.toString()};
    if(typeof req.body.type == 'undefined'){
        req.body.type = 'all';
    }

    if(req.body.type == 'new'){
        query.read = false;
    }

    if(req.body.type == 'send'){
        query = {'from._id':req.user._id.toString()};
    }


    Mail.find(query,function(err,maillist){
        res.json({
            type:true,
            data:maillist
        })
    })
});


app.post('/single',ensureAuthorized,function(req,res){
    Mail.findOne({'_id':mongoose.Types.ObjectId(req.body._id),'$or':[{'to._id':req.user._id.toString()},{'from._id':req.user._id.toString()}]},function(err,singleMail){
        if(req.user._id.toString()==singleMail.to._id){
            Mail.update({'_id':mongoose.Types.ObjectId(req.body._id)},{$set:{read:true}},function(err,docs){});
        }
        res.json({
            type:true,
            data:singleMail
        })
    })
});

app.post('/unlock', ensureAuthorized, function(req, res) {

    User.findOne({token: req.token,password:req.body.password}, function(err, user) {
        if (err) {
            res.json({
                type: false,
                data: "Error occured: " + err
            });
        } else {
            if(user==null){
                return res.json({
                    type: false,
                    data: "Password is Wrong!!!"
                });
            }
            User.update({token: req.token},{$set:{'lock':false}},{},function(err,docs){
                res.send(200);
            });
        }
    })
})

app.get('/promise',function(req,res){
    Promise.find({},function(err,docs){
        res.json(docs);
    });
})

function ensureAuthorized(req, res, next) {
    var bearerToken;
    var bearerHeader = req.headers["authorization"];
    if (typeof bearerHeader !== 'undefined') {
        var bearer = bearerHeader.split(" ");
        bearerToken = bearer[1];
        req.token = bearerToken;
        User.findOne({token:req.token},function(err,user){
            if(err!=null || user==null){
                return res.send(403)
            }
            req.user=user;
            next();
        });
    } else {
        res.sendStatus(403)
    }
}



process.on('uncaughtException', function(err) {
    console.log(err);
});

// Start Server
app.listen(port, function () {
    console.log( "Express server listening on port " + port);
});
