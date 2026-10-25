---
title: Spring @RequestMapping详解
date: 2019-03-02
tags: [Review,Spring,RequestMapping]
---
201902W9 Review, 一篇关于Spring RequestMapping的译文。

<!-- more -->

---

# Spring RequestMapping
[原文](https://www.baeldung.com/spring-requestmapping)
by [Eugen Paraschiv](https://www.baeldung.com/author/eugen/)

## 1. 概述
在这篇文章中，我们将关注于这个Spring MVC中常用的注释 - @RequestMapping。

简单地说，这个注释用于将网络请求映射到Spring Controller的方法。

## 2. *@RequestMapping*基础
让我们从一个简单的例子开始 - 按照一些基本的标准将一个HTTP请求映射到一个方法。

### 2.1. *@RequestMapping* - 按路径
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

### 2.2. *@RequestMapping* - HTTP方法
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

### 3.1. 带有headers Attribute的*@RequestMapping*
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

### 3.2. *@RequestMapping* 消费和生产
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

## 4. *RequestMapping*使用路径变量

映射URI的一部分可以通过 *@PathVariable*注解绑定到变量。

### 4.1 单个 *@PathVariable*
一个简单的单路径变量例子：
```java
@RequestMapping(value = "/ex/foos/{id}", method = GET)
@ResponseBody
public String getFoosBySimplePathWithPathVariable(
  @PathVariable("id") long id) {
    return "Get a specific Foo with id=" + id;
}
```
可以用*curl*测试：
```sh
curl http://localhost:8080/spring-rest/ex/foos/1
```
如果方法的参数名和路径名相同，可以只用 *@PathVariable* 而不附加值：
```java
@RequestMapping(value = "/ex/foos/{id}", method = GET)
@ResponseBody
public String getFoosBySimplePathWithPathVariable(
  @PathVariable String id) {
    return "Get a specific Foo with id=" + id;
}
```
注意 *@PathVariable* 受利于自动类型转换，所以我们也可以修饰id为：
```java
@PathVariable long id
```

### 4.2 多个 *@PathVariable*

更复杂的URI可能需要映射URI的多个部分到多个值：
```java
@RequestMapping(value = "/ex/foos/{fooid}/bar/{barid}", method = GET)
@ResponseBody
public String getFoosBySimplePathWithPathVariables
  (@PathVariable long fooid, @PathVariable long barid) {
    return "Get a specific Bar with id=" + barid + 
      " from a Foo with id=" + fooid;
}
```
同样这可以用*curl*容易的测试：
```sh
curl http://localhost:8080/spring-rest/ex/foos/1/bar/2
```

### 4.3 带正则表达式的 *@PathVariable*

正则表达式也能用来映射 *@PathVariable*；举个例子，我们可以限制映射id只接受数字类型的值：
```java
@RequestMapping(value = "/ex/bars/{numericId:[\\d]+}", method = GET)
@ResponseBody
public String getBarsBySimplePathWithPathVariable(
  @PathVariable long numericId) {
    return "Get a specific Bar with id=" + numericId;
}
```
这将意味着下面的URI可以适配：
```
http://localhost:8080/spring-rest/ex/bars/1
```
但这个不能：
```
http://localhost:8080/spring-rest/ex/bars/abc
```

## 5. *RequestMapping*使用Request Parameters

@RequestMapping允许方便的使用 *@RequestParam*注解映射URL参数。

我们现在映射一个这样的URI请求：
```
http://localhost:8080/spring-rest/ex/bars?id=100
```

```java
@RequestMapping(value = "/ex/bars", method = GET)
@ResponseBody
public String getBarBySimplePathWithRequestParam(
  @RequestParam("id") long id) {
    return "Get a specific Bar with id=" + id;
}
```
我们接着在controller方法中使用 *@RequestParam(“id”)* 注解取出*id*参数的值。

要发送带*id*参数的请求，我们在*curl*中使用参数支持：
```sh
curl -i -d id=100 http://localhost:8080/spring-rest/ex/bars
```

在这个例子中，参数直接绑定而不先声明。

对于更进一步的场景， *@RequestMapping*有可选的参数定义 - 作为又一个限制请求映射的方法：
```java
@RequestMapping(value = "/ex/bars", params = "id", method = GET)
@ResponseBody
public String getBarBySimplePathWithExplicitRequestParam(
  @RequestParam("id") long id) {
    return "Get a specific Bar with id=" + id;
}
```
甚至可以更灵活的映射 - 可以设置多个*params*值，并且不是所有都使用：
```java
@RequestMapping(
  value = "/ex/bars", 
  params = { "id", "second" }, 
  method = GET)
@ResponseBody
public String getBarBySimplePathWithExplicitRequestParams(
  @RequestParam("id") long id) {
    return "Narrow Get a specific Bar with id=" + id;
}
```
当然，一个像这样的请求URI：
```
http://localhost:8080/spring-rest/ex/bars?id=100&second=something
```
将总会被映射到最好的适配 - 更进一步的适配，同时定义*id*和*second*参数。

## 6. *RequestMapping* Corner Cases

### 6.1. *@RequestMapping* – 多个路径映射到同一Controller方法

虽然一个单个 *@RequestMapping*路径值通常用于单个controller方法， 但这只是一种好的用法，而不是强制规则 - 有一些情况下，多个请求到同一方法的可能是必要的。在那种情况下， **@RequestMapping的value属性接收多个映射**，而不是一个映射：
```java
@RequestMapping(
  value = { "/ex/advanced/bars", "/ex/advanced/foos" }, 
  method = GET)
@ResponseBody
public String getFoosOrBarsByPath() {
    return "Advanced - Get some Foos or Bars";
}
```
现在，这两个*curl*命令应该使用相同的方法：
```sh
curl -i http://localhost:8080/spring-rest/ex/advanced/foos
curl -i http://localhost:8080/spring-rest/ex/advanced/bars
```

### 6.2. *@RequestMapping* – 多个HTTP请求方法到同一个controller方法

用不同HTTP请求方式的多个请求可以被映射到同一个Controller方法：
```java
@RequestMapping(
  value = "/ex/foos/multiple", 
  method = { RequestMethod.PUT, RequestMethod.POST }
)
@ResponseBody
public String putAndPostFoos() {
    return "Advanced - PUT and POST within single method";
}
```
用*curl*，这些请求都被打到同一个方法：
```java
curl -i -X POST http://localhost:8080/spring-rest/ex/foos/multiple
curl -i -X PUT http://localhost:8080/spring-rest/ex/foos/multiple
```

### 6.3. *@RequestMapping* - 对所有请求的返回

对所有请求实现一个返回，可以使用一个特别的HTTP方法 - 例如，对GET方法：
```java
@RequestMapping(value = "*", method = RequestMethod.GET)
@ResponseBody
public String getFallback() {
    return "Fallback for GET Requests";
}
```
或者对所有请求：
```java
@RequestMapping(
  value = "*", 
  method = { RequestMethod.GET, RequestMethod.POST ... })
@ResponseBody
public String allFallback() {
    return "Fallback for All Requests";
}
```

### 6.4 模糊映射错误

模糊映射错误发生与：当Spring评估两个或多个请求映射对于不同的Controller方法是相同的。当两个请求映射有同样的HTTP方法、URL、参数、头部和媒体类型时，它们就是相同的。例如，这是一个模糊映射：
```java
@GetMapping(value = "foos/duplicate")
public String duplicate() {
    return "Duplicate";
}
 
@GetMapping(value = "foos/duplicate")
public String duplicateEx() {
    return "Duplicate";
}
```
抛出的异常通常在这些行有异常信息：
```java
Caused by: java.lang.IllegalStateException: Ambiguous mapping.
  Cannot map 'fooMappingExamplesController' method 
  public java.lang.String org.baeldung.web.controller.FooMappingExamplesController.duplicateEx()
  to {[/ex/foos/duplicate],methods=[GET]}:
  There is already 'fooMappingExamplesController' bean method
  public java.lang.String org.baeldung.web.controller.FooMappingExamplesController.duplicate() mapped.
```
仔细阅读错误信息，指出Spring不能映射方法*org.baeldung.web.controller.FooMappingExamplesController.duplicateEx()* ，因为它与一个已经映射的*org.baeldung.web.controller.FooMappingExamplesController.duplicate()* 有冲突。

下面这个代码段将不会产生模糊映射错误，因为两个方法返回不同的内容类型：
```java
@GetMapping(value = "foos/duplicate", produces = MediaType.APPLICATION_XML_VALUE)
public String duplicate() {
    return "Duplicate";
}
 
@GetMapping(value = "foos/duplicate", produces = MediaType.APPLICATION_JSON_VALUE)
public String duplicateEx() {
    return "Duplicate";
}
```

## 7. 新的请求映射捷径

Spring Framework 4.3引入了[一些新的](https://www.baeldung.com/spring-new-requestmapping-shortcuts)HTTP映射注释，所有这些都基于 *@RequestMapping* ：

- **@GetMapping**
- **@PostMapping**
- **@PutMapping**
- **@DeleteMapping**
- **@PatchMapping**

这些新的注解可以提高可读性，减少代码冗长。让我们看看这些新的注解在创建一个支持CRUD操作RESTFUL API的实例：
```java
@GetMapping("/{id}")
public ResponseEntity<?> getBazz(@PathVariable String id){
    return new ResponseEntity<>(new Bazz(id, "Bazz"+id), HttpStatus.OK);
}
 
@PostMapping
public ResponseEntity<?> newBazz(@RequestParam("name") String name){
    return new ResponseEntity<>(new Bazz("5", name), HttpStatus.OK);
}
 
@PutMapping("/{id}")
public ResponseEntity<?> updateBazz(
  @PathVariable String id,
  @RequestParam("name") String name) {
    return new ResponseEntity<>(new Bazz(id, name), HttpStatus.OK);
}
 
@DeleteMapping("/{id}")
public ResponseEntity<?> deleteBazz(@PathVariable String id){
    return new ResponseEntity<>(new Bazz(id), HttpStatus.OK);
}
```
深入了解这些可以在[这里](https://www.baeldung.com/spring-new-requestmapping-shortcuts)找到。

## 8. Spring配置

Spring MVC的配置足够简单 - 考虑到我们的*FooController*被定义在接下来的包里:
```java
package org.baeldung.spring.web.controller;
 
@Controller
public class FooController { ... }
```
我们只用一个 *@Configuration* 去启用完整的MVC支持并为控制器配置类路径扫描：
```java
@Configuration
@EnableWebMvc
@ComponentScan({ "org.baeldung.spring.web.controller" })
public class MvcConfig {
    //
}
```

## 9. 结论

这篇文章专注于**Spring的 *@RequestMapping* 注解** - 讨论一个简单的用例, HTTP头的映射, *@PathVariable* 绑定URI部分, 使用URL参数工作, 和使用 *@RequestParam* 注解.

如果你想学习如何使用另一个Spring MVC的核心注解, 你可以[在这浏览 *@ModelAttribu* 注解](https://www.baeldung.com/spring-mvc-and-the-modelattribute-annotation).

这篇文章的全部代码在[Github](https://github.com/eugenp/tutorials/tree/master/spring-rest-simple)可见. 这是一个Maven项目, 所以它可以很容易被导入和运行.



