# elasticsearch-cdh-parcels
elasticsearch7.9 cdh-ext-parcels and single machine multi instance

# es7.9 parcels安装包

## 角色分配
> master/data/ingest/customer
> 该安装包支持单机多实例部署，分为四类节点[主节点,数据节点，协调节点，自定义节点]

## 使用方式

### 一键安装
> /bin/bash install -d /opt/cloudera -t all -u true 

## 参数解释
> -d 为cdh主节点本地源的父目录

> -t 为安装类型[csd,parcel,all],csd是将escsd安装到cdh中，需要重启cloudera-scm-server，parcel是将parcel安装到cdh集群中，不需要重启，all是将整个es包安装到cdh中

> -u [true/false] 是否对parcels包进行更新，true适用于更改了配置，需要打包，false则用之前的缓存包更新集群，默认false

## ！必须指定 -d 参数指定目录安装

## 包目录结构
### parcels
ELASTICSEARCH-7.9.0
    ├── build
    ├── config
    │   ├── elasticsearch.yml
    │   ├── es-customer01
    │   ├── es-data01
    │   ├── es-data02
    │   ├── es-data03
    │   ├── es-ingest01
    │   ├── es-master01
    │   ├── jvm.options
    │   └── jvm.options.d
    ├── lib
    │   ├── elasticsearch
    │   └── elasticsearch-7.9.0-linux-x86_64.tar.gz
    ├── meta
    │   ├── alternatives.json
    │   ├── elasticsearch_env.sh
    │   ├── parcel.json
    │   └── permissions.json
    └── target
        └── ELASTICSEARCH-7.9.0-el7.parcel
### csd
ELASTICSEARCH-7.9.0
    ├── aux
    ├── build.sh
    ├── descriptor
    │   └── service.sdl
    ├── images
    │   └── icon.png
    ├── lib
    │   └── validator.jar
    ├── scripts
    │   └── control.sh
    └── target
        └── ELASTICSEARCH-7.9.0.jar
