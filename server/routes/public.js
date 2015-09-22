var express = require('express');
var router = express.Router();

router.post('/authenticate', function(req, res) {
    User = req.db.User;
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
                req.session.user = user;
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

router.post('/signin', function(req, res) {
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

module.exports = router;