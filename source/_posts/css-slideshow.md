---
title: css轮播图
tags:
  - css3
  - animation
date: 2017-09-13 10:42:00
---
本文介绍一种css实现首页轮播图效果的方法，主要用css3的animation属性。
<!--more-->

---

** 本文转自[知乎](https://zhuanlan.zhihu.com/p/25033131)**

由于css无法做到js一样的精准操控，所有某些效果是无法实现的，比如在轮播的同时支持用户左右滑动，所以使用css只能实现基本的效果。下面列出来的内容就是我们实现的：

1. 在固定区域中，内部内容自行滑动切换形成播放的效果
2. 当切换到最后一张内容时，会反向播放或者回到起点重播
3. 每张内容会停留一段时间，让用户能够看清楚
4. 内容可以点击/进行操作

## dom结构搭建
首先要有一个容器作为轮播图的容器，同时由于要实现滑动切换，所以内部需要有一个装载所有待切换内容的子容器

如果子容器中的内容是左右切换的，则需要将内容左右排列开

下面以轮播图片为例，上代码
```html
<div class="loop-wrap">
    <div class="loop-images-container">
        <img src="darksky.jpg" alt="" class="loop-image">
        <img src="starsky.jpg" alt="" class="loop-image">
        <img src="whiteland.jpg" alt="" class="loop-image">
        <img src="darksky.jpg" alt="" class="loop-image">
        <img src="starsky.jpg" alt="" class="loop-image">
    </div>
</div>
```
`.loop-wrap` 是主容器

`.loop-images-container` 是承载内部图片的子容器

`.loop-image` 是图片内容，如果需要显示其他内容，可以自定义

## css实现静态效果

轮播图内每一页内容的宽高应该相同，且等于主容器.loop-wrap宽高

`.loop-images-container`的宽高必然有一个大于外部主容器，`overflow`属性应该设置为`hidden`。那为什么不设置为`auto`呢？我不告诉你，你可以自己试试看
(这里原因是auto属性会在内容超出时自动加载出容器的下拉条)
```css
.loop-wrap {
    position: relative;
    width: 500px;
    height: 300px;
    margin: 100px auto;
    overflow: hidden;
}

.loop-images-container{
    position: absolute;
    left: 0; top: 0;
    width: 500%; /* 横向排列 5张图片 宽度应为主容器5倍 */
    height: 100%;
    font-size: 0;
}

.loop-image{
    width: 500px;
    height: 300px;
}
```

## css实现轮播效果
轮播效果说到底就是一个动画效果，而通过css3的新属性 `animation` 我们就可以自定义一个动画来达到轮播图效果。下面先来了解一下 `animation` 这个属性
```
/*
animation: name duration timing-function delay iteration-count direction

name: 动画名
duration： 动画持续时间 设置为0则不执行
timing-function：动画速度曲线
delay：动画延迟开始时间 设置为0则不延迟
iteration-count：动画循环次数 设置为infinite则无限次循环
direction：是否应该轮流反向播放动画 normal 否 alternate 是
*/
```
`animation` 的 `name` 值是动画名，动画名可以通过 `@keyframes` 创建自定义动画规则

## 分析动画
要实现轮播，本质上是使内部承载内容的子容器 `.loop-images-container` 进行位移，从而使不同位置的内容一次展示在用户眼前

共有五张图片需要展示，如果轮播总耗时10s，那么每张图片应该有2s的时间(20%)，而每张图片耗时的构成是切换耗时+展示耗时，如果切换耗时500ms(5%)，展示耗时就应该是1500ms(15%)

于是这样改造css
```css
.loop-images-container{
    position: absolute;
    left: 0; top: 0;
    width: 500%;
    height: 100%;
    font-size: 0;
    transform: translate(0,0); /* 初始位置位移 */
    animation: loop 10s linear infinite;
}

/* 创建loop动画规则 */
/* 
   轮播5张，总耗时10s，单张应为2s(20%)
   单张切换动画耗时500ms，停留1500ms
*/
@keyframes loop {
    0% {transform: translate(0,0);}
    15% {transform: translate(0,0);} /* 停留1500ms */

    20% {transform: translate(-20%,0);} /* 切换500ms 位移-20% */
    35% {transform: translate(-20%,0);}

    40% {transform: translate(-40%,0);}
    55% {transform: translate(-40%,0);}

    60% {transform: translate(-60%,0);}
    75% {transform: translate(-60%,0);}

    80% {transform: translate(-80%,0);}
    95% {transform: translate(-80%,0);}

    100% {transform: translate(0,0);} /* 复位到第一张图片 */
}
```

这是一个方向的轮播效果，想要实现往返方向的轮播效果，小伙伴们可以试试`direction`的`alternate`，但是自定义动画规则的时间间隔也要重新计算了哦！

以下是所有代码：
```html
<!DOCTYPE html>
<html>
<head>
	<title></title>
<style type="text/css">
.loop-wrap {
    position: relative;
    width: 500px;
    height: 300px;
    margin: 100px auto;
    overflow: hidden;
}

.loop-images-container{
    position: absolute;
    left: 0; top: 0;
    width: 500%; /* 横向排列 5张图片 宽度应为主容器5倍 */
    height: 100%;
    font-size: 0;
    transform: translate(0,0); /* 初始位置位移 */
    animation: loop 10s linear infinite;
}

.loop-image{
    width: 500px;
    height: 300px;
}

@keyframes loop {
    0% {transform: translate(0,0);}
    15% {transform: translate(0,0);} /* 停留1500ms */

    20% {transform: translate(-20%,0);} /* 切换500ms 位移-20% */
    35% {transform: translate(-20%,0);}

    40% {transform: translate(-40%,0);}
    55% {transform: translate(-40%,0);}

    60% {transform: translate(-60%,0);}
    75% {transform: translate(-60%,0);}

    80% {transform: translate(-80%,0);}
    95% {transform: translate(-80%,0);}

    100% {transform: translate(0,0);} /* 复位到第一张图片 */
}
</style>
</head>
<body>
	<div class="loop-wrap">
    <div class="loop-images-container">
        <img src="1.jpg" alt="" class="loop-image">
        <img src="2.jpg" alt="" class="loop-image">
        <img src="3.jpg" alt="" class="loop-image">
        <img src="4.jpg" alt="" class="loop-image">
        <img src="5.jpg" alt="" class="loop-image">
    </div>
</div>
</body>
</html>
```

## 总结 

虽然css也能实现轮播效果，但是相对于js实现来说，功能性就弱了很多，无法控制暂停与播放，无法与用户产生交互，无法监听到状态的而变化等等，但是好处也很明显嘛！那就是简单。

<br>
<p id="div-border-top-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>