// Required Modules
var express     = require("express"),
    morgan      = require("morgan"),
    bodyParser  = require("body-parser"),
    jwt = require("jsonwebtoken"),
    mongoose = require("mongoose"),
    session = require('express-session'),
    cookieParser = require('cookie-parser'),
    RedisStore = require('connect-redis')(session);

var app        = express();
port = 3001
var db = {
    User     : require('./models/User'),
    Mail     : require('./models/Mail'),
    Product  : require('./models/Product'),
    Promise  : require('./models/Promise')
}
// Connect to DB
mongoose.connect('mongodb://localhost/zhuoku');

var db_config = require('./config/database'),
    setting = require('./config/setting');

var route = {
    public : require('./routes/public'),
    other  : require('./routes/other'),
    user   : require('./routes/user')
}

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(morgan("dev"));


//启用Cookies
app.use(cookieParser());

//针对manager 设置session  (以后启用用户系统全局使用)
app.use(session({
    store: new RedisStore(db_config.redisSession),
    cookie:{maxAge: db_config.redisSession.ttl*1000, httpOnly: true},
    name:"_angular_session",
    resave:false,
    saveUninitialized:true,
    secret: setting.cookieSecret
}));

app.use(function(req, res, next) {
    req.db = db;
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST');
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type, Authorization');
    res.set({"X-Powered-By":"Gsion"});
    next();
});

app.use(express.static("../dist"));
app.get("/", function(req, res) {
    res.sendFile("../dist/index.html");
});


var tokenInvalid = function(req, res, next) {
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

var cookieInvalid = function(req,res,next){
    if(typeof req.session.user == 'undefined'){
        res.sendStatus(403);
    }else{
        next();
    }
}

app.use('/public',route.public);
app.use('/user',cookieInvalid,route.user);
app.use('/other',cookieInvalid,route.other);
process.on('uncaughtException', function(err) {
    console.log(err);
});

// Start Server
app.listen(port, function () {
    console.log( "Express server listening on port " + port);
});
