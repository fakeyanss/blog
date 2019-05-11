---
title: Coding DaoCloud持续集成
tags:
  - CI
date: 2017-08-07 22:38:23
---
如何在多终端发布coding博客，比如部署好的hexo+coding博客，我换了电脑，有方便的方法可以继续发博客吗？答案是有。
<!--more-->

---

在上一篇博客中，按照步骤做完，就可以在本机发布博客到coding了，但这样我们只能用这一台电脑发博客，并且最大的问题是备份问题，如果这台电脑挂了，或者是误删文件，就很可能丢失了blog源文件。如果没有备份，就要gg了。

想要备份源文件，同时在多终端发布博客，最好的实现方式是找一个持续集成工具，在`coding`的帮助文档里有一些介绍，我试过一些，最后选择`DaoCloud`来集成coding仓库，原因还是免费。

这里的原理是，在coding的blog仓库中建立两个分支，分别是master和coding-pages。master分支存放blog源文件，即本地的hexo文件内容；`coding-pages`分支存放博客的全部静态页面，也就是`blog\public`文件夹中的内容。

操作的过程中，顺序是

1. `git push` 提交本地blog源文件到`master`分支
2. DaoCloud检测到master分支有提交内容，按照设置好的安装环境，生成博客，部署博客到coding-pages分支

这样在部署过一次之后，如果不再修改样式和主题等其他内容，只是提交博客，可以直接登录coding.net网站，将编辑好的md文件添加到`master`分支的`blog/source/_post`文件夹下，就完了。

如果要同步本地备份，也只用把`master`分支内容`clone`到本地就行了。

现在开始正式的操作。
## 创建新分支
登录到coding官网中，可以继续保留上一篇博客中创建的仓库，先清空仓库（在项目设置里的仓库设置），然后在分支管理处新建分支`coding-pages`。

## 创建SSH Key文件夹
由于上一篇博客[《github+hexo搭建个人博客》](http://yanss.top/Coding+DaoCloud%E6%8C%81%E7%BB%AD%E9%9B%86%E6%88%90/)中已经创建了SSH key，所以这里可以直接使用，在`/blog/`根目录下创建文件夹`.daocloud`，这里前面有`.`的文件夹不能直接创建，可以先直接创建`aaa`，再用命令行修改名字。此处右键打开git bash，
```
mv aaa .daocloud
```
然后把之前生成的SSH key复制到这个文件夹下
```
cp  ~/.ssh/id_rsa*   .daocloud/
```
然后在`.daocloud`下新建文件`ssh_config`
```
touch ssh_config
```
打开`ssh_config`,输入
```
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
```
保存。

## 编辑Dockerfile
在本地仓库blog根目录下新建文件名为`Dockerfile`的文件（没有后缀）,打开编辑内容如下，原因稍后再说：

```
# Dockerfile
FROM node:slim
MAINTAINER xxx <xxx@xxx.com>

# 安装git、ssh等基本工具
RUN apt-get update && apt-get install -y git ssh-client ca-certificates --no-install-recommends && rm -r /var/lib/apt/lists/*

# 设置时区
RUN echo "Asia/Shanghai" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

RUN npm install -g cnpm --registry=https://registry.npm.taobao.org
# 只安装Hexo命令行工具，其他依赖项根据项目package.json在持续集成过程中安装
RUN cnpm install hexo-cli -g
# install hexo server
RUN cnpm install hexo-server

EXPOSE 4000
```

这里只用替换上你自己的coding用户名和邮箱就行，别的不变。

## 修改本地_config.yml配置
因为要把博客部署到`coding-pages`分支，所以要修改deploy参数，把_config.yml的deploy修改如下
```
deploy:
  type: git
  repo:
      coding: git@git.coding.net:xxx/xxx.git,coding-pages
```
coding后面替换为你自己的coding仓库地址，加上coding-pages分支。

## DaoCloud创建项目和配置
这里是因为DaoCloud系统有过升级改版，网上搜到的DaoCloud操作教程几乎都是去年12月以前的，所以有些对现在的版本不太适用，我自己借助旧的教程和部署`AppVeyor`的经验改动了一些，适用现在的DaoCloud。

下面先登录DaoCloud官网，用github或者coding账号直接登录，在个人设置中绑定github和coding，然后在控制台新建项目，项目名随便取。
![img](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20170807214217.jpg)
![img](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20170807214425.jpg)

选择`成功构建后设置 latest 为镜像标签`，然后点击`镜像：ci-hexo`（这里是我的名字，你就点你自己相应的），复制镜像地址，先记在一边等下要用。这里安利一个剪贴板管理软件[Ditto](https://sourceforge.net/projects/ditto-cp/)。
![img](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/2017080721427.jpg)

然后打开流程定义，点击右侧`通过 yaml 快捷编辑`，打开后只一个脚本编辑页面，直接把以下内容复制进去：

```
version: 3
image: ubuntu:16.04
stages:
- build
- test
构建任务:
  stage: build
  job_type: image_build
  only:
    branches:
    - master
  build_dir: /
  cache: true
  dockerfile_path: /Dockerfile
测试任务:
  stage: test
  job_type: test
  only:
    branches:
    - master
  pull_request: false
  before_script:
  - mkdir ~/.ssh
  - mv .daocloud/id_rsa ~/.ssh/id_rsa
  - mv .daocloud/ssh_config ~/.ssh/config
  - chmod 600 ~/.ssh/id_rsa
  - chmod 600 ~/.ssh/config
  - eval $(ssh-agent)
  - ssh-add ~/.ssh/id_rsa
  - rm -rf .daocloud
  - git config --global user.name "xxxxx" #这里填你的coding用户名
  - git config --global user.email "xxxxx@xxxxx.com" #这里填你的coding邮箱
  image: xxxxx:latest #这里填你的镜像url，不要覆盖latest
  install:
  - cnpm install
  - cnpm install --save hexo-generator-feed
  - cnpm install hexo-baidu-url-submit --save
  script:
  - hexo clean
  - hexo g
  - hexo d
  - rm -rf ~/.ssh/
```
只用修改3处位置，其他的不要动，然后点击`更新`。
![img](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20170807220526.jpg)

到了这里就快完成了，还差一点，在流程定义这里点击构建任务，修改触发条件为分支-master-执行任务，测试任务也修改触发条件为分支-master-执行任务。
![img](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20170807220586726.jpg)
![img](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20170807221310.jpg)

## git关联远程库和提交代码
先在所有的配置就做完了，可以回到blog文件夹下，将本地仓库push到远程库就行了。
现在介绍一下如何关联远程库，以及commit和push操作。

* 关联远程库，这里后面xxx是你的仓库url

```
git remote add coding xxxxxx 
```

* 添加代码到本地仓库和commit信息，这里xxx是你的commit信息，可以随便写

```
git add .
git commit -m "xxx"
```

* push到远程库的master分支

```
git push -u coding master
```

如果提示有冲突，就把`-u`改为`-f`，反正仓库里都是自己的东西，force push也没什么大问题。

## 结束

现在就完成了全部的操作，其实并不复杂，Dockerfile之预编译文件，放在仓库master分支中，每当仓库master分支有新的提交时，DaoCloud会监测到变化，由于触发条件的设置，就开始了构建任务和测试任务，构建任务阶段是编译Dockerfile文件中的脚本，其实大致意思很好懂，就是配置git，node和hexo环境。然后进行测试任务，就是进行刚才编辑的yaml编辑器中的脚本，其中有一段测试任务，逻辑就是安装必要的hexo包，然后复制coding仓库里的ssh密匙，用你配置的账号和邮箱，进行hexo操作，清除缓存，生成文件，部署到coding-pages分支，然后删除ssh密匙（安全性）。

虽然整个操作过程有暴露私有ssh key的风险，但说实话，git的初衷不就是为了分享代码吗，况且我们写的这些真实价值并没有多少，所以放心的使用吧，coding提供的是私有仓库还是可以放心，github进行进行相同操作就改一下配置也可以最后删掉ssh key。

coding+DaoCloud持续集成到此结束，有问题可以下方留言评论。


<br>

---
<p id="div-border-left-red"><i>DigitalOcean 优惠码，注册充值 $5 送 $100，[链接一](https://m.do.co/c/282d5e1cf06e) [链接二](https://m.do.co/c/5eefb87c26cd)</i></span>
<p id="div-border-left-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>