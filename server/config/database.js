var db_config =  {};

db_config.mongodb = {
    "host":"localhost",
    "port":27017,
    "database":"desktop"
}

db_config.mysql = {
    "host":"localhost",
    "port":3306,
    "database":"desktop",
    "user":"root",
    "password":"root1234"
}

db_config.redis = {
    "host":"localhost",
    "port":6379,
    "prefix":"colors",
    "opts":{},
    "enable":true,
    "expire":60000 //-1:永久驻留，>0 以秒为单位
}

db_config.redisSession={						//redis Session数据链接,链接失败则使用内存session
    host: "localhost",							//主机
    port: 6379,									//端口
    ttl:604800,									//超时设置,秒为单位 （7天）
    prefix:'desktop_session:',					//前缀
}

module.exports = db_config;