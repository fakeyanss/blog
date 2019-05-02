---
title: Lombok让Java变得再次酷炫
tags:
  - Java
  - Lombok
  - ARTS
date: 2019-02-15 13:18:04
---
201902W5 Review, 这是一篇关于Spring开发插件Lombok的译文。
<!-- more -->

---

![](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190202144529.png)

[原文](https://bytes.grubhub.com/lombok-makes-java-cool-again-171102bdcc52)

在Grauhub，我们在大多数后端编程中都是用Java。Java是一门经过20多年实战考验的语言，已经证明了它的速度和可靠性。虽然我们已经使用Java很多年了，最近，它开始展现了它的老旧的特性。

尽管Java是最受欢迎的JVM语言之一，但它不是唯一的。在过去几年里，它面临着一些挑战者，比如Scala，Clojure和Kotlin，它们提供了新的功能和高效的语言特性。简而言之，它们让你用更少的代码做更多的事。
是的·
JVM生态系统中的这一创新令人兴奋。更多的竞争意味着Java被迫改变以保持竞争力。从Java 8（Valhalla，Local-Variable Type Inference，Loom）以来，新的六个月发布计划和几个JEP（JDK 增强提议）证明了Java在未来几年将继续保持竞争力。

但是，Java语言的大小和规模意味着开发进度比我们想要的要慢，更不用说Java不惜一切代价保持向后兼容性的强烈意愿。通过任何软件工程工作，功能都需要优先考虑，因此如果完全使用Java的话，我们想要的功能可能需要很长时间。与此同时，现在Grubhub利用Lombok项目获得简化和改进的Java。Lombok是一个编译器插件，它为Java添加了新的“关键字”，并将注释转换为Java代码，减少了繁杂的工程工作，并提供了一些额外的功能。

## 设置Lombok

Grubhub一直在寻求改进我们的软件生命周期，但每个新工具和流程都需要在采用之前考虑成本。幸运的是，添加Lombok就像在gradle文件中添加几行一样简单。

Lombok是一个编译器插件，因为它在编译器处理它们之前将源代码中的注释转换为Java语句--在运行时不需要提供lombok依赖项，因此添加Lombok不会增加构建工件的大小。因此，您需要下载Lombok并将其添加到您的构建工具中。要[使用Gradle设置Lombok](https://projectlombok.org/setup/gradle)（它也适用于[Maven](https://projectlombok.org/setup/maven)），请将此块添加到build.gradle文件中：

```
plugins {
    id &apos;io.franzbecker.gradle-lombok&apos; version &apos;1.14&apos;
    id &apos;java&apos;
}
repositories {
    jcenter() // or Maven central, required for Lombok dependency
}
lombok {
    version = &apos;1.18.4&apos;
    sha256 = ""
}
```

由于Lombok是一个编译器插件，我们为它编写的源代码实际上并不是有效的Java。因此，您还需要为正在使用的IDE安装插件。幸运的是，Lombok支持所有主要的Java IDE。没有插件，IDE不知道如何解析代码。IDE集成是无缝的。诸如“show usages”和“go to implementation”等功能继续按预期工作，带您进入相关字段/类。

## Lombok使用
了解Lombok的最佳方式是看它的使用方法。让我们深入研究一些如何将Lombok应用于Java应用程序的常见方面的示例。

### 为POJO增添趣味
我们使用普通的旧Java对象（POJO）将数据与处理分开，使我们的代码更易于阅读并简化网络有效负载。一个简单的POJO有一些私有字段和相应的getter和setter。它们只在写了很多样板代码之后可以完成了工作。

Lombok有助于使POJO更有用，更灵活，更有结构，而无需编写更多其他代码。使用Lombok，我们可以使用@Data注释简化最基本的POJO ：

```java
@Data
public class User {
  private UUID userId;
  private String email;
}
```

该@Data注释实际上是包含多个Lombok注释的便利结合。

* [@ToString](https://projectlombok.org/features/ToString)生成该toString()方法的实现，该实现由包含类名和每个字段及其值的对象的“漂亮打印”版本组成。

* [@EqualsAndHashCode](https://projectlombok.org/features/EqualsAndHashCode)生成equals和hashCode方法的实现，默认情况下，它们使用所有非静态，非transient字段，但是可配置。

* [@Getter/@Setter](https://projectlombok.org/features/GetterSetter)为私有字段生成getter和setter方法。

* [@RequiredArgsConstructor](https://projectlombok.org/features/constructor)生成带参数的构造函数，其中需要参数是常量字段和带@NonNull注释的字段（稍后将详细介绍）。

这一个注释简单而优雅地涵盖了许多常见用例，但POJO并不总是足够的。一个注释@Data的类是完全可变的，它一旦被滥用，可能在应用程序增加复杂性和限制并发量，这两点都有害于应用程序的持久性。

Lombok刚刚修复。让我们重新审视我们的User类，使其不可变，并添加一些其他有用的Lombok注释。

```java
@Value
@Builder(toBuilder = true)
public class User {
  @NonNull 
  UUID userId;
  @NonNull 
  String email;
  @Singular
  Set<String> favoriteFoods;
  @NonNull
  @Builder.Default
  String avatar = “default.png”;
}
```

所需要的只是@Value注释。@Value类似于@Data，除了所有字段都默认为private和final，并且不生成setter。这些特点使注释@Value的对象有效地不变。由于字段都是常量的，因此没有无参数构造函数。相反，Lombok用@AllArgsConstructor生成所有参数构造函数，这产生了一个功能完备，有效不可变的对象。

但是，如果只能使用all args构造函数创建对象，那么不可变是不太有用的。Joshua Bloch在《Effective Java》解释，当面临着许多构造函数参数时应该使用建造者。这就是Lombok的@Builder的作用，自动生成构建器内部类：

```java
User user = User.builder()
  .userId(UUID.random())
  .email(“grubhub@grubhub.com”)
  .favoriteFood(“burritos”)
  .favoriteFood(“dosas”)
  .build()
```
使用Lombok生成的构建器可以轻松创建具有多个参数的对象，并在将来添加新字段。静态构建器方法返回构建器实例以设置对象的所有属性。设置后，在构建器上调用build()方法返回实例。

该@NonNull注释可被用来在对象被实例化时，断言这些字段不为空，在空时抛出一个NullPointerException。请注意头像字段是如何注释@NonNull但未设置的。这是因为@Builder.Default注释表示默认使用“default.png”。（Grubhub是一个美国外卖公司，这里的头像指用户头像。）

还要注意构建器使用`favoriteFood`，即对象上属性的单数名称。当@Singular注释放在集合属性上时，Lombok会创建特殊的构建器方法来单独向该集合添加项目，而不是一次添加整个集合。这对于测试来说特别好，因为在Java中创建小型集合并不简洁。

最后，`toBuilder = true`设置添加了一个实例方法toBuilder()，该方法创建一个使用该实例的所有值填充的构建器对象。这样可以轻松创建一个预先填充原始实例中所有值的新实例，并仅更改所需的字段。这对于@Value类特别有用，因为字段是不可变的。

通过一些注释，你可以进一步配置专门的setter功能。@Wither为每个接受值的属性创建“withX”方法，并返回实例的克隆，并更新一个字段值。@Accessors允许您配置自动创建的setter。默认情况下，它允许将setter链接起来，就像构建器一样，返回而不是void。它还有一个参数，`fluent=true`，它删除了getter和setter上的“get”和“set”前缀约定。如果用例需要更多自定义，这对于@Builder可能是一个有用的替代品。

如果Lombok实现不适合您的用例（并且您已经查看了注释的修饰符），那么您始终可以手动编写自己的实现。例如，如果您有一个@Data类但是一个getter需要自定义逻辑，那么只需实现该getter。Lombok将看到已经提供了一个实现，并且不会使用自动生成的实现重写它。

只需几个简单的注释，最初的User POJO已经获得了许多丰富的功能，使其更易于使用，而不会给我们的工程师带来太多负担或增加开发的时间或成本。

### 删除组件样板代码
Lombok不仅在POJO中有用 - 它可以应用于应用程序的任何层。Lombok的以下用法在应用程序的组件类中特别有用，例如Controller，Service和DAO（数据访问对象）。

日志是每个软件的基准需求，作为关键的调查工具。任何正在做有意义的工作的类都应该记录日志信息。由于日志记录是一个贯穿各领域的问题，因此在每个类中声明一个`private static final logger`成为即时模板。Lombok将此样板简化为一个注释，该注释自动定义并实例化具有正确类名的记录器。根据您使用的日志记录框架，有一些不同的注释。
```java
@Slf4j // also: @CommonsLog @Flogger @JBossLog @Log @Log4j @Log4j2 @XSlf4j
public class UserService {
  // created automatically
  // private static final org.slf4j.Logger log = 
}
```

在声明了logger之后，接下来让我们添加我们的依赖项：
```java
@Slf4j
@RequiredArgsConstructor
@FieldDefaults(makeFinal=true, level=AccessLevel.PRIVATE)
public class UserService {
  @NonNull UserDao userDao;
}
```

该@FieldDefaults注释增加了final和private修饰符的所有字段。在@RequiredArgsConstructor创建构造器接受并设置一个UserDao实例。该@NonNull注释在构造函数中增加了一个检查，如果UserDao实例为null抛出一个NullPointerException。

## 其他
有很多方法可以使用Lombok。以上两节主要针对特定用例，但Lombok可以在许多方面使开发更容易。以下是一些小例子，展示了如何更有效地利用Lombok。

尽管Java 9引入了var关键字，var仍可以重新分配。Lombok提供了一个val关键字，它可以在var不支持的地方生效，提供本地常量推断变量。
```java
// final Map map = new HashMap<Integer, String>();
val map = new HashMap<Integer, String>();
```

有些类只具有纯静态函数，而且从不打算初始化。声明抛出异常的私有构造函数是阻止它实例化的一种方法。Lombok在其@UtilityClass注释中编写了该模式，该注释创建了一个私有构造函数，它抛出异常，使类成为final，并使所有方法都是静态的。
```java
@UtilityClass
// will be made final
public class UtilityClass {
  // will be made static
  private final int GRUBHUB = “ GRUBHUB”;

  // autogenerated by Lombok
  // private UtilityClass() {
  //   throw new java.lang.UnsupportedOperationException("This is a utility class and cannot be instantiated");
  //}

  // will be made static
  public void append(String input) {
    return input + GRUBHUB;
  }
}
```

对Java的常见批评是创建通过抛出已检查的异常的冗长。Lombok有一个注释，可以删除那些讨厌的关键词：@SneakyThrows。正如您所料，实现非常狡猾（sneaky）。它不会吞下甚至将异常包装成一个RuntimeException。相反，它依赖于以下事实：在运行时，JVM不会检查已检查异常的一致性。只有javac这样做。因此，Lombok使用字节码转换在编译时选择退出此检查。这导致代码顺利运行。
```java
public class SneakyThrows {

    @SneakyThrows
    public void sneakyThrow() {
        throw new Exception();
    }

}
```

## 并排比较
没什么能比做并排比较更清楚看到Lombok节省的代码。IDE插件提供了一个“de-lombok”函数，可将大多数Lombok注释转换为近似的本机Java代码（@NonNull注释不转换）。安装了Lombok插件的任何IDE都允许你将大多数注释转换为本机Java代码（并再次返回）。让我们从上面回到我们的User类。
```java
@Value
@Builder(toBuilder = true)
public class User {
  @NonNull 
  UUID userId;
  @NonNull 
  String email;
  @Singular
  Set<String> favoriteFoods;
  @NonNull
  @Builder.Default
  String avatar = “default.png”;
}
```

Lombok类只有13条简单易读的描述性代码行。但是在运行de-lombok之后，这个课程变成了一百多行的样板，没有人愿意看到，但每个人都想要！
```java
public class User {

   @NonNull
   UUID userId;
   @NonNull
   String email;
   Set<String> favoriteFoods;
   @NonNull
   @Builder.Default
   String avatar = "default.png";

   @java.beans.ConstructorProperties({"userId", "email", "favoriteFoods", "avatar"})
   User(UUID userId, String email, Set<String> favoriteFoods, String avatar) {
       this.userId = userId;
       this.email = email;
       this.favoriteFoods = favoriteFoods;
       this.avatar = avatar;
   }

   public static UserBuilder builder() {
       return new UserBuilder();
   }

   @NonNull
   public UUID getUserId() {
       return this.userId;
   }

   @NonNull
   public String getEmail() {
       return this.email;
   }

   public Set<String> getFavoriteFoods() {
       return this.favoriteFoods;
   }

   @NonNull
   public String getAvatar() {
       return this.avatar;
   }

   public boolean equals(Object o) {
       if (o == this) return true;
       if (!(o instanceof User)) return false;
       final User other = (User) o;
       final Object this$userId = this.getUserId();
       final Object other$userId = other.getUserId();
       if (this$userId == null ? other$userId != null : !this$userId.equals(other$userId)) return false;
       final Object this$email = this.getEmail();
       final Object other$email = other.getEmail();
       if (this$email == null ? other$email != null : !this$email.equals(other$email)) return false;
       final Object this$favoriteFoods = this.getFavoriteFoods();
       final Object other$favoriteFoods = other.getFavoriteFoods();
       if (this$favoriteFoods == null ? other$favoriteFoods != null : !this$favoriteFoods.equals(other$favoriteFoods))
           return false;
       final Object this$avatar = this.getAvatar();
       final Object other$avatar = other.getAvatar();
       if (this$avatar == null ? other$avatar != null : !this$avatar.equals(other$avatar)) return false;
       return true;
   }

   public int hashCode() {
       final int PRIME = 59;
       int result = 1;
       final Object $userId = this.getUserId();
       result = result * PRIME + ($userId == null ? 43 : $userId.hashCode());
       final Object $email = this.getEmail();
       result = result * PRIME + ($email == null ? 43 : $email.hashCode());
       final Object $favoriteFoods = this.getFavoriteFoods();
       result = result * PRIME + ($favoriteFoods == null ? 43 : $favoriteFoods.hashCode());
       final Object $avatar = this.getAvatar();
       result = result * PRIME + ($avatar == null ? 43 : $avatar.hashCode());
       return result;
   }

   public String toString() {
       return "User(userId=" + this.getUserId() + ", email=" + this.getEmail() + ", favoriteFoods=" + this.getFavoriteFoods() + ", avatar=" + this.getAvatar() + ")";
   }

   public UserBuilder toBuilder() {
       return new UserBuilder().userId(this.userId).email(this.email).favoriteFoods(this.favoriteFoods).avatar(this.avatar);
   }

   public static class UserBuilder {
       private UUID userId;
       private String email;
       private ArrayList<String> favoriteFoods;
       private String avatar;

       UserBuilder() {
       }

       public User.UserBuilder userId(UUID userId) {
           this.userId = userId;
           return this;
       }

       public User.UserBuilder email(String email) {
           this.email = email;
           return this;
       }

       public User.UserBuilder favoriteFood(String favoriteFood) {
           if (this.favoriteFoods == null) this.favoriteFoods = new ArrayList<String>();
           this.favoriteFoods.add(favoriteFood);
           return this;
       }

       public User.UserBuilder favoriteFoods(Collection<? extends String> favoriteFoods) {
           if (this.favoriteFoods == null) this.favoriteFoods = new ArrayList<String>();
           this.favoriteFoods.addAll(favoriteFoods);
           return this;
       }

       public User.UserBuilder clearFavoriteFoods() {
           if (this.favoriteFoods != null)
               this.favoriteFoods.clear();

           return this;
       }

       public User.UserBuilder avatar(String avatar) {
           this.avatar = avatar;
           return this;
       }

       public User build() {
           Set<String> favoriteFoods;
           switch (this.favoriteFoods == null ? 0 : this.favoriteFoods.size()) {
               case 0:
                   favoriteFoods = java.util.Collections.emptySet();
                   break;
               case 1:
                   favoriteFoods = java.util.Collections.singleton(this.favoriteFoods.get(0));
                   break;
               default:
                   favoriteFoods = new java.util.LinkedHashSet<String>(this.favoriteFoods.size() < 1073741824 ? 1 + this.favoriteFoods.size() + (this.favoriteFoods.size() - 3) / 3 : Integer.MAX_VALUE);
                   favoriteFoods.addAll(this.favoriteFoods);
                   favoriteFoods = java.util.Collections.unmodifiableSet(favoriteFoods);
           }

           return new User(userId, email, favoriteFoods, avatar);
       }

       public String toString() {
           return "User.UserBuilder(userId=" + this.userId + ", email=" + this.email + ", favoriteFoods=" + this.favoriteFoods + ", avatar=" + this.avatar + ")";
       }
   }
}
```

我们可以从上面为UserService类做同样的事情。
```java
@Slf4j
@RequiredArgsConstructor
@FieldDefaults(makeFinal=true, level=AccessLevel.PRIVATE)
public class UserService {
  @NonNull UserDao userDao;
}
```

将导致大约这个Java代码。
```java
public class UserService {
   
   private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(UserService.class);
   
   private final UserDao userDao;
   
   @java.beans.ConstructorProperties({"userDao"})
   public UserService(UserDao userDao) {
       if (userDao == null) {
           throw new NullPointerException("userDao is marked @NonNull but is null")
       }
       this.userDao = userDao;
   }

 }
```

## 衡量影响
Grubhub有超过一百种服务来满足业务需求。我们采用了其中一种服务并运行了Lombok IntelliJ插件的“de-lombok”功能，以查看使用Lombok节省了多少行代码。结果是大约180个文件的更改，导致大约18,000个额外的代码行和800个Lombok使用的删除。这是18,000行自动生成，标准化和经过实战考验的代码行！平均而言，每行Lombok代码都节省了23行Java代码。有了这样的影响，很难想象没有Lombok就使用Java。

## 总结
Lombok是一种很好的方式，可以激发工程师的新语言功能，而无需在整个组织内付出太多努力。将插件应用于项目当然比使用现有代码训练所有工程师使用新语言和端口更容易。Lombok可能没有一切，但它确实提供了足够的开箱即用，对工程经验产生了明显的影响。

Lombok的另一个好处是它使我们的代码库保持一致。凭借遍布全球的一百多种不同服务和分布式团队，使我们的代码库保持一致，可以更轻松地扩展团队并减少启动新项目时上下文切换的负担。自Java 6以来，Lombok与任何版本的Java都相关，因此我们可以指望它在所有项目中都可用。

Lombok对Grubhub的意义远远超过了闪亮的新功能。毕竟，Lombok做的任何事情都可以手工编写。如图所示，Lombok简化了代码库的无聊部分，而不会影响业务逻辑。这使我们专注于为Grubhub提供最大价值的工作，并且是我们工程师最感兴趣的工作。编写者，审阅者和维护者让代码库的这么大部分成为单调的样板代码是浪费时间。此外，由于此代码不再手动编写，因此它消除了所有类型的拼写错误。自动生成的好处与强大的功能相结合，@NonNull减少了漏洞的可能性，并使我们的工程专注于为您提供便利！


<br>
<p id="div-border-top-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>