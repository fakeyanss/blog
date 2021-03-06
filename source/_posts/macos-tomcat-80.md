---
title: MacOS tomcat启动80端口
tags:
  - mac
  - tomcat
date: 2018-07-18 20:16:02
---
Mac OS上非root用户是不允许启动小于1024的端口，所以在mac上使用IDE开发，比如在Eclipse或者Intellij中，启动服务用80端口，会报错Permission Denied。

<!--more-->

---

可以通过修改Tomcat的用户为root来解决，但是更简单的是设置一个端口监听转发，将其他端口比如8080转发到80，这样在浏览器中输入地址就不用写端口号了。

命令：
1. `sudo vim /etc/pf.conf`
2. 在`rdr-anchor "com.apple/*"`这一行后面添加`rdr on lo0 inet proto tcp from any to 127.0.0.1 port 80 -> 127.0.0.1 port 8080`，保存退出
3. `sudo pfctl -f /etc/pf.conf`
4. `sudo pfctl -e`

这样就完成了，如果想关闭转发，输入`sudo pfctl -d`。

重启后转发需要重新开启生效，即输入3，4命令

如果要重启后自动生效，首先关闭系统完整性保护机制，需重启到安全模式在终端中执行下述命令关闭文件系统保护
```
csrutil enable --without fs
```

然后`sudo vim /System/Library/LaunchDaemons/com.apple.pfctl.plist`, 添加一行 `<string>-e</string>`
```
<string>pfctl</string>
<string>-e</string>
<string>-f</string>
<string>/etc/pf.conf</string>
```
保存退出。


