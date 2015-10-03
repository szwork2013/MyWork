var express = require('express');
var router = express.Router();

router.get('/me', function(req, res) {
    var user = req.session.user;
    if(user.lock == true) {
        res.sendStatus(423)
    }
    res.json({
        type: true,
        data: user
    });
});

router.post('/setting', function(req, res) {
    var user = req.session.user;
    var User =  req.db.User;
    user.setting = req.body;
    User.update({_id: user._id},{$set:{'setting':req.body}},{},function(err,docs){
        res.json('seccuss');
    });
})


router.get('/lock', function(req, res) {
    var User =  req.db.User;
    var user = req.session.user;
    User.update({_id: user._id},{$set:{'lock':true}},{},function(err,docs){
        res.send(423);
    });
})

router.post('/unlock', function(req, res) {
    var User =  req.db.User;
    var user = req.session.user;
    User.findOne({_id: user._id,password:req.body.password}, function(err, user) {
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
            User.update({_id: user._id},{$set:{'lock':false}},{},function(err,docs){
                res.send(200);
            });
        }
    })
})

router.get('/promise',function(req,res){
    var Promise = req.db.Promise;
    var query = {start:0,end:20};
    if(parseInt(req.query.start)!=NaN){
        query.start = parseInt(req.query.start);
    }

    if(parseInt(req.query.end)!=NaN){
        query.end = parseInt(req.query.end);
    }
    query.condition={}

    if(typeof req.query._id != 'undefined'){
        query.condition._id = req.objectid(req.query._id);
    }

    if(req.query.search!=undefined) {
        query.condition = {text:new RegExp(req.query.search)};
    }
    query.limit = query.end - query.start;
    Promise.find(query.condition).count().exec(function(errs,count){
        Promise.find(query.condition).skip(query.start).limit(query.limit).exec(function(err,docs){
            if(typeof query.condition._id != 'undefined'){
                return res.json(docs[0])
            }
            res.json({
                type:true,
                data:docs,
                count:count
            })
        })
    })
})

router.post('/promise',function(req,res){
    var query = {created:+new Date};
    if(typeof req.body._id != 'undefined'){
        query =  {_id:req.objectid(req.body._id)};
    }
    var Promise = req.db.Promise;
    Promise.update(query,{$set:req.body},{upsert:true},function(err,docs){
        if(docs.nModified==0 && typeof docs.upserted != 'undefined'){
            req.body._id = docs.upserted[0]._id;
            return res.json({'type':true,method:'create','message':'新建成功',data:req.body});
        }
        res.json({'type':true,method:'modify','message':'修改成功',data:req.body});

    });
});

router.delete('/promise',function(req,res){
    if(typeof req.query._id == 'undefined'){
        return res.sendStatus(201);
    }
    var query =  {_id:req.objectid(req.query._id)};
    var Promise = req.db.Promise;
    Promise.remove(query).exec();
    res.json({'type':true,method:'delete','message':'删除成功!'});
});

router.post('/chpasswd', function(req, res) {
    var User = req.db.User;
    var user = req.session.user;
    err = function(){
        res.json({type:false,massage:' 输入错误'});
    }
    if(typeof req.body.oldpassword == 'undefined' || typeof req.body.password == 'undefined'){
        return err();
    }
    if(typeof req.body.oldpassword.length <6 || typeof req.body.password.length <6){
        return err();
    }
    User.findOne({_id: user._id,password:req.body.oldpassword}, function(err, user) {

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
            //user.token = jwt.sign(user, 'sdf1as5f4asdf46as5d4f65as4df65s4ad6f');
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

router.get('/logout',function(req,res){
    delete req.session.user;
    res.sendStatus(200);
})

module.exports = router;
