// Required Modules
var express     = require("express"),
    morgan      = require("morgan"),
    bodyParser  = require("body-parser"),
    jwt = require("jsonwebtoken"),
    mongoose = require("mongoose"),
    session = require('express-session'),
    cookieParser = require('cookie-parser'),
    objectid = require('objectid'),
    RedisStore = require('connect-redis')(session);

var app        = express();
var token_verify = true;
port = 3003
var db = {
    User     : require('./models/User'),
    Product  : require('./models/Product'),
    Promise  : require('./models/Promise'),
    Label    : require('./models/Label'),
    Cat  	 : require('./models/Cat'),
    Detail   : require('./models/Detail')

}
// Connect to DB
mongoose.connect('mongodb://218.5.112.56/zhuoku');

var db_config = require('./config/database'),
    setting = require('./config/setting');

var route = {
    public : require('./routes/public'),
    other  : require('./routes/other'),
    user   : require('./routes/user'),
    api	   : require('./routes/api')
}

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(morgan("dev"));

if(token_verify==false) {
//启用Cookies
    app.use(cookieParser());
//针对manager 设置session  (以后启用用户系统全局使用)
    app.use(session({
        store: new RedisStore(db_config.redisSession),
        cookie: {maxAge: db_config.redisSession.ttl * 1000, httpOnly: false},
        name: "_angular_session",
        resave: false,
        saveUninitialized: true,
        secret: setting.cookieSecret
    }));
}
app.use(function(req, res, next) {
    req.db = db;
    req.objectid=objectid;
    req.jwt = jwt;
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type, Authorization');
    next();
});

app.use(express.static("../dist"));
//图片静态服务器
app.use('/images',express.static(__dirname + '/../../wallpaper/images'));

app.get("/", function(req, res) {
    res.sendFile("../dist/index.html");
});
var userInvalid = function(req, res, next) {
    //设置请求头
    if(req.method == 'OPTIONS'){
        return res.sendStatus(200);
    }
    var User = req.db.User;
    if(token_verify==true) {
        var bearerToken;
        var bearerHeader = req.headers["authorization"];
        if (typeof bearerHeader !== 'undefined') {
            var bearer = bearerHeader.split(" ");
            bearerToken = bearer[1];
            req.token = bearerToken;
            User.findOne({token: req.token}, function (err, user) {
                if (err != null || user == null) {
                    return res.send(403)
                }
                req.session = {user: user};
                next();
            });
        } else {
            return res.sendStatus(403)
        }
    }else {
        if (typeof req.session.user == 'undefined') {
            res.sendStatus(403);
        } else {
            next();
        }
    }

}


app.use('/public',route.public);
app.use('/api',route.api);
app.use('/user',userInvalid,route.user);
app.use('/other',userInvalid,route.other);
process.on('uncaughtException', function(err) {
    console.log(err);
});

// Start Server
app.listen(port, function () {
    console.log( "Express server listening on port " + port);
});
