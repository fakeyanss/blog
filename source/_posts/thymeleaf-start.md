---
title: Thymeleaf的简单使用
tags:
  - thymeleaf
date: 2018-03-12 20:09:44
---
Thymeleaf是一款用于渲染XML/XHTML/HTML5内容的Java模板引擎库，可以通过HTML的标签属性渲染标签内容。
<!--more-->

---

举个例子，
```html
<p th:text="${home.welcome}">Welcome to our grocery store!</p>
```
这里的`th:text`的内容就是需要后台渲染的，假如没有后台渲染，html会将无法识别的部分直接过滤掉，那么输出就是
```html
<p >Welcome to our grocery store!</p>
```
假如后台传过来的`home.welcome`的值是`Welcome, Yanss!`，那么输出就是
```html
<p >Welcome, Yanss!</p>
```
这就是Thymeleaf的用法和作用了，其他的地方也差不多。

记录几个常用的语法。

## URL
```html
<a th:href="@{http://www.thymeleaf.org}">Thymeleaf</a>
```
如果需要传参
```html
<a th:href="@{http://www.thymeleaf.org(id=${id})}">Thymeleaf</a>
<a th:href="@{http://www.thymeleaf.org(id=${id},name=${name})}">Thymeleaf</a>
```

## 字符串替换
```html
<span th:text="'Welcome to our application, ' + ${user.name} + '!'">
```

## 条件选择式
类似于java的三元表达式
```html
<p th:text="true?'真':'假'"></p>
```

## 循环loop
* 创建表格
```html
<table>
    <tr>
      <th>NAME</th>
      <th>PRICE</th>
      <th>IN STOCK</th>
    </tr>
    <tr th:each="prod : ${prods}">
      <td th:text="${prod.name}">Onions</td>
      <td th:text="${prod.price}">2.41</td>
      <td th:text="${prod.inStock}? #{true} : #{false}">yes</td>
    </tr>
  </table>
```

* 创建下拉框
    * 在项目启动访问index页面的时候，把要需要的列表集合存到session作用域
```java
@RequestMapping("index")
public String index(HttpSession session){
    List<Classes> list = userService.findAllClasses();
    session.setAttribute("list",list);
    return "index";
}
```

    * 前台取值
```html
<select name="className" class="form-control">
    <option>请选择班级</option>
    <option th:each="list:${session.list}" th:value="$${list.cid}" th:text="${list.cname}"></option>
</select>
```

* 遍历Map和List
```html
<table class="table">  
  <thead>  
    <th th:each="entry : ${map}" th:text="${entry.key}"></th>  
    <th th:each="entry : ${map}" th:text="${entry.value}"></th>  
  </thead>  
  <tbody >  
    <td th:each="ele : ${list}" th:text="${ele}"></td>  
  </tbody>  
</table>  
```

* 遍历List<Map>
```html
<ul th:each="lm : ${listmap}">  
  <li th:each="entry : ${lm}" th:text="${entry.key}" ></li>  
  <li th:each="entry : ${lm}" th:text="${entry.value}"></li>  
</ul>  
```

## if/unless, switch/case
下面`<a>`标签只有在`th:if`中条件成立时才显示，`th:unless`只有不成立时才显示
```html
<a th:href="@{/login}" th:if=${session.user != null}>Login</a>
```

switch/case也很好理解，默认属性default可以用*表示
```html
<div th:switch="${user.role}">
  <p th:case="'admin'">User is an administrator</p>
  <p th:case="#{roles.manager}">User is a manager</p>
  <p th:case="*">User is some other thing</p>
</div>
```

## inline
举个例子, 当我想在一个两层的标签中同时渲染外层和内层的属性, 可能会出现下面这种错误.
```html
<p th:text="${Hello.world}"><span th:if="${user == 'yanss'}">yanss</span></p>
```

这种写法等同于
```html
<p th:text="${Hello.world}"></p>
```

因为外层的th:text会将内层的覆盖掉, 如果要同时渲染, 可以使用inline属性, 也可以将内外层隔离开.
```html
<p th:inline="text">[[${Hello.world}]]<span th:if="${user == 'yanss'}">yanss</span></p>

<!-- or -->
<p >
  <span th:text="${Hello.world}"></span>
  <span th:if="${user == 'yanss'}">yanss</span>
</p>
```


<br>

---
<p id="div-border-left-red"><i>DigitalOcean 优惠码，注册充值 $5 送 $100，[链接一](https://m.do.co/c/282d5e1cf06e) [链接二](https://m.do.co/c/5eefb87c26cd)</i></p>
<p id="div-border-left-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>
