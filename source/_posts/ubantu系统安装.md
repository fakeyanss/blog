---
title: ubantu系统安装
categories:
  - Solution
tags:
  - Ubantu
mathjax: false
copyright: true
reward: true
toc: true
abbrlink: 67d3a6a5
date: 2018-01-11 13:16:17
description:
top:
password:
---

* [Ubantu系统安装教程](https://tutorials.ubuntu.com/tutorial/tutorial-create-a-usb-stick-on-windows#0)
* [Ubantu Desktop最新版本下载](https://www.ubuntu.com/download/desktop)，制作U盘启动盘推荐使用[Rufus](https://rufus.akeo.ie/)工具
* Ubantu系统分区方案
  * 在windows系统上把原硬盘压缩出50G的free空间，在Ubantu安装时分出2G作为swap分区
  * 剩下的格式化为ext4格式，挂载位置为`/`
  * ~~由于现在PC内存都较大了，所以不必创建swap交换分区~~
  * 设置`安装启动引导器的设备`
    * 我的电脑有两块ssd，一块小的全部作为C盘，装的win10系统和开机启动软件；一块大的作为D盘，安装常用软件和存放一些资料。我把ubantu安装在了D盘上的一个50G分区，这样就要把ubantu的引导器放在D盘，也就是`sdb` （sda对应第一块硬盘，sdb对应第二块硬盘），这样的话电脑开机时会自动进入win10，如果我按F11才会进入grub选择ubantu系统，这样正好符合我的需求。
    * 如果把引导器安装在C盘，每次开机都会手动选择系统。

<br>

<p id="div-border-top-green"><i>最后要说的是：[博客源码](https://github.com/fakeYanss/blog) ， 欢迎 star</i></p>