---
title: Coding+Hexo搭建个人博客
tags:
  - Hexo
  - Coding
date: 2017-08-07 12:52:44
---
在coding.net上答应了好几个评论的朋友要写一篇教程，不多说，我们直接进入主题。

<!--more-->

---

我搭建博客用的是hexo框架，因为这个框架比较简单轻便，而且依赖于node.js管理包文件，我以前用过也用过一些npm的内容，所以选了这个。这里提一句，基于coding或者github搭建的博客都是静态页面，轻量简洁，相对的功能上不如Wordpress那样强大，但是我们也可以用第三方插件实现文章统计，网站计数，博客评论等功能，看自己喜好加吧。

好了，现在我们开始操作。

## step 1 安装环境

环境有三，node git hexo，hexo最后装。

### git
直接去下官网最新版本，安装步骤就不停next就好，不放心的话搜一下百度知道，有几个步骤需要斟酌，不过影响不大。链接在这里[git官网](https://git-scm.com/)。

### node
也是官网最新版本，[node.js中文官网](http://nodejs.cn/)现在好像是8.x了，这个就一直next安装，装好后在桌面打开cmd，

npm是node.js集成的包管理工具，现在是直接随node装好了。

查看版本号，成功显示就能用了，如果显示不是可用的命令就需要手动添加node环境变量，这个也简单，百度知道全有。

### hexo
在桌面右键，`git bash`，然后输入
```
npm install -g cnpm --registry=https://registry.npm.taobao.org
```

这里用`cnpm`是因为`npm`连接不太稳定，我用`npm`也是装了两次`hexo`才成功。而`cnpm`是淘宝团队提供的一个`npm`镜像库，国内访问非常快，以后的`npm`命令就在前面加一个`c`，使用方法完全相同。然后

```
cnpm install hexo-cli -g
```

在某个盘下新建一个文件夹，取名随意，我是`blog`。

然后在这个文件夹下右键，`git bash`，然后

```
hexo init
```
即在此初始化hexo源文件，需要这个`blog`文件夹初始为空。然后

```
cnpm install
```
这一步是安装通用的npm包文件，如果有特定的npm包需要额外添加。我们除了通用包，还要一个hexo部署博客的包文件，

```
cnpm install hexo-deployer-git --save
```
现在需要的基础包就安装好了。

## step 2 测试本地发布
现在新建一个博客，在`blog`文件夹下右键，`git bash`，然后输入

```
hexo new test
```
这一步是在生成一篇空博客marksown文档，存在`blog\source\_post`路径下，可以用编辑器打开它，我用的是sublime，装了markdown editing和markdown preview插件，或者其他md编辑器都行，在test.md中随便写点什么，然后保存。接下来
```
hexo g
```
这一步是hexo的核心，把md文件转为静态页面，并添加主题样式和必要的链接，生成的文件在public下。然后

```
hexo s
```
这样，就是在本地预览博客，在浏览器地址栏中输入

```
http://localhost:4000
```
就可以看到结果了。
现在只能自己浏览，想要让其他人也能看到，就需要部署到服务器上。租服务器不仅要花费，还要自己搭建web环境，太麻烦了，而且不适合学生党和技术不够的同学们，万幸github和coding都提供了静态页面解析的功能，所以我们把`public`文件夹下的内容`push`到一个git远程仓库就可以了。现在我们需要开始发布到coding的步骤。

## step 3 本地博客部署到coding

首先，去官网登陆你的coding账号，没有就注册一个，然后完善个人信息，升级到银牌会员（才能绑定个人域名）。然后新建一个repository，项目名称就填你的用户名，选择私有，然后创建项目。
![img](https://foreti.me/imgplace/2019/20170807124643.png)

现在有了远程仓库，就要把本地仓库和远程仓库关联起来，首先在`blog`目录下`git bash`，然后输入
```
git config -l
```
查看你的git配置信息，像我的是这样
```
$ git config -l
core.symlinks=false
core.autocrlf=true
core.fscache=true
color.diff=auto
color.status=auto
color.branch=auto
color.interactive=true
help.format=html
rebase.autosquash=true
http.sslcainfo=C:/Program Files/Git/mingw64/ssl/certs/ca-bundle.crt
diff.astextplain.textconv=astextplain
filter.lfs.clean=git-lfs clean -- %f
filter.lfs.smudge=git-lfs smudge -- %f
filter.lfs.required=true
filter.lfs.process=git-lfs filter-process
credential.helper=manager
user.name=xxx
user.email=xxx@xxx.com
core.repositoryformatversion=0
core.filemode=false
core.bare=false
core.logallrefupdates=true
core.symlinks=false
core.ignorecase=true
gui.wmstate=normal
gui.geometry=841x483+343+178 189 218
```

这里你只用关注的是这两行
```
user.name=xxx
user.email=xxx@xxx.com
```
如果你没有这两行，那么你需要添加配置：
```
git config --global user.email "your email"
```
和
```
git config --global user.name "your name"
```

将双引号中内容替换为你自己的coding用户名和邮箱，可以在coding个人设置中查看自己的用户名和邮箱。

然后我们给本地添加一个`SSH key`，这样的话每次部署就不用输密码。在git bash中输入
``` 
ssh-keygen -t rsa -b 4096 -C "your email"
```
成功会出现以下代码：
```
# Creates a new ssh key, using the provided email as a label
# Generating public/private rsa key pair.
Enter file in which to save the key (/Users/you/.ssh/id_rsa): [Press enter]  // 推荐使用默认地址,如果使用非默认地址可能需要配置 .ssh/config
```
然后一直回车，回车，回车，然后在 Coding.net 添加公钥
本地打开 id_rsa.pub 文件（一般在c盘用户文件夹下，进入你的用户文件夹，有一个`.ssh`文件，打开其中的`id_rsa.pub` ），复制其中全部内容，添加到Coding账户“SSH 公钥”页面 中，公钥名称可以随意起名字。
完成后点击“添加”，然后输入密码或动态码即可添加完成。
![img](https://foreti.me/imgplace/2019/20170807132102.png)
这里要注意是账户的SSH公匙，而不是项目中的设置的部署公匙，切记。

现在验证一下是否添加SSH公匙成功，在git bash中输入
```
ssh -T git@git.coding.net 
```
如果成功，会出现以下代码

```
Are you sure you want to continue connecting (yes/no)? yes 
Warning: Permanently added ‘git.coding.net,61.146.73.68’ (RSA) to the list of kn own hosts.
Enter passphrase for key ‘/c/Users/xxx/.ssh/id_rsa’: Coding.net Tips : [ Hello xxx! You have connected to Coding.net by SSH successfully! ]
```

现在就已经添加好了公匙，我们离博客部署到coding只差一步。

## step 4 部署博客到coding

首先打开`blog`文件夹下的`_config.yml`文件，这是我的配置，你需要修改的地方我都加了注释，别的不要动，还有就是要注意这里yml文件是用的yaml脚本语言，对语法要求很严格，每个`:`后面要加上空格，没空格会编译出错。

```
# Hexo Configuration
## Docs: https://hexo.io/docs/configuration.html
## Source: https://github.com/hexojs/hexo/

# Site
title: Yanss's Blog #改为你自己的网站名
subtitle:
description: Winner Winner, Chicken Dinner #改为你自己的描述语句，随便写
author: Yanss #改成你自己的名字
language: 
timezone: Asia/Shanghai

# URL
## If your site is put in a subdirectory, set url as 'http://yoursite.com/child' and root as '/child/'
url: https://yanss.top #url改成"xxx.coding.me"，xxx是你的仓库名，也是你的用户名
root: /
permalink: :year/:month/:day/:title/
permalink_defaults:

# Directory
source_dir: source
public_dir: public
tag_dir: tags
archive_dir: archives
category_dir: categories
code_dir: downloads/code
i18n_dir: :lang
skip_render:

# Writing
new_post_name: :title.md # File name of new posts
default_layout: post
titlecase: false # Transform title into titlecase
external_link: true # Open external links in new tab
filename_case: 0
render_drafts: false
post_asset_folder: false
relative_link: false
future: true
highlight:
  enable: true
  line_number: true
  auto_detect: false
  tab_replace:
  
# Category & Tag
default_category: uncategorized
category_map:
tag_map:

# Date / Time format
## Hexo uses Moment.js to parse and display date
## You can customize the date format as defined in
## http://momentjs.com/docs/#/displaying/format/
date_format: YYYY-MM-DD
time_format: HH:mm:ss

# Pagination
## Set per_page to 0 to disable pagination
per_page: 10
pagination_dir: page

# Extensions
## Plugins: https://hexo.io/plugins/
## Themes: https://hexo.io/themes/
theme: next #这里是主题名，你的先不要变，后面换主题再改

# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type: git
  repo: git@github.com:yanss/yanss.github.io.git #repo这里写你的仓库地址，下面告诉怎么找
  branch: master #就一个分支就不用改，默认master

#这个feed是添加RSS订阅用的，这里你没有暂时不用写
feed:
  type: atom
  path: atom.xml
  limit: 20
  hub:
  content: 

#这个search是站内搜索的，也是没有就不用写
search:
  path: search.xml
  field: post
  format: html
  limit: 10000 
```

打开coding网站上你刚才创建的仓库，点击代码，左下角选择`SSH方式访问仓库`，复制那个链接，把它填到你的`_config.yml`的`repo`那里。

![img](https://foreti.me/imgplace/2019/20170807130858.png)

现在我们就可以开始部署博客了，记得部署之前最好清理一遍`public`文件夹,也就是这样

```
hexo clean
hexo g
hexo d
```

或者你也可以直接

```
hexo d -g
```

coding+hexo的博客部署操作就是这些了，有问题可以下方留言评论。


