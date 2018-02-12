---
title: Hexo的next主题个性化配置
categories:
  - Solution
copyright: true
reward: true
toc: true
abbrlink: '14046165'
date: 2017-12-31 21:10:03
---

## 添加RSS

首先在博客根目录安装hexo插件：

```
$ npm install --save hexo-generator-feed
```

npm安装失败请用cnpm

然后在博客配置文件`_config.yml`中修改

```
plugins: hexo-generate-feed
feed:
  type: atom       #feed 类型 (atom/rss2)
  path: atom.xml   #rss 路径
  limit: 0        #在 rss 中最多生成的文章数(0显示所有)
```

然后在主题配置文件`_config.yml`中修改

```
rss: /atom.xml
```

---

## 修改作者头像并旋转

打开`\themes\next\source\css\_common\components\sidebar\sidebar-author.styl`，在里面添加如下代码：

```css
.site-author-image {
  display: block;
  margin: 0 auto;
  padding: $site-author-image-padding;
  max-width: $site-author-image-width;
  height: $site-author-image-height;
  border: $site-author-image-border-width solid $site-author-image-border-color;

  /* 头像圆形 */
  border-radius: 80px;
  -webkit-border-radius: 80px;
  -moz-border-radius: 80px;
  box-shadow: inset 0 -1px 0 #333sf;

  /* 设置循环动画 [animation: (play)动画名称 (2s)动画播放时长单位秒或微秒 (ase-out)动画播放的速度曲线为以低速结束 
    (1s)等待1秒然后开始动画 (1)动画播放次数(infinite为循环播放) ]*/
 

  /* 鼠标经过头像旋转360度 */
  -webkit-transition: -webkit-transform 1.0s ease-out;
  -moz-transition: -moz-transform 1.0s ease-out;
  transition: transform 1.0s ease-out;
}

img:hover {
  /* 鼠标经过停止头像旋转 
  -webkit-animation-play-state:paused;
  animation-play-state:paused;*/

  /* 鼠标经过头像旋转360度 */
  -webkit-transform: rotateZ(360deg);
  -moz-transform: rotateZ(360deg);
  transform: rotateZ(360deg);
}

/* Z 轴旋转动画 */
@-webkit-keyframes play {
  0% {
    -webkit-transform: rotateZ(0deg);
  }
  100% {
    -webkit-transform: rotateZ(-360deg);
  }
}
@-moz-keyframes play {
  0% {
    -moz-transform: rotateZ(0deg);
  }
  100% {
    -moz-transform: rotateZ(-360deg);
  }
}
@keyframes play {
  0% {
    transform: rotateZ(0deg);
  }
  100% {
    transform: rotateZ(-360deg);
  }
}
```

---

## 添加相册

<div id="album">我的[相册](http://yanss.top/photos/)。</div>
原理很简单，就是建立一个github仓库存储用于存储图片，然后将每个图片的路径保存到一个json文件里，在hexo博客中解析这个json文件，渲染成html页面后就可以在显示图片了。当然这里肯定要有页面的样式和图片的裁剪压缩，原理简单，实际操作起来有一些坑，我并不懂css样式，还是要感谢[litten](https://github.com/litten/BlogBackup/tree/master/source/photos)提供的方法。

* 首先在github上新建一个仓库，命名`Blog_Album`
* 然后本地新建一个文件夹`Blog_Album`，进入文件夹新建两个子文件夹`photos`，`min_photos`，然后下载这两个文件[ImageProcess.py](https://github.com/fakeYanss/Blog_Album/blob/master/ImageProcess.py)，[tool.py](https://github.com/fakeYanss/Blog_Album/blob/master/tool.py)到`Blog_Album`

记住之后要上传的相片就放到`photos`文件夹内。

* 在博客根目录运行

```
hexo new photos
```

* 回到`Blog_Album`文件夹，将tools.py`中131行

```
final_dict = {"list": list_info}
    with open("D:/Blog/source/photos/data.json","w") as fp:
        json.dump(final_dict, fp)
```

将路径改为你的博客`photos`文件夹的相应位置

* 添加一些图片到`Blog_Album`的`photos`文件夹中
* 将本地`Blog_Album`与github仓库`Blog_Album关联`
* 运行`tool.py`脚本（因为脚本中有上传到github的函数，所以不用手动git push）
* 将本地`Blog_Album`上传到github仓库`Blog_Album`
* 回到`yourblog\source\photos`目录下，将`index.md`内容修改为

```html
---
title: 我的相册
date: 2017-12-29 22:32:22
type: "photos"
---
<link rel="stylesheet" href="./ins.css">
 <link rel="stylesheet" href="./photoswipe.css"> 
<link rel="stylesheet" href="./default-skin/default-skin.css"> 
<div class="photos-btn-wrap">
  <a class="photos-btn active" href="javascript:void(0)">Photos</a>
</div>
<div class="instagram itemscope">
  <a href="http://yanss.top" target="_blank" class="open-ins">图片正在加载中…</a>
</div>
 
<script>
  (function() {
    var loadScript = function(path) {
      var $script = document.createElement('script')
      document.getElementsByTagName('body')[0].appendChild($script)
      $script.setAttribute('src', path)
    }
    setTimeout(function() {
        loadScript('./ins.js')
    }, 0)
  })()
</script>
```

第13行链接为自己的博客url

* 然后在photos文件夹下添加这些内容

![TIM截图20171231214306](http://ouat6a0as.bkt.clouddn.com/TIM截图20171231214306.png)



文件这里[下载](https://github.com/fakeYanss/fakeYanss.github.io.source/tree/master/source/photos)，`data.json`是图片的数据信息，运行python脚本后会生成

`ins.js`中的114行`render()`函数需要修改这两个变量

```js
var minSrc = 'https://raw.githubusercontent.com/fakeYanss/Blog_Album/master/min_photos/' + data.link[i];
var src = 'https://raw.githubusercontent.com/fakeYanss/Blog_Album/master/photos/' + data.link[i];
```

如果你的仓库名和我相同，只用把这里的`fakeYanss`改为你自己的github name即可

* 在`yourBlog/themes/next/source/js/src`下加入两个js文件[photoswipe.min.js](https://github.com/fakeYanss/fakeYanss.github.io.source/blob/master/themes/next/source/js/src/photoswipe.min.js) 和[photoswipe-ui-default.min.js](https://github.com/fakeYanss/fakeYanss.github.io.source/blob/master/themes/next/source/js/src/photoswipe-ui-default.min.js)


* 在`yourBlog/themes/next/layout/_scripts/pages/post-details.swig`中添加

```html
<script type="text/javascript" src="{{ url_for(theme.js) }}/src/photoswipe.min.js?v={{ theme.version }}"></script>
<script type="text/javascript" src="{{ url_for(theme.js) }}/src/photoswipe-ui-default.min.js?v={{ theme.version }}"></script>
```

* 在`yourBlog/themes/next/layout/_layout.swig`中

`head`内插入

```html
<script src="{{ url_for(theme.js) }}/src/photoswipe.min.js?v={{ theme.version }}"></script>
<script src="{{ url_for(theme.js) }}/src/photoswipe-ui-default.min.js?v={{ theme.version }}"></script>
```

`body`内插入

```html
{% if page.type === "photos" %}
<!-- Root element of PhotoSwipe. Must have class pswp. -->
<div class="pswp" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="pswp__bg"></div>
    <div class="pswp__scroll-wrap">
        <div class="pswp__container">
            <div class="pswp__item"></div>
            <div class="pswp__item"></div>
            <div class="pswp__item"></div>
        </div>
        <div class="pswp__ui pswp__ui--hidden">
            <div class="pswp__top-bar">
                <div class="pswp__counter"></div>
                <button class="pswp__button pswp__button--close" title="Close (Esc)"></button>
                <button class="pswp__button pswp__button--share" title="Share"></button>
                <button class="pswp__button pswp__button--fs" title="Toggle fullscreen"></button>
                <button class="pswp__button pswp__button--zoom" title="Zoom in/out"></button>
                <!-- Preloader demo http://codepen.io/dimsemenov/pen/yyBWoR -->
                <!-- element will get class pswp__preloader--active when preloader is running -->
                <div class="pswp__preloader">
                    <div class="pswp__preloader__icn">
                      <div class="pswp__preloader__cut">
                        <div class="pswp__preloader__donut"></div>
                      </div>
                    </div>
                </div>
            </div>
            <div class="pswp__share-modal pswp__share-modal--hidden pswp__single-tap">
                <div class="pswp__share-tooltip"></div> 
            </div>
            <button class="pswp__button pswp__button--arrow--left" title="Previous (arrow left)">
            </button>
            <button class="pswp__button pswp__button--arrow--right" title="Next (arrow right)">
            </button>
            <div class="pswp__caption">
                <div class="pswp__caption__center"></div>
            </div>
        </div>
    </div>
</div>
{% endif %}
```

* 重新生成博客内容即可看到相册内容。
  * 如果py脚本不能运行，先安装python环境，再安装`Pillow`库`pip install Pillow`
  * 相册图片的命名请遵循`yyyy-mm-dd_abc.efg`格式
  * 最后的不足是，相片的裁剪算法不算好，比如会[这样](https://github.com/fakeYanss/Blog_Album/blob/master/album/photos/2017-09-17_ICIP2017.JPG)，还有的会[这样](https://github.com/fakeYanss/Blog_Album/blob/master/album/photos/2017-09-19_%E8%83%A1%E5%90%8C1302.JPG)
  * next主题源码是不支持相册的，如果有不懂的地方，可以去查一下[yilia](https://github.com/litten/hexo-theme-yilia)主题的issue，然后再来问我
* **2018.1.20修改**：由于从github仓库读取图片，在html页面中会发生ios手机竖持拍照的照片90度旋转问题（图片的EXIF的orientaion信息在裁剪压缩后发生改变），找了一些办法都没效果，所以将相片源仓库转移到七牛云，利用七牛云外链后加上`?imageMogr2/auto-orient`的方式，可以将照片正常角度显示。


---

## 添加Gitment评论
原本是用的livere评论，后来总是加载速度太慢，上了梯子也一样，索性改成了[Gitment](https://github.com/imsun/gitment)评论。

感谢作者[imsun](https://github.com/imsun)，Gitment评论源自github仓库的issue，所以在将博客地址关联了某个github仓库后，在博客下评论其实就是在对应仓库的issue中评论，这创意真是太好了。

我之前的next主题一直是`5.1.0`版本，本来是想在主题中添加gitment的js和css文件，结果没成功。然后在next的[官方文档](http://theme-next.iissnan.com/)中看到已经发行到`5.1.4`了，而且已经集成了gitment评论。这下可方便，干脆直接升级了next主题，然后就改`config`文件就好啦。

以前主题中配置了一些设置项，时间久了还忘了改了哪些文件！！！所以升级版本很痛苦，用的Sublime的一个插件Sublimerge，可以对比两个文件的代码差异，就是这样
![Sublimerge](http://ouat6a0as.bkt.clouddn.com/hexo个性设置.png)
就像git pull操作之后改动时一样，这样子把每个有可能改过的文件都对比了一遍，然后升级到了5.1.4，发现集成了很多新功能，其他的有时间再试吧，这里就只说gitment。

首先在[这里](https://github.com/settings/applications/new)注册一个OAuth Application，`Homepage URL`和`Authorization callback URL`填写博客首页地址，也就是站点配置文件中的`url`，其他随意填写即可。

然后会得到一个`Client ID`和`Client Secret`，把这两个值填到主题配置文件的gitment对应位置
```yaml
gitment:
  enable: true
  mint: true # gitment仓库有两个，这里填true是引用第一个，false引用第二个，具体在layout下的conment文件中可以找到
  count: true # 评论计数
  lazy: false # 如果要点击按钮再显示评论就填true
  cleanly: true # 隐藏底部信息
  language: # Force language, or auto switch by theme
  github_user: 填github ID
  github_repo: 填保存issue的仓库名，一般就用博客发布的仓库名
  client_id: 刚才的值
  client_secret: 刚才的值
  proxy_gateway: # 设置代理，不用填
  redirect_protocol: # 没搞懂，不用填
```
然后重新部署博客(本地调试是没用的，因为url不同)，再打开博客，这时候需要在每一个有评论的页面上使用自己的github长航登录并初始化一遍评论，之后就不用了。文章多的话会有点麻烦，不知道gitment作者有没有做好自动初始化？好像查到了[这个](https://draveness.me/git-comments-initialize)，不过我还没试过。
这里是成功的样子![gitment](http://ouat6a0as.bkt.clouddn.com/gitment.png)

但是，这个鼠标放上有两条横线什么鬼啊！！！![gitment1](http://ouat6a0as.bkt.clouddn.com/gitment1.png)

还有这里头像下面为什么有一条横线！！！！![gitment2](http://ouat6a0as.bkt.clouddn.com/gitment2.png)

强迫症忍不了，查看了gitment的css定义，没发现什么问题啊，然后在浏览器中调试，发现了这个
```css
a{  
  color: #555;
  border-bottom: 1px solid #999;
  text-decoration: none;
  word-wrap: break-word;
}
```
这里的`border-bottom: 1px solid #999`就是`a`标签下有一条横线的意思，但是这个属性是主题的属性`main.css`啊，显然是不能改的，于是只有在`themes\next\source\css\_common\components\third-party\gitment.styl`下改动了，在这里可以重写前面定义的属性，我是这样改的，在最后面加上
```css
.gitment-comment-main a{
  color: #555;
  border-bottom: none;
  text-decoration: none;
  word-wrap: break-word;
}
.gitment-editor-avatar{
  color: #555;
  border-bottom: none;
  text-decoration: none;
  word-wrap: break-word;
}
```
第一个就是修改的ID下的横线，显示为`none`就好了；第二个是修改编辑框头像下的横线，也是显示为`none`。

这样，算是完成了Gitment的配置了。

---

## 设置自定义页面不显示Sidebar

主题配置文件中是这样的
```yaml
toc:
  enable: true
  number: true
  wrap: false
sidebar:
  position: left
  display: post
```
讲道理这样就是是没有问题的，但是我发现自定义的页面里如果写了太多的`#`或者`<h1>`，就会被识别为`post`类型而不是`page`，也就是博客文章，会被自动加载目录，这就很蛋疼了不是，毕竟有的页面不想要目录啊尴尬！！！

{% cq %}一般这种样式问题都在`layout`文件夹中找原因。{% endcq %}

<s>在`themes\next\layout\_macro\sidebar.swig`，找到开头的
```html
{% macro render(is_post) %}
  <div class="sidebar-toggle">
    <div class="sidebar-toggle-line-wrap">
      <span class="sidebar-toggle-line sidebar-toggle-line-first"></span>
      <span class="sidebar-toggle-line sidebar-toggle-line-middle"></span>
      <span class="sidebar-toggle-line sidebar-toggle-line-last"></span>
    </div>
  </div>
```
在下面加上
```
{% if page.toc and theme.toc.enable %}
```
然后在倒数第二行加上
```
{% endif %}
```
</s>

发现这样修改有bug，重新改。在`themes\next\layout\_macro\sidebar.swig`找到这一句
```
{% set display_toc = is_post and theme.toc.enable or is_page and theme.toc.enable %}
```
改为
```
{% set display_toc = is_post and theme.toc.enable or is_page and page.toc or is_page and theme.toc.enable and page.toc %}
```
其实就是多加一个判断，判断页面的开头有没有`toc`属性

最后，在需要有sidebar目录的文章前加上`toc: true`即可。

为了以后的方便，可以在`scaffolds\post.md`中加上`toc: true`。
<br>
<p id="div-border-top-green"><i>最后要说的是：[博客源码](https://github.com/fakeYanss/fakeYanss.github.io.source) ， 欢迎 star</i></p>