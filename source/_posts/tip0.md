title: 倾斜人生 - 0
date: 2019-05-07 00:15:05
tags: tip
---
201904W19 Tip
<!-- more -->

---

在 ARTS 系列中，除了 Algorithm外，Tip 似乎也不大好作为博客的形式来展现。但是 Leetcode 题解还能发到 Github repo 中作为记录，Tip 该怎么办？
于是想把所有的 Tip 作为一个系列发出，名 「倾斜人生」，取自 "tip" 的「倾斜」之意。

## Linux 文件内容查询统计

最近遇到的一个事儿，需要在一堆日志文件中统计出包含指定字符串的行内容。首先日志文件是按天存储的，每天的日志文件会按 50MB 大小进行分割，这样分下来，一天的日志文件有 2000 至 3000 个，总共 100+GB。

debug 级别的日志存放路径在 `/home/user/project/log/debug/` 下，我们先进入这个路径下：
```sh
cd /home/user/project/log/debug/peoject-name.debug.log-2019-05-05
```

下面是 2000+ 个日志文件，查看一下 `ls` ：
```sh
2019-05-05.1000.debug.log  2019-05-05.2000.debug.log  2019-05-05.3000.debug.log   2019-05-05.9.debug.log
2019-05-05.1001.debug.log  2019-05-05.2001.debug.log  2019-05-05.3001.debug.log
......
```

需要找到这一天的日志里，关于 `[Storage]usage` 相关的内容，于是在当前目录输入：
```sh
find -name '*.log' | xargs grep '\[Storage\]usage'
```

由于文件太多，等了一会才有了输出，确认可以查到相关信息，于是将输出信息存到文件里，担心输出的文件太大，将查询命令分批执行：
```sh
mkdir /home/user/project/tmp
find -name '2019-05-05.1*' | xargs grep '\[Storage\]usage' > /home/user/project/tmp/res-1.log
find -name '2019-05-05.2*' | xargs grep '\[Storage\]usage' > /home/user/project/tmp/res-2.log
find -name '2019-05-05.3*' | xargs grep '\[Storage\]usage' > /home/user/project/tmp/res-3.log
```

等待时间较长，最后查看生成的文件，`ll /home/user/project/tmp`：
```sh
-rw-rw-r-- 1 user user 20944335 May  5 14:08 res-1.log
-rw-rw-r-- 1 user work 54233966 May  5 13:25 res-2.log
-rw-rw-r-- 1 user user 70104519 May  5 13:36 res-3.log
```

提取出需要的日志后，可以再按内容进行下一步的操作，比如统计或排错等。

## Mockito 使用

[Mockito](https://segmentfault.com/a/1190000006746409)。

Mockito 多在 Java 项目单测中使用，可以说 Junit + Mockito 是单元测试的利器。Mockito 可以方便的 mock 对象，避免外部依赖对单测的影响。

## 私人网盘 - FileBrowser

[FileBrowser](https://github.com/filebrowser/filebrowser)

利用 FileBrowser 可以在服务器上搭建私人网盘，提供了基础的文件服务，以及用户权限管理。开发者提供了自动搭建脚本，搭建的流程十分快捷。

![](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/filebrowser-case.gif)

## MySQL技巧

查询指定数据库每个表的行数。

```sql
SELECT
  table_name,
  table_rows
FROM
  INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'database_name';
```

## 两个网页头部背景图

OverWatch 的 Mercy 和 D.va，都是我喜欢的角色，可以作为网站的头部背景使用。
![](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/headback.jpg)
![](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/headback2.jpg)




<br>
<p id="div-border-top-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>