---
title: 初识机器学习
tags:
  - supervised learning
  - unsupervised learning
date: 2018-01-12 15:01:20
---
关于机器学习，这是我学的第一节课。
<!-- more -->

---

<center>
    <img style="border-radius: 0.3125em; box-shadow: 0 2px 4px 0 rgba(34,36,38,.12),0 2px 10px 0 rgba(34,36,38,.08);" 
    src="https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190502110338.png">
    <div style="border-bottom: 1px solid #d9d9d9; display: inline-block; color: #999; padding: 2px;">Machine learning</div>
</center>

## Machine learning

**Machine learning definition:**

* Arthur Samuel (1959) . 在没有明确设置的前提下，使机器具有学习能力的研究领域。

* Tom Mitchell (1998) . 一个适当的学习问题定义如下：计算机程序从经验E中学习，解决某一任务T，进行某一性能度量P，通过P测试在T上的表现因经验E而提高。

  对于跳棋游戏（Samuel设计的一个小游戏，通过数万次跳棋对战学习，获得比Samuel的跳棋水平还高的能力），经验E就是程序与自己下几万次跳棋，任务T就是玩跳棋，性能度量P就是与新对手玩跳棋时赢的概率。

**Machine learning algorithms:**

目前学习算法主要的两类是监督学习(supervised learning)和无监督学习(unsupervised learning)。

简单来说，监督学习就是我们教计算机做某件事情；在无监督学习中，我们让计算机自己学习。

**Others:**

强化学习(Reinforcement learning), 推荐系统(recommender systems)

## Supervised Learning

**监督学习**：我们给算法一个数据集，其中包含了正确答案，算法的目的就是给出更多的正确答案。

**回归(Regression)**：预测连续的数值输出。

**分类(Classification)**：预测一个离散值输出。

示例：房子的价格与房子面积的关系(回归问题)；肿瘤是恶性或良性与肿瘤大小，患者年龄，肿瘤块厚度等的关系(分类问题)。

<br>

下面一个问题。problem1将要卖的货物数量看成一个连续的值，属于回归问题；problem2输出的值可能为0或1，分别表示两种不同的结果，属于分类问题。

![ML1](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190429231017.png)

## Unsupervised Learning

**无监督学习**：对于数据集中的每一个样本，都具有相同标签或都没有标签，我们不知道要拿数据做什么，也不知道每个数据点究竟是什么，只能在数据集种找到某种结构(簇)，它们具有类似的性质。**聚类(clustering)**是无监督学习的一种 。

**Cocktail party problem 鸡尾酒会问题**

编程环境Octave或Matlab

解决代码

$$[W,s,v]=svd((repmat(sum(x.^\*x,1),size(x,1),1).^\*x)^\*x')$$

$svd$ 是奇异值分解的缩写，在Octave中作为一个内置函数。

<br>

下面一个问题，哪些选项要使用无监督学习算法？

![ML2](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190429231037.png)

<br>

---

<p id="div-border-left-red"><i>DigitalOcean 优惠码，注册充值 $5 送 $100，[链接一](https://m.do.co/c/282d5e1cf06e) [链接二](https://m.do.co/c/5eefb87c26cd)</i></p>
<p id="div-border-left-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>