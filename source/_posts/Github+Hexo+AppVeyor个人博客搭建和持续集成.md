---
title: Github+Hexo+AppVeyor个人博客搭建和持续集成
categories:
  - Solution
tags:
  - CI
  - Github
  - AppVeyor
copyright: true
reward: true
toc: true
description: 
date: 2017-08-07 22:38:23
password:
---

# Github+Hexo+AppVeyor个人博客搭建和持续集成

我们都知道github pages提供了静态网页的自动解析，于是我们想到用github pages展示个人项目，特别是前端工程师，完全可以拿github展示个人项目设计。除此之外，我们也可以拿这个写个人博客，但是有一点，我们很难把博客写成html的静态页面吧。虽然可以强行实现，但是每添加一篇blog，就需要添加很多指向其他页面的链接，还有很多样式，光秃秃的页面总归不美。

有需求就有答案，这里有一种方法是，用一种博客框架来实现将编辑好的博客文本自动生成静态页面，这样我们就只用将html文件加入repository就好。有一个基于`Node.js`的轻量级的框架`Hexo`，就可以实现把`markdown`文件生成静态页面并发布到github仓库的功能，本文的内容从这里开始。

由于有不同的终端机，每次在不同平台去同步博客特别麻烦，所以想到持续集成的方式。在Github上同步管理我的blog源码，由第三方平台进行持续集成构建博客的html文件，并发布到gh-pages。搜一搜解决方案还不少，Travis，Appveyor和DaoCloud是我使用过的免费平台。这里只说Appveyor。

（时隔近一年，继续编辑这篇post）
这里只贴出AppVeyor的官方文档和用于hexo构建的yaml脚本。

文档地址：[https://www.appveyor.com/docs/](https://www.appveyor.com/docs/)

环境变量设定：
![](http://otzlyqzo6.bkt.clouddn.com/blog_appveyor_env.png)

构建脚本：
```yaml
clone_depth: 5

environment:
  access_token:
    secure: ***********************************************

install:
  - ps: Install-Product node ''
  - node --version
  - npm --version
  - npm install
  - npm install hexo-cli -g
  # and other package you need

build_script:
  - hexo generate

artifacts:
  - path: public

on_success:
  - git config --global credential.helper store
  - ps: Add-Content "$env:USERPROFILE\.git-credentials" "https://$($env:access_token):x-oauth-basic@github.com`n"
  - git config --global user.email "%GIT_USER_EMAIL%"
  - git config --global user.name "%GIT_USER_NAME%"
  - git clone --depth 5 -q --branch=%TARGET_BRANCH% %STATIC_SITE_REPO% %TEMP%\static-site
  - cd %TEMP%\static-site
  - del * /f /q
  - for /d %%p IN (*) do rmdir "%%p" /s /q
  - SETLOCAL EnableDelayedExpansion & robocopy "%APPVEYOR_BUILD_FOLDER%\public" "%TEMP%\static-site" /e & IF !ERRORLEVEL! EQU 1 (exit 0) ELSE (IF !ERRORLEVEL! EQU 3 (exit 0) ELSE (exit 1))
  - git add -A
  - if "%APPVEYOR_REPO_BRANCH%"=="master" if not defined APPVEYOR_PULL_REQUEST_NUMBER (git diff --quiet --exit-code --cached || git commit -m "Update Static Site" && git push origin %TARGET_BRANCH% && appveyor AddMessage "Static Site Updated")
```

好的，大致就这么些，如果还有问题，可在评论中提出。
