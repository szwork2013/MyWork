var express = require('express');
var router = express.Router();

router.get('/me', function(req, res) {
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

router.post('/setting', function(req, res) {
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


router.get('/lock', function(req, res) {
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

router.post('/unlock', function(req, res) {

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

router.get('/promise',function(req,res){
    Promise.find({},function(err,docs){
        res.json(docs);
    });
})

router.post('/chpasswd', function(req, res) {
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

module.exports = router;