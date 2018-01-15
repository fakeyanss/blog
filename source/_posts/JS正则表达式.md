---
title: JS正则表达式
categories:
  - JavaScript
tags:
  - JavaScrit
  - regexp
copyright: true
abbrlink: bf9092f5
date: 2017-07-26 20:28:15
password:
---
> 正则表达式（英语：Regular Expression，在代码中常简写为regex、regexp或RE）使用单个字符串来描述、匹配一系列符合某个句法规则的字符串搜索模式。
> 搜索模式可用于文本搜索和文本替换。
> <!--more-->
## 语法

```
/正则表达式主体/修饰符(可选)
```
**实例：**
```
var patt = /abc/i
```
`/abc/i `是一个正则表达式

`abc` 是一个**正则表达式主体**（用于检索） 

`i`是一个**修饰符**（搜索不区分大小写）

---

##  使用字符串方法

### search() 方法

> 用于检索字符串中指定的子字符串，或检索与正则表达式相匹配的子字符串，并返回子串的起始位置。

**实例**

使用正则表达式搜索"Runoob"字符串，且不区分大小写：
```
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>菜鸟教程(runoob.com)</title>
</head>
<body>

<p>搜索字符串 "runoob", 并显示匹配的起始位置：</p>
<button onclick="myFunction()">点我</button>
<p id="demo"></p>
<script>
function myFunction() {
    var str = "Visit Runoob!"; 
    var n = str.search(/Runoob/i);
    document.getElementById("demo").innerHTML = n;
}
</script>

</body>
</html>
```
输出结果为：
```
6
```
### replace() 方法

> 用于在字符串中用一些字符替换另一些字符，或替换一个与正则表达式匹配的子串。

**实例**

使用正则表达式且不区分大小写将字符串中的 Microsoft 替换为 Runoob :

```
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>菜鸟教程(runoob.com)</title>
</head>
<body>

<p>替换 "microsoft" 为 "Runoob" :</p>
<button onclick="myFunction()">点我</button>
<p id="demo">请访问 Microsoft!</p>
<script>
function myFunction() {
    var str = document.getElementById("demo").innerHTML; 
    var txt = str.replace(/microsoft/i,"Runoob");
    document.getElementById("demo").innerHTML = txt;
}
</script>

</body>
</html>
```
**结果输出为：**
```
Visit Runoob!
```

---

## 使用RegExp对象
> 在 JavaScript 中，RegExp 对象是一个预定义了属性和方法的正则表达式对象。

### test() 方法

> 用于检测一个字符串是否匹配某个模式。
> 如果字符串中有匹配的值返回 true ，否则返回 false。

**语法: **
```
RegExpObject.test(string)
```

**实例：**

```
<script>

var str="Hello world!";
//look for "Hello"
var patt=/Hello/g;
var result=patt.test(str);
document.write("Returned value: " + result); 

//look for "W3CSchool"
patt=/W3CSchool/g;
result=patt.test(str);
document.write("<br>Returned value: " + result);

</script>
```

**输出：**
```
Returned value: true
Returned value: false
```

### exec() 方法

> 用于检索字符串中的正则表达式的匹配。
> 如果字符串中有匹配的值返回该匹配值，否则返回 null。

**语法：**
```
RegExpObject.exec(string)   
```
**实例：**
```
<script>

var str="Hello world!";
//look for "Hello"
var patt=/Hello/g;
var result=patt.exec(str);
document.write("Returned value: " + result); 

//look for "W3Schools"
patt=/W3Schools/g;
result=patt.exec(str);
document.write("<br>Returned value: " + result);

</script>
```

**输出：**
```
Returned value: Hello
Returned value: null
```
---

## 正则表达式修饰符
| 修饰符  | 描述           |
| ---- | ------------ |
| i    | 执行对大小写不敏感的匹配 |
| g    | 执行全局匹配       |
| m    | 执行多行匹配       |

## 正则表达式模式

**方括号**用于查找某个范围内的字符

| 表达式    | 描述           |
| ------ | ------------ |
| [abc]  | 查找方括号之间的任何字符 |
| [0-9]  | 查找任何从0至9的数字  |
| (x\|y) | 查找任何以\|分隔的选项 |

**元字符**是拥有特殊含义的字符

| 元字符    | 描述                       |
| ------ | ------------------------ |
| \d     | 查找数字                     |
| \s     | 查找空白字符                   |
| \b     | 匹配单词边界                   |
| \uxxxx | 查找以十六进制数xxxx规定的Unicode字符 |

**量词**

| 量词   | 描述               |
| ---- | ---------------- |
| n+   | 匹配任何包含至少一个n的字符串  |
| n*   | 匹配任何包含零个或多个n的字符串 |
| n?   | 匹配任何包含零个或一个n的字符串 |

<p id="div-border-top-green"><i>[博客源码](https://github.com/fakeYanss/fakeYanss.github.io.source) ， 欢迎 star</i></p>