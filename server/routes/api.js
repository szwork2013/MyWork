var express = require('express');
var router = express.Router();
router.get('/label',function(req,res){
	req.db.Label.find({},function(err,docs){
		res.json(docs);
	});
});

router.get('/cat',function(req,res){
	req.db.Cat.find({},function(err,docs){
		res.json(docs);
	});
});

router.get('/product',function(req,res){
	var query = {condition:{},filter:{page:1,count:20}};
	if(isNaN(parseInt(req.query.count))==false){
		query.filter.count = req.query.count;
	}
	if(isNaN(parseInt(req.query.page))==false){
		query.filter.page = req.query.page;
	}
	if(req.query.cat != undefined){
		query.condition.cat = req.objectid(req.query.product);
	}
	if(req.query.keyword != undefined){
		query.condition.tag = req.query.keyword;
	}
	query.pageSize={};
	query.pageSize.limit = parseInt(query.filter.count);
	query.pageSize.skip = parseInt(query.filter.count)*(parseInt(query.filter.page)-1);
	req.db.Product.find(query.condition).skip(query.pageSize.skip).limit(query.pageSize.limit).exec(function(err,docs){
		res.json(docs);
	});
});


router.get('/detail',function(req,res){
	var query = {condition:{}};
	if(isNaN(parseInt(req.query.count))==false){
		query.filter.count = req.query.count;
	}
	if(isNaN(parseInt(req.query.page))==false){
		query.filter.page = req.query.page;
	}
	if(req.query.product != undefined){
		query.condition.product = req.objectid(req.query.product);
	}else{
		res.json({err:1001,message:'need product_id'});
	}
	req.db.Detail.find(query.condition).exec(function(err,docs){
		res.json(docs);
	});
});

module.exports = router;
