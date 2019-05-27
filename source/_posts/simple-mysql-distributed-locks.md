title: 简单实现依赖 MySQL 的分布式锁
date: 2019-05-27 19:37:16
tags:
---
201905W21 Share

<!-- more -->

---

又遇到一个使用分布式锁的情况， 但是没有用 Redis 或者 Zookeeper， 而是直接依赖 MySQL 给实现了。

其实用 MySQL 做分布式锁不是很适合， 但是在原理上非常容易理解。

我们只需要在数据库里创建一张表， 然后对这个表写数据， 多个实例中， 成功写入的那一个， 便拿到了锁， 可以进行下一步逻辑。

这里我们不考虑任何的可重入性、 超时、 阻塞等， 仅仅区满足分布式锁的互斥性， 其他的特性我们可以在下一次来实现。

下面开始我们的实现， 使用 SpringBoot 和 MySQL。

1. 首先， 需要在 maven 引入依赖

```xml
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
  </dependency>

  <dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
  </dependency>
```

2. 创建 Event 的 model 和 dao

```java
import java.util.Date;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity(name = "event")
public class Event {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    private String name;

    private Date startTime;

    private Date finishTime;

    public int getId() {
        return id;
    }

    public Event setId(int id) {
        this.id = id;
        return this;
    }

    public String getName() {
        return name;
    }

    public Event setName(String name) {
        this.name = name;
        return this;
    }

    public Date getStartTime() {
        return startTime;
    }

    public Event setStartTime(Date startTime) {
        this.startTime = startTime;
        return this;
    }

    public Date getFinishTime() {
        return finishTime;
    }

    public Event setFinishTime(Date finishTime) {
        this.finishTime = finishTime;
        return this;
    }

}
```

```java
import indi.yanss.dls.model.Event;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EventRepository extends JpaRepository<Event, Long> {

    Event findByName(String name);

}
```

3. 创建锁的获取和释放方法

```java
import java.util.Date;

import indi.yanss.dls.model.Event;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class EventLock {

    @Autowired
    private EventRepository eventRepository;

    public Event acquire(String name) {
        Event event = eventRepository.findByName(name);

        if (event == null) {
            // 没有事件，注册
            event = new Event().setName(name).setStartTime(new Date());
            eventRepository.save(event);
        } else if (event.getFinishTime() == null) {
            // 事件在运行
            throw new RuntimeException("Lock has been acquired.");
        } else if (event.getFinishTime().before(new Date())) {
            // 上一个事件已经完成，开始新事件
            int id = event.getId();
            event = new Event().setId(id).setName(name).setStartTime(new Date());
            eventRepository.save(event);
        }
        return event;
    }

    public void release(Event event) {
        eventRepository.save(event.setFinishTime(new Date()));
    }
}
```

4. 创建 Schedule 任务

```java
import java.util.Date;

import indi.yanss.dls.model.Event;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class EventLock {

    @Autowired
    private EventRepository eventRepository;

    public Event acquire(String name) {
        Event event = eventRepository.findByName(name);

        if (event == null) {
            // 没有事件，注册
            event = new Event().setName(name).setStartTime(new Date());
            eventRepository.save(event);
        } else if (event.getFinishTime() == null) {
            // 事件在运行
            throw new RuntimeException("Lock has been acquired.");
        } else if (event.getFinishTime().before(new Date())) {
            // 上一个事件已经完成，开始新事件
            int id = event.getId();
            event = new Event().setId(id).setName(name).setStartTime(new Date());
            eventRepository.save(event);
        }
        return event;
    }

    public void release(Event event) {
        eventRepository.save(event.setFinishTime(new Date()));
    }
}
```

5. 启动 MySQL， 配置连接。 这里不用手动创建表， JPA 会在实例启动时自动帮我们创建和 Event model 对应的表。

```properties
# 需要启动mysql， 创建数据库demo
spring.datasource.url = jdbc:mysql://localhost:3306/demo
    spring.datasource.username = root
spring.datasource.password = 123456
```

6. 启动多个实例， 用不同端口即可。

![多实例配置](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/image.4orwrpw8u3o.png)

7. Done！ 观察控制台输出吧。

<br>

---

<p id="div-border-left-red"><i>DigitalOcean 优惠码，注册充值 $5 送 $100，[链接一](https://m.do.co/c/282d5e1cf06e) [链接二](https://m.do.co/c/5eefb87c26cd)</i></span>
<p id="div-border-left-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>
