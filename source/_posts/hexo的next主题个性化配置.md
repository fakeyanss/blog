---
title: hexo的next主题个性化配置
categories:
  - Solution
copyright: true
reward: true
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

## 修改作者头像并旋转

打开`\themes\next\source\css\_common\components\sidebar\sidebar-author.styl`，在里面添加如下代码：

```
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

## 添加相册

我的[相册](http://yanss.top/photos/)。原理很简单，就是建立一个github仓库存储用于存储图片，然后将每个图片的路径保存到一个json文件里，在hexo博客中解析这个json文件，渲染成html页面后就可以在显示图片了。当然这里肯定要有页面的样式和图片的裁剪压缩，原理简单，实际操作起来有一些坑，我并不懂css样式，还是要感谢[litten](https://github.com/litten/BlogBackup/tree/master/source/photos)提供的方法。

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

```
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

```
var minSrc = 'https://raw.githubusercontent.com/fakeYanss/Blog_Album/master/min_photos/' + data.link[i];
var src = 'https://raw.githubusercontent.com/fakeYanss/Blog_Album/master/photos/' + data.link[i];
```

如果你的仓库名和我相同，只用把这里的`fakeYanss`改为你自己的github name即可

* 在`yourBlog/themes/next/source/js/src`下加入两个js文件[photoswipe.min.js](https://github.com/fakeYanss/fakeYanss.github.io.source/blob/master/themes/next/source/js/src/photoswipe.min.js) 和[photoswipe-ui-default.min.js](https://github.com/fakeYanss/fakeYanss.github.io.source/blob/master/themes/next/source/js/src/photoswipe-ui-default.min.js)


* 在`yourBlog/themes/next/layout/_scripts/pages/post-details.swig`中添加

```
<script type="text/javascript" src="{{ url_for(theme.js) }}/src/photoswipe.min.js?v={{ theme.version }}"></script>
<script type="text/javascript" src="{{ url_for(theme.js) }}/src/photoswipe-ui-default.min.js?v={{ theme.version }}"></script>
```

* 在`yourBlog/themes/next/layout/_layout.swig`中

`head`内插入

```
<script src="{{ url_for(theme.js) }}/src/photoswipe.min.js?v={{ theme.version }}"></script>
<script src="{{ url_for(theme.js) }}/src/photoswipe-ui-default.min.js?v={{ theme.version }}"></script>
```

`body`内插入

```
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
  * 最后的不足是，相片的裁剪算法不算好，比如会[这样](https://github.com/fakeYanss/Blog_Album/blob/master/photos/2017-9-17_ICIP2017.JPG)，还有的会[这样](https://github.com/fakeYanss/Blog_Album/blob/master/photos/2017-9-19_%E8%83%A1%E5%90%8C1302.JPG)
  * next主题源码是不支持相册的，如果有不懂的地方，可以去查一下[yilia](https://github.com/litten/hexo-theme-yilia)主题的issue，然后再来问我


<br>

<p id="div-border-top-green"><i>最后要说的是：[博客源码](https://github.com/fakeYanss/fakeYanss.github.io.source) ， 欢迎 star</i></p>