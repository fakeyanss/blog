[Yanss's Blog](http://foreti.me "有约如铁")

博客项目使用[Hexo](https://hexo.io/zh-cn/index.html)框架搭建，主题是[next](http://theme-next.iissnan.com/)，GitHub仓库交付给[Appveyor](https://www.appveyor.com/)持续集成，Coding仓库交付给[DaoCloud](http://www.daocloud.io/)持续集成。

**Site Changelog**
* hexo框架+next主题搭建博客，部署在github上，域名解析到[yanss.top](http://yanss.top)
* 配置[AppVeyor](https://ci.appveyor.com/projects)持续集成github，同时备份仓库到github
* 部署到[码云Coding](https://coding.net/)上，阿里云dns分流，国内访问解析到coding pages服务器，国外访问解析到github pages服务器
* 配置[DaoCloud](https://dashboard.daocloud.io/)持续集成coding
* 添加RSS订阅
* 添加head背景图
* 添加[wordcount](https://github.com/willin/hexo-wordcount)字数统计
* 添加[不蒜子](http://busuanzi.ibruce.info/)访客计数
* 添加[LeanCloud](https://leancloud.cn/)文章阅读计数
* 添加[jiathis](http://www.jiathis.com/)分享
* 添加[livere](https://livere.com/)评论
* 添加[cnzz](https://web.umeng.com)站点流量统计
* 添加博客相册，图片处理脚本来自[litten](https://github.com/litten/BlogBackup/tree/master/source/photos)，具体方法可以看[yilia](https://github.com/litten/hexo-theme-yilia)主题的issue
* 添加[DaoVoice](http://dashboard.daovoice.io/get-started?invite_code=a7abe03a
  ),可以使用我的邀请码
* [livere](https://livere.com/)加载太慢，更换为[Gitment](https://github.com/imsun/gitment)评论
* 相册图片源改为[七牛云](https://portal.qiniu.com/create)，加载速度更快，空间更大
* 修改域名 foreti.me, 取意 foretime 过去
* 删除coding的同步部署
* 重新修改页面样式，删除了一些统计插件
* gitment服务不可用，换为disqus评论