---
title: GitBook源文件发布到gh-pages
tags:
  - gitbook
  - gh-pages
date: 2018-02-04 20:56:52
---
GitBook的渲染真的很慢，我找到了它编译生成的html文件，并将它上传到了gh-page上。
<!--more-->

---

# 背景

这段时间在读一本英文书，读的很慢，可以说是逐词翻译了。

然而读的时候总是会忘了前面的生词是什么意思，也没有纸质打印版，所以想到边读边做笔记，主要就是生词注释一下。

于是想到了GitBook。

首先我在GitBook上创建一本书，书名是`Hadoop-The Definitive Guide 4th Edition`。

然后打开就可以直接编辑。

![hadoopbook1](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/hadoopbook1.png)

但是gitbook的编辑器很难用啊，好像原来是直接写markdown的，现在改了编辑模式？特别是插入连接的时候，没法像`[]()`这么方便啊。

而且重要的是gitbook服务器加载速度不稳定，慢的时候都打不开了，所以想着直接把gitbook的Markdown文件内容编译成静态页面，发布到github仓库中，利用gh-pages直接访问，速度快多了。

# 连接github仓库

现在说说怎么部署到gh-pages。


首先在github创建一个仓库，`Hadoop-The-Definitive-Guide-4th`，并初始化。

然后到gitbook的书籍`Hadoop-The Definitive Guide 4th Edition`的设置里找到`Github`，添加对应`Hadoop-The-Definitive-Guide-4th`仓库并同步内容

![hadoopbook2](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/hadoopbook2.png)

之后可以在github仓库中看到一些文件

![hadoopbook3](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/hadoopbook3.png)

这些都是gitbook书的markdown文件。这一步完成后，就可以在gitbook或github任意一端编译文档，提交后都会在两端生成的相应书籍。这相当于书籍在两端都有备份了。

如果不用gh-pages生成页面的话，上述的操作就已经够了。

# 提交gh-pages分支

接下来介绍如何提交静态页面到gh-pages。<br><br>

由于要生成静态页面的文件，需要在本地安装gitbook的npm包(推荐使用cnpm安装)。
```
npm install gitbook-cli -g
```
然后把github仓库clone到本地
```
git clone git@github.com:fakeYanss/Hadoop-The-Definitive-Guide-4th.git
```
进入到`Hadoop-The-Definitive-Guide-4th`文件夹，生成静态页面文件，输出目录在`_book`中。如果目录文件`SUMMARY.md`有变化，需要先`gitbook init`。
```
gitbook build
```
然后在本地创建一个`gh-pages`分支
```
git checkout --orphan gh-pages
```
然后清空一下分支下的文件（如果有的话）
```
rm -rf *
```
然后将`master`分支下的`_book`静态页面文件内容全部复制到`gh-pages`分支下
```
git checkout master -- _book
```
将`_book`中的子文件全部移到外层，并删除`_book`
```
mv _book/* ./
rm -rf _book
```
这时候`gh-pages`分支下就是全部的静态页面文件了，接下来就是提交到远程`gh-pages`分支
```
git add .
git commit -m 'publish gh-pages'
git push origin gh-pages
```
提交完成后到github仓库的设置中看一下，gh-pages服务是否自动开启，如果没有的话在`Source`中选择`gh-pages branch`，保存刷新，等待几分钟就好了。

![hadoopbook5](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/hadoopbook5.png)

全部操作已经完成，接下来每次在本地更新书籍内容后，先生成静态页面，然后提交master分支，再提交gh-pages分支就可以了。

之后每次查看线上gitbook书籍，可以直接输入url `https://name.github.io/书籍仓库名`查看。

---

最后，为了每次的提交操作不用手打一遍，我写了一个bash脚本[publish.sh](https://github.com/fakeYanss/Hadoop-The-Definitive-Guide-4th/blob/master/publish.sh)，[点击下载](http://pic.yanss.top/publish.sh)，自行更改第一行的文件夹地址即可。windows系统安装过git环境的可以直接双击运行，要查看日志的话可以在git bash中输入`./publish.sh`运行。

**注意：使用时不能将脚本放在仓库里，不然在切换分支时会出错，**最好与仓库文件夹同级。

![hadoopbook4](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/hadoopbook4.png)

<br>

---
<p id="div-border-left-red"><i>DigitalOcean 优惠码，注册充值 $5 送 $100，[链接一](https://m.do.co/c/282d5e1cf06e) [链接二](https://m.do.co/c/5eefb87c26cd)</i></p>
<p id="div-border-left-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>


