---
title: Mac上非常方便的一些工具和命令
tags:
  - mac
date: 2019-02-25 22:51:35
---
这是我日常使用mac os的一些常用app和命令
<!--more-->

---

![](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190224235353.png)

## 工具
以下工具皆开源免费，盗版勿求。
### 安装Homebrew
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### 使用Homebrew升级git版本
Mac系统虽然预装git，但一般是较老的版本，如果希望更新到新的版本，最方便的是用Homebrew更新。

安装git：
```
brew install git
```
替换系统预装git：
```
brew link git
```
以后更新git：
```
brew upgrade git
```

### 窗口管理应用
[Spectacle](https://github.com/eczarny/spectacle)，免费开源，关联的快捷键太多，可以取消一些窗口操作的keymap。
抛去价格不谈，Spectacle>Moom，而slate太麻烦。

### Shadowsocks科学上网
服务端
```
wget --no-check-certificate https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks.sh
chmod +x shadowsocks.sh
./shadowsocks.sh 2>&1 | tee shadowsocks.log
```
[Windows](https://github.com/shadowsocks/shadowsocks-windows)
[Mac](https://github.com/shadowsocks/ShadowsocksX-NG)
[Android](https://github.com/shadowsocks/shadowsocks-android)

### 图床上传工具
[Picgo](https://github.com/Molunerfinn/PicGo)
[云存储管理客户端](https://github.com/willnewii/qiniuClient)

### 菜单栏Menubar隐藏部分图标
[Dozer](https://github.com/DozerMapper/dozer)

### 轻量日历工具
[Istycal](https://github.com/sfsam/Itsycal)

### 剪贴板工具
[Clipy](https://github.com/Clipy/Clipy)

## 系统

### 调整Dock栏的隐藏速度
```bash
defaults write com.apple.dock autohide-delay -int 0 #时间设为最短
defaults write com.apple.dock autohide-delay -int 0.5 #时间设为 0.5s
killall dock
```

### 安全与隐私，打开允许“任何来源”
```
Sudo spctl --master-disable
```

### 设置Launchpad的列数和行数
```
defaults write com.apple.dock springboard-columns -int 列数
defaults write com.apple.dock springboard-rows -int 行数
defaults write com.apple.dock ResetLaunchPad -bool TRUE
killall Dock
```


<br>

---
<p id="div-border-left-red"><i>DigitalOcean 优惠码，注册充值 $5 送 $100，[链接一](https://m.do.co/c/282d5e1cf06e) [链接二](https://m.do.co/c/5eefb87c26cd)</i></span>
<p id="div-border-left-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>