title: Spring @RequestMapping详解
date: 2019-03-02
tags: [ARTS,Spring,RequestMapping]
---
201902W9 Review, 一篇关于Spring RequestMapping的译文
<!-- more -->

# Spring RequestMapping
[原文](https://www.baeldung.com/spring-requestmapping)
by [Eugen Paraschiv](https://www.baeldung.com/author/eugen/)

## 1. 概述
在这篇文章中，我们将关注于这个Spring MVC中常用的注释 - @RequestMapping。

简单地说，这个注释用于将网络请求映射到Spring Controller的方法。

## 2. @RequestMapping基础
让我们从一个简单的例子开始 - 按照一些基本的标准将一个HTTP请求映射到一个方法。

### 2.1. @RequestMapping - 按路径
```java
@RequestMapping(value = "/ex/foos", method = RequestMethod.GET)
@ResponseBody
public String getFoosBySimplePath() {
    return "Get some Foos";
}
```
要使用简单的*curl*命令测试此映射，请运行：
```sh
curl -i http://localhost:8080/spring-rest/ex/foos
```

### 2.2. @RequestMapping - HTTP方法
HTTP方法参数没有默认值 - 因此，如果我们不指定值，它将映射到任何HTTP请求。

这是一个简单的示例，类似于前一个示例 - 但这次映射到一个HTTP POST请求：
```java
@RequestMapping(value = "/ex/foos", method = POST)
@ResponseBody
public String postFoos() {
    return "Post some Foos";
}
```
要通过*curl*命令测试POST ：
```sh
curl -i -X POST http://localhost:8080/spring-rest/ex/foos
```

## 3. RequestMapping 和 HTTP Headers

### 3.1. 带有 headers Attribute 的 @RequestMapping 
给请求指定一个header，可以进一步限制映射范围。
```java
@RequestMapping(value = "/ex/foos", headers = "key=val", method = GET)
@ResponseBody
public String getFoosWithHeader() {
    return "Get some Foos with Header";
}
```
为了测试运行，我们将使用*curl*的header参数
```sh
curl -i -H "key:val" http://localhost:8080/spring-rest/ex/foos
```
更进一步，通过 *@RequestMapping*的 *header*属性实现多个header
```java
@RequestMapping(
  value = "/ex/foos", 
  headers = { "key1=val1", "key2=val2" }, method = GET)
@ResponseBody
public String getFoosWithHeaders() {
    return "Get some Foos with Header";
}
```
可以通过命令测试这个方法
```sh
curl -i -H "key1:val1" -H "key2:val2" http://localhost:8080/spring-rest/ex/foos
```
注意，对于*curl*语法，用冒号分离header的键和值，与HTTP中的规范相同，而在Spring中是用等号。

### 3.2. @RequestMapping 消费和生产
映射**由Controller产生的媒体类型**的方法特别值得注意 - 我们可以通过上面介绍的 *@RequestMapping* 的headers属性，基于*Accept* header映射请求。
```java
@RequestMapping(
  value = "/ex/foos", 
  method = GET, 
  headers = "Accept=application/json")
@ResponseBody
public String getFoosAsJsonFromBrowser() {
    return "Get some Foos with Header Old";
}
```
匹配这种定义*Accept* header的方法是灵活的 - 是用包含而不是等于，所以一个下面这样的请求也能正确地匹配。
```sh
curl -H "Accept:application/json,text/html" http://localhost:8080/spring-rest/ex/foos
```
从Spring 3.1开始， ***@RequestMapping*注释具有produces和consumes属性**，特别是为了这种：
```java
@RequestMapping(
  value = "/ex/foos", 
  method = RequestMethod.GET, 
  produces = "application/json"
)
@ResponseBody
public String getFoosAsJsonFromREST() {
    return "Get some Foos with Header New";
}
```
此外，带有*headers*属性的旧类型的映射将自动转换成Spring 3.1开始的新*produces*机制，所以结果是相同的。

同样的方式，通过*curl*进行consume：
```sh
curl -H "Accept:application/json" http://localhost:8080/spring-rest/ex/foos
```
另外，*produces*也支持多值：
```java
@RequestMapping(
  value = "/ex/foos", 
  method = GET,
  produces = { "application/json", "application/xml" }
)
```
记住这些 - 指定*accept* header的旧的方法和新的方法 - 基本上是相同的映射，所以Spring不允许它们一起使用 - 一起用将会导致：
```sh
Caused by: java.lang.IllegalStateException: Ambiguous mapping found. 
Cannot map 'fooController' bean method 
java.lang.String 
org.baeldung.spring.web.controller
  .FooController.getFoosAsJsonFromREST()
to 
{ [/ex/foos],
  methods=[GET],params=[],headers=[],
  consumes=[],produces=[application/json],custom=[]
}: 
There is already 'fooController' bean method
java.lang.String 
org.baeldung.spring.web.controller
  .FooController.getFoosAsJsonFromBrowser() 
mapped.
```
关于新的*produces*和*consumes*机制的最后一点 - 与其他注释表现不同的是 - 当指定类型级别时，方法级别的注释不会补充而会覆盖类型级别的信息。

这句没理解，原文
> when specified at the type level, **the method level annotations do not complement but override** the type level information.

当然，如果你想深入了解用Spring构建REST API - 请看[the new REST with Spring course](https://www.baeldung.com/rest-with-spring-course?utm_source=blog&utm_medium=web&utm_content=art1&utm_campaign=rws)。

## 4. RequestMapping使用路径变量
映射URL的一部分可以由 *@PathVariable* 绑定到变量。

一个简单的单路径变量例子：
```java
@RequestMapping(value = "/ex/foos/{id}", method = GET)
@ResponseBody
public String getFoosBySimplePathWithPathVariable(
  @PathVariable("id") long id) {
    return "Get a specific Foo with id=" + id;
}
```

可以用curl测试：

```sh
curl http://localhost:8080/spring-rest/ex/foos/1
```

如果方法的参数名和路径名相同，可以只用`@PathVariable`而不附加值：

```java
@RequestMapping(value = "/ex/foos/{id}", method = GET)
@ResponseBody
public String getFoosBySimplePathWithPathVariable(
  @PathVariable String id) {
    return "Get a specific Foo with id=" + id;
}
```





<br>
<p id="div-border-top-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>