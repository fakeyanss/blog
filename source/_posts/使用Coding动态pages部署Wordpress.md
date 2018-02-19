---
title: 使用Coding动态pages部署WordPress
categories:
  - Solution
tags:
  - WordPress
  - Coding-pages
mathjax: false
copyright: true
reward: true
toc: true
abbrlink: 638b585f
date: 2018-02-09 14:28:46
kewords:
description:
password:
---

什么都别说了，先上图 

![coding-pages](http://ouat6a0as.bkt.clouddn.com/coding-pages.png)

部署好的wordpress效果（我主要是做一个相册集）

![wp](http://ouat6a0as.bkt.clouddn.com/wp.yanss.top_.png)

总体效果还不错吧，毕竟动态博客还是可操作性强多了。

好了，进入正题。

做这个其实就是前几天在coding的pages服务菜单中发现还有静态和动态两个选项卡，当时就懵逼了，pages服务还能动态？

然后看了说明，动态是可以，但是限制还是蛮多的。

> 动态 Pages 是一个动态网页托管和演示服务，支持使用 PHP 语言和 MySQL 数据库，可用于部署开源博客、CMS 等动态应用。

只能使用php语言，然后数据库其实是coding自己的服务器提供的，然后整个服务器后台也是coding提供，所以自己是不可能做什么修改的。当然做一个wordpress博客还是绰绰有余，下面就是我的wordpress仓库文件。

![coding-pages1](http://ouat6a0as.bkt.clouddn.com/coding-pages1.png)

搭建过程也非常简单，就是coding新建一个仓库，然后去[wordpress官网](https://cn.wordpress.org/)上下载最新的wordpress压缩包，解压之后push到coding仓库中。

然后在Pages服务中开启动态Pages，选择部署来源为master分支，稍等一下就自动部署完成了。

打开动态pages运行的url，然后就是5分钟流程了。

所有的连接信息(共5个)都在这里，只有前4个用得上

![coding-pages2](http://ouat6a0as.bkt.clouddn.com/coding-pages2.png)

**存在的问题：**

* 使用过程中在wordpress管理后台中下载好了主题和插件，但是在coding仓库中却没有对应的文件增加。所以在偶尔出现数据库连接错误或其他问题需要重新部署时，原本设置好的插件和主题就没有了
* 由于动态pages使用的是coding自己的服务器，所以个人没法修改服务器的一些设置，比如上传文件的大小限制，图片的分辨率等，所以上传的大图需要自己压缩一下再传。

**最后建议：**

* 把连接信息保存到一个文件`wp-config.php`，放到根目录下。
* 所有的主题和插件去源网页下载文件，保存到`wp-content`下的对应文件夹下，然后提交到coding

<br>
<p id="div-border-top-green"><i>最后要说的是：博客源码 ， 欢迎 star</i></p>


