---
title: Java不用for循环打印数组
date: 2018-01-27 17:31:47
---
Java中打印数组时不想用for遍历数组，可以试试下面几种方法

<!--more-->

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

---
<p id="div-border-left-red"><i>DigitalOcean 优惠码，注册充值 $5 送 $100，[链接一](https://m.do.co/c/282d5e1cf06e) [链接二](https://m.do.co/c/5eefb87c26cd)</i></p>
<p id="div-border-left-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>


