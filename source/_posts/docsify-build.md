---
title: docsify 折腾记
date: 2021-05-09 15:42:18
tags: docsify
---

docsify，专为喜欢折腾的你。

<!-- more -->

## 使用体验

五一回家只带了公司笔记本，没什么娱乐软件，所以闲时刷了下 Github，发现一个 [TIL(things I learn)](https://github.com/Bhupesh-V/til) 项目挺好的，于是 clone 下来做了一个自己的项目，这是[我的 TIL](https://foreti.me/til/#/) 记录。

TIL 本意是记录自己学到的知识点。实际工作中会经常遇到问题并解决问题，长期以来并没有刻意记录，有些问题单凭记忆会在一段时间后忘记。

原项目中是依赖 Gitbook 做的文本渲染，按照我几年前的使用经历来看，Gitbook不算好用，并且在国内访问速度堪忧，所以我在这里选择了 [docsify](https://docsify.js.org/#/)。

docsify 是一个类似 Gitbook 将 Markdown 文件选染成 HTML 页面的工具。当然也有一定差别，Gitbook 是提前编译成 HTML 静态页面，而 docsify 是请求时渲染。在使用上来看，docsify 的速度更快，也更简单一些，可自定义的配置非常多，适用于喜欢自己动手的开发者。
docsify 功能非常丰富，不过基本界面样式比较简单。

值得吐槽的是右上角repo角标太大了，和navbar菜单并在一起太丑陋了。

![image-20210509161029217](https://cdn.jsdelivr.net/gh/fakeyanss/imgplace@master/2021/2021-05-09_image-20210509161029217-05ff56.png)

其他的一些插件，比如 「edit on github」 与 「字数插件」 会将正文内容往下挤，也很别扭。

![image-20210509161238605](https://cdn.jsdelivr.net/gh/fakeyanss/imgplace@master/2021/2021-05-09_image-20210509161238605-8f3c7c.png)

官方文档里没有浅色模式与深色模式的灵活适配，只单一支持了浅色或深色主题，也就是说只能选择一种。

如果想同时支持浅色和深色，目前有两个方法：

1. 有一个第三方主题插件，[docsify darklight theme](https://docsify-darklight-theme.boopathikumar.me/#/)，安装即用，提供一个按钮手动切换，不过问题是仍然是按钮将正文内容往下挤压。我添加了一段JS方法，强制将按钮移到左侧sidebar。
2. 自定义css，支持跟随系统深色模式，自动切换。实现方式类似我的blog，目前还没有时间开发。

## 开始构建

首先需要本地具备 node 和 npm 环境，选择最新的稳定版本即可。

安装 docsify-cli：

```bash
npm install -g docsify-cli
```

创建 Git 仓库，并且初始化 docsify：

```bash
mkdir docsify-demo && cd docsify-demo
docsify init docs
```

这之后会自动创建出 docs 目录，其中会有一个 `index.html` 文件。

可以本地预览了：

```bash
docsify serve docs
```

然后，可以编辑 `index.html`：

```html
window.$docsify = {
	name: 'Things I Learn',
	loadSidebar: true,
	loadNavbar: true,
	search: 'auto',
	// 下面按照文档添加各种插件即可
	...
}
```

可以在 docs 目录下创建这些文件：

- 一个空的 `.nojekyll` 文件，用于阻止 Github Page 忽略下划线开头的文件；
- `_sidebar.md` 文件，自定义左侧边栏目录；
- `_navbar.md` 文件，自定义右上角菜单栏。

可以安装 [docsify-tool](https://www.npmjs.com/package/docsify-tools) 依赖，我只用它来自动生成 `_sidebar.md` 内容：

```bash
npm i -g docsify-tools
docsify-auto-sidebar -d docs
```

`docsify-auto-sidebar` 会将指定 docs 目录下所有 Markdown 文件识别为目录内容，所以会将 `_navbar.md` 也将到目录里，我写了一个 Git pre-commit hook 来阻止这个动作。

在项目根目录，`vim .git/hooks/pre-commit`，填入：

```bash
docsify-auto-sidebar -d docs
# 替换，二选一
sed -i "" "/_navbar/d" docs/_sidebar.md # mac
sed -i "/_navbar/d" docs/_sidebar.md # linux
git add .
```

## 评论系统

docsify 支持 Disqus 和 [Gitalk](https://github.com/gitalk/gitalk) 两种评论系统。Disqus 在国内不太好用，所以我选择试试 Gitalk。

按照 docsify 的文档，很简单的使用上了 Gitalk 评论，但是在使用中发现满满的都是坑。

我这里主要问题是某些文章加载评论时报错 `Error: Validation Failed`。

Gitalk 依托于 Github issue 存在，并且使用 issue label 和文章一一关联，issue label 有个限制是字符串长度需不超过 50。

然而 docsify 默认和 Gitalk 的集成，创建 issue 时使用的 label 是当前页面的 `location.href`，也即是 URL 全文，这也太容易超过 50 了吧🥲。

在 Gitalk 文档中，也有说明 id 属性，默认使用 `location.href`：

>**id** `String`
>
>Default: `location.href`.
>
>页面的唯一标识。长度必须小于50。

在网上找到的解决方案，是手动设置 id 属性，对 href 做一次 md5，固定到 32 位。看起来很不错，引用了一个 md5 库之后，很简单搞定了。然而实际应用发现 docsify 切换页面时，路由经常没有自动刷新，导致各种奇奇怪怪的gitalk初始化问题，然后创建出的 issue 烂七八糟，而且经常在 A 页面写的评论在 B 页面可以加载出来。我猜测还是路由回调的问题，但我看不懂源码，没法解决。

然后在 Github 找了一些使用 docsify 写的项目文档，发现一个 [l-hammer/You-need-to-know-css](https://github.com/l-hammer/You-need-to-know-css)，效果很好并且评论没有问题。

读了这个项目的实现，发现没有依赖 docsify 对 Gitalk 的集成，直接引入的 Gitalk 依赖，并且在路由回调中初始化 gitalk 实例。

大概实现如下：

```js
gitalkConfig = {
    clientID: "xxx", // your github oauth app client id
    clientSecret: "xxx", //your github oauth app client screct key
    repo: "til", //your github repo name
    owner: "fakeYanss", //your github user name
    admin: ["fakeYanss"], //your gitalk administrators
    perPage: 20,
    language: "en",
    labels: ["Gitalk"],
    distractionFreeMode: false
};
plugins: [
    function (hook, vm) {
        hook.doneEach(function () {
            var label, domObj, main, divEle, gitalk;
            label = vm.route.path.split("/").pop();
            domObj = Docsify.dom;
            main = domObj.getNode("#main");

            /**
             * render gittalk
             */
            if (vm.route.path.includes("zh-cn")) {
                gitalkConfig.language = "zh-CN";
            }
            Array.apply(
                null,
                document.querySelectorAll("div.gitalk-container")
            ).forEach(function (ele) {
                ele.remove();
            });
            divEle = domObj.create("div");
            divEle.id = "gitalk-container-" + label;
            divEle.className = "gitalk-container";
            divEle.style = "width: " + main.clientWidth + "px; margin: 0 auto 20px;";
            domObj.appendTo(domObj.find(".content"), divEle);
            gitalk = new Gitalk(
                Object.assign(gitalkConfig, {
                    id: !label ? "home" : label
                })
            );
            gitalk.render("gitalk-container-" + label);
        })
    }
]
```

最后效果是这样，label 使用的是 location.hash 的尾部按 `/` 分割后的最后一段内容，其实就是每个 Markdown 文件名，到这一步已经很容易控制不超过 50 位长度了。

![image-20210509172714680](https://cdn.jsdelivr.net/gh/fakeyanss/imgplace@master/2021/2021-05-09_image-20210509172714680-b9cba4.png)



## 主题定制

### darklight

使用docsify darklight theme，按照文档说明，非常简单。

在 `index.html` 头部添加：

```html
<link 
    rel="stylesheet"
    href="//cdn.jsdelivr.net/npm/docsify-darklight-theme@latest/dist/style.min.css"
    title="docsify-darklight-theme"
    type="text/css"
/>
```

在底部添加：

```html
<script 
    src="//cdn.jsdelivr.net/npm/docsify-darklight-theme@latest/dist/index.min.js"
    type="text/javascript">
</script>
```

如果对默认的按钮展示位置满意，那可以到此结束了，下面是我的改动，将按钮移动到左侧边栏：

![image-20210509163856711](https://cdn.jsdelivr.net/gh/fakeyanss/imgplace@master/2021/2021-05-09_image-20210509163856711-ff5c45.png)

下载 [darklight 的 Javascript 源码](https://cdn.jsdelivr.net/npm/docsify-darklight-theme@latest/dist/index.min.js)，放到项目里，可以命名为 `theme.js`，移除远程引用，添加本地引用：

```html
<script src="theme.js"></script>
```

然后修改 `theme.js` 的一处方法，这里的 `afterEach` 是 docsify 路由变化完成后的回调函数，主题原生的写法就是在 `e` 前面简单添加一个 div 块，这也是按钮将正文内容向下挤压的原因。添加 else 分支是因为这块代码在每次路由变化后都会执行，我们需要让它只在第一次加载页面时创建按钮 div。

```js
e.afterEach((function (e, o) {
    if (document.getElementById('docsify-darklight-theme') == null) {
        o(e = '<div id="docsify-darklight-theme"><p>.</p></div>' + e)
    } else {
        o(e)
    }
}))
```

源码是编译过的，为了避免找不到在哪，这里是我改过的 [theme.js](https://raw.githubusercontent.com/fakeYanss/til/master/docs/dist/theme.js) 下载地址。

由于没有深入阅读 docsify 的主要源码，不确定这处方法怎么直接改动，所以在外面另外写了一处脚本作为后置处理，将按钮 append 到侧边栏的 DOM 下。在 `index.html` 中，添加一段 script：

```html
<script>
    function move() {
      document.getElementsByClassName('sidebar')[0].setAttribute('id', 'sidebar-full')
      document.getElementById('sidebar-full').appendChild(document.getElementById('docsify-darklight-theme'))
      var button = document.getElementById('docsify-darklight-theme')
      button.style.position = 'fixed'
      button.style.left = '10px'
      button.style.bottom = '58px'
      button.style.top = 'auto'
      button.style.width = '18px'
      button.style.height = '18px'
    }
    var refreshId = setInterval(function () {
      if (null != document.getElementById('docsify-darklight-theme')) {
        move();
        clearInterval(refreshId);
      }
    }, 100);
</script>
```



如果觉得侧边栏问题太挤，可以再调整下样式：

```css
<style>
.sidebar-nav ul li {
    margin-left: 25px;
}

.sidebar-nav {
    line-height: 1.5em !important;
    padding-bottom: 76px;
}
</style>
```

### prefers-color-scheme

`prefers-color-scheme` 是 CSS media feature 对黑暗模式的支持，[详细文档在此](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme)。

按照[我的博客](https://foreti.me/blog/)的做法，只需设计下黑暗模式的背景颜色、字体颜色、代码块颜色、超链接颜色，基本效果就有了。

细节待开发...

---

