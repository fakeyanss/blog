---
title: Java不用for循环打印数组
categories:
  - Java
tags:
  - Array
mathjax: false
copyright: true
reward: true
toc: true
kewords: 'Java,Array'
abbrlink: 8576f9e7
date: 2018-01-27 17:31:47
description:
password:
---

# ArrayList直接打印

```java
ArrayList<Integer> list = new ArrayList<>();
list.add(1);
list.add(2);
list.add(3);
list.add(4);
System.out.println(list);
```

输出
```
[1, 2, 3, 4]
```

# Arrays类打印数组
java.util.Arrays的toString()方法
```java
System.out.println(Arrays.toString(new int[] {1, 2, 3, 4}));
```
输出
```
[1, 2, 3, 4]
```

# Arrays类打印二维数组
java.util.Arrays的deeptoString()方法
```java
System.out.println(Arrays.deepToString(new int[][] {{1, 2}, {3, 4}}));
```
输出
```
[[1, 2], [3, 4]]
```
<br>
<p id="div-border-top-green"><i>最后要说的是：博客源码 ， 欢迎 star</i></p>


