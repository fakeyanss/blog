---
title: chrome强制重定向到https的问题
categories:
  - solution
tags:
  - chrome
  - https
mathjax: false
copyright: true
reward: true
toc: true
abbrlink: ee3dca28
date: 2019-02-24 23:08:26
kewords:
description:
password:
---
有些场景下，在chrome中打开的http网页会自动重定向到https，这样可能会造成一些第三方的图片资源或脚本无法正常加载，如果不想这么做的话，可以在chrome地址栏输入
```
chrome://net-internals/#hsts
```
![](http://pic.yanss.top/2019/20190224231418.png)
在红色区域中输入不想自动重定向到https的域名，点击delete即可。

<br>
<p id="div-border-top-green"><i>最后要说的是: [博客源码](https://github.com/fakeYanss/fakeYanss.github.io/tree/source), 欢迎 star</i></p>