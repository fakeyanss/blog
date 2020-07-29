---
title: chrome强制重定向到https的问题
tags:
  - chrome
  - https
date: 2019-02-24 23:08:26
---
有些场景下，在chrome中打开的http网页会自动重定向到https

<!--more-->，这样可能会造成一些第三方的图片资源或脚本无法正常加载，如果不想这么做的话，可以在chrome地址栏输入
```
chrome://net-internals/#hsts
```
![](https://foreti.me/imgplace/2019/20190224231418.png)
在红色区域中输入不想自动重定向到https的域名，点击delete即可。

