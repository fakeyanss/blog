---
title: Java字符串拼接方法
date: 2021-03-27 01:06:24
tags: Java
---

在Java里拼接字符串，到底推荐用什么方式？

<!-- more -->

---

![Runtime comparison](https://foreti.me/imgplace/2021/2021-03-27_20210327011145-3485cf.png)

**先说结论，`+` >= `StringBuilder` > `String.format`。**

拼接的字符串较少时，直接 `+` 拼接和使用 `StringBuilder.append` 然后 `toString` 有近似的性能，这是由于jdk1.8编译时，已经将 `+`优化为使用 `StringBuilder.append`。

甚至大多数情况下，`+` 拼接的性能更好点 ，因为jdk编译成字节码后，`+` 拼接的字符串已经编译成完成，而 `StringBuilder.append` 需要在运行时执行。

而当在循环中拼接的字符串，`StringBuilder.append` 的性能会比 `+` 好很多，因为 `+` 拼接在每次执行都需要创建 `StringBuilder` 对象。

不过这两者性能同时比String.format强出一截，这主要是由于`String.format`需要使用正则解析输入字符串，然后再填充参数。



接下来用一个例子验证下：

```java
public class StringTest {

    public void testConcat() {
        String a = "q" + "w" + "e" + "r";
        String b = new StringBuilder().append("q").append("w").append("e").append("r").toString();

        String c = "";
        for (int i = 0; i < 100; i++) {
            c = c + "q" + "w" + "e" + "r";
        }

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 100; i++) {
            sb.append("q").append("w").append("e").append("r");
        }
        String d = sb.toString();
    }

}
```

编译：

```bash
javac StringTest.java
```

查看字节码：

```java
javap -c StringTest

Compiled from "StringTest.java"
public class StringTest {
  public StringTest();
    Code:
       0: aload_0
       1: invokespecial #1                  // Method java/lang/Object."<init>":()V
       4: return

  public void testConcat();
    Code:
       0: ldc           #2                  // String qwer
       2: astore_1
       3: new           #3                  // class java/lang/StringBuilder
       6: dup
       7: invokespecial #4                  // Method java/lang/StringBuilder."<init>":()V
      10: ldc           #5                  // String q
      12: invokevirtual #6                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      15: ldc           #7                  // String w
      17: invokevirtual #6                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      20: ldc           #8                  // String e
      22: invokevirtual #6                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      25: ldc           #9                  // String r
      27: invokevirtual #6                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      30: invokevirtual #10                 // Method java/lang/StringBuilder.toString:()Ljava/lang/String;
      33: astore_2
      34: ldc           #11                 // String
      36: astore_3
      37: iconst_0
      38: istore        4
      40: iload         4
      42: bipush        100
      44: if_icmpge     73
      47: new           #3                  // class java/lang/StringBuilder
      50: dup
      51: invokespecial #4                  // Method java/lang/StringBuilder."<init>":()V
      54: aload_3
      55: invokevirtual #6                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      58: ldc           #2                  // String qwer
      60: invokevirtual #6                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      63: invokevirtual #10                 // Method java/lang/StringBuilder.toString:()Ljava/lang/String;
      66: astore_3
      67: iinc          4, 1
      70: goto          40
      73: new           #3                  // class java/lang/StringBuilder
      76: dup
      77: invokespecial #4                  // Method java/lang/StringBuilder."<init>":()V
      80: astore        4
      82: iconst_0
      83: istore        5
      85: iload         5
      87: bipush        100
      89: if_icmpge     121
      92: aload         4
      94: ldc           #5                  // String q
      96: invokevirtual #6                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      99: ldc           #7                  // String w
     101: invokevirtual #6                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
     104: ldc           #8                  // String e
     106: invokevirtual #6                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
     109: ldc           #9                  // String r
     111: invokevirtual #6                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
     114: pop
     115: iinc          5, 1
     118: goto          85
     121: aload         4
     123: invokevirtual #10                 // Method java/lang/StringBuilder.toString:()Ljava/lang/String;
     126: astore        5
     128: return
}
```

可以看到：

- 13行，编译中`+` 直接生成 `"qwer"`；

- 17行，`StringBuilder` 先初始化，再依次 `append`；

- 32行到45行，开始执行 `+`操作 的循环体，每次都需要初始化 StringBuilder`对象；

- 85行到118行，开始执行 `StringBuilder.append` 操作的循环体，每次只用 `append`。

从字节码来看，jdk编译后的内容和预期符合。

另外 [Baeldung这篇文章](https://www.baeldung.com/java-string-performance) 中有更详细的 Java String Performance 研究，若有兴趣可以读下。