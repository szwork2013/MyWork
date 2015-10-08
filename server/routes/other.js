var express = require('express');
var router = express.Router();

router.get('/product',function(req,res){
    var Product = req.db.Product;
    var query = {start:0,end:20};
    if(parseInt(req.query.start)!=NaN){
        query.start = parseInt(req.query.start);
    }
    if(parseInt(req.query.end)!=NaN){
        query.end = parseInt(req.query.end);
    }
    query.condition={}
    if(req.query.search!=undefined) {
        query.condition = {$or:[{title:new RegExp(req.query.search)},{tags:req.query.search}]};
    }
    if(typeof req.query._id != 'undefined'){
        query.condition._id = req.objectid(req.query._id);
    }
    query.limit = query.end - query.start;
    Product.find(query.condition).count().exec(function(errs,count){
        Product.find(query.condition).skip(query.start).limit(query.limit).exec(function(err,docs){
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
});


router.post('/product',function(req,res){
    var query = {created:+new Date};
    if(typeof req.body._id != 'undefined'){
        query =  {_id:req.objectid(req.body._id)};
    }
    var Product = req.db.Product;
    Product.update(query,{$set:req.body},{upsert:true},function(err,docs){
        if(docs.nModified==0 && typeof docs.upserted != 'undefined'){
            req.body._id = docs.upserted[0]._id;
            return res.json({'type':true,method:'create','message':'新建成功',data:req.body});
        }
        res.json({'type':true,method:'modify','message':'修改成功',data:req.body});

    });
});

router.delete('/product',function(req,res){
    if(typeof req.query._id == 'undefined'){
        return res.sendStatus(201);
    }
    var query =  {_id:req.objectid(req.query._id)};
    var Product = req.db.Product;
    Product.remove(query).exec();
    res.json({'type':true,method:'delete','message':'删除成功!'});
});

router.post('/detail',function(req,res){
    var Detail = req.db.Detail;
    var query={condition:{}};
    if(typeof req.body.product=='undefined') {
        return res.json({type:false});
    }
    query.condition.product = req.objectid(req.body.product);
    Detail.find(query.condition).count().exec(function(errs,count){
        Detail.find(query.condition).exec(function(err,docs){
            res.json({
                type:true,
                data:docs,
                count:count
            })
        })
    })
});
module.exports = router;
