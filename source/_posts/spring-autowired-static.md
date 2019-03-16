---
title: spring自动注入静态属性
tags:
  - spring
  - autowired
date: 2018-07-17 19:59:35
---
stackoverflow问题[Can you use @Autowired with static fields?](https://stackoverflow.com/questions/1018797/can-you-use-autowired-with-static-fields)
<!--more-->

Spring中有时需要在静态方法中使用自动注入的属性，例如Service或者Mapper，而@autiwored是不能注解静态属性的，这是因为静态属性是类的属性，而spring注入是对象层面的依赖注入，所以spring是不支持注入静态属性的，这时候如果非得用，就要曲线救国了
```
@Component("NewClass")
public class NewClass{
    private static SomeThing someThing;

    @Autowired
    public void setSomeThing(SomeThing someThing){
        NewClass.someThing = someThing;
    }
}
```


<br>
<p id="div-border-top-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>