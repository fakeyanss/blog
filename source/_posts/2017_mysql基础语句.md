---
title: mysql基础语句
categories: SQL
tags:
  - mysql
copyright: true
reward: true
toc: true
abbrlink: 929f9824
date: 2017-07-29 15:12:02
description:
password:
---
### 选择：
```
select * from table1 where 范围
```
<!--more-->
### 插入：
```
insert into table1(field1,field2) values(value1,value2)
```
### 删除：
```
delete from table1 where 范围
```
### 更新：
```
update table1 set field1=value1 where 范围
```

### 查找：
```
select * from table1 where field1 like ’%value1%’ 
//like的语法很精妙，查资料!'
```

### 排序：
```
select * from table1 order by field1,field2 [desc]
```
### 总数：
```
select count as totalcount from table1
```
### 求和：
```
select sum(field1) as sumvalue from table1
```
### 平均：
```
select avg(field1) as avgvalue from table1
```
### 最大：
```
select max(field1) as maxvalue from table1
```
### 最小：
```
select min(field1) as minvalue from table1
```

<br>

<p id="div-border-top-green"><i>最后要说的是：[博客源码](https://github.com/fakeYanss/blog) ， 欢迎 star</i></p>