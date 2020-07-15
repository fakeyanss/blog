---
title: steam客户端页面循环加载失败修复方法
tags: steam
date: 2020-07-16 00:00:00
---
重装steam差点让我玩不了大嫖客了！！！

<!--more-->

最近重装了win10系统，下载了steam后，发现除了游戏库页面能正常加载，其他页面都是要么打不开，要么打开后显示2秒就自动跳转到黑屏。

搜了好久的解决办法，诸如修改hosts、刷新本地dns缓存、修改dns服务器、使用socks代理、使用proxifier代理本地应用，游戏加速器也试了几个，皆无效；
网上流传的UseEAm Hosts Editor、steamcommunity_302等工具都试过了，皆无效。

就在我以为最近有啥大事steam完全被墙，准备放弃的时候，突然想去贴吧找找答案。然后就在steam吧找到了几个帖子，和我的情况一模一样，都是在7月15号重新下载steam后出现这个问题，下面有回复了这么几个解决方法：

![steam-fix](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2020/steam%20fix.iaflk4hk8o.jpg)

加速器试过了无效，试了第二条，更新到steam测试版，我熟悉的steam页面又回来了。

--------------

虽然问题解决了，但是还是没想明白steam客户端有啥问题。按理说steam客户端也是走的http协议，我的本地代理完全可以生效才对，并且我在此前也在浏览器打开steam官网完全没有问题。不知有谁了解相关信息，欢迎评论告知。
