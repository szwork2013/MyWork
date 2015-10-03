var express = require('express');
var router = express.Router();

router.get('/gallery',function(req,res){
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
