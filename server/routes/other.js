var express = require('express');
var router = express.Router();

router.get('/gallery',function(req,res){
    Product = req.db.Product;
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

module.exports = router;