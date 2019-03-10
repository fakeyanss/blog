---
title: 201902W9 Share | 基于ZooKeeper的分布式锁实现
tags:
  - ZooKeeper
  - 分布式锁
date: 2019-02-24 15:46:58
---
分布式锁的实现方式有很多种，可以依赖数据库、Redis、ZooKeeper等实现，当然不同的方式各有其优缺点。本文仅探讨基于ZooKeeper实现分布式锁的方法。<!--more-->

> 此部分分布式锁介绍摘自https://blog.didiyun.com/index.php/2018/11/20/zookeeper/
>
> ## 分布式锁
>
> 在单进程应用内，我们经常使用锁来保障多个线程并发访问同一资源的互斥性。在多进程、分布式场景下，如果多个系统或者单个系统的多个节点并发访问同一资源，为了保障对资源读写的互斥性，就需要用到分布式锁。
>
> ## 为什么用Zookeeper来实现分布式锁？
>
> `Zookeeper` 能够保障分布式场景下数据的一致性、有序性、原子性及可靠性，它的所有写入动作会在 Leader 节点持久化，并在集群过半数节点写入成功才会返回；它也能够支持节点的崩溃恢复以及客户端的最终一致性视图。对于分布式锁场景来说，数据一致性的保障、以及锁服务的容灾保障至关重要。
>
> 另外，`Zookeeper` 还提供了三种在分布式锁场景下非常有用的特性（以下的`节点`指的是`Zookeeper`内部存储的`znode`节点）：
>
> 1. 临时节点
>    客户端可以指定 zk 创建一个临时节点，此节点将在这个客户端与服务端建立的 [session](https://link.juejin.im/?target=https%3A%2F%2Fzookeeper.apache.org%2Fdoc%2Fr3.3.6%2FzookeeperProgrammers.html%23ch_zkSessions) 到期时自动删除，这个特性可以保障客户端创建的分布式锁节点在客户端宕机或者网络通讯中断一段时间后自动释放该临时节点，从而避免分布式锁由于客户端或网络原因导致的死锁问题。
> 2. 有序节点
>    客户端可以指定 zk 创建一个有序节点，此节点将自动在客户端指定的节点名后面添加一个单调递增序号来确保多个客户端同时创建相同的节点名时能够创建成功，并且保障越早创建的节点的序号越小。利用该特性可以实现锁的互斥性和公平性，即同一时刻只有一个客户端能够成功获取到锁（序号最小的一个获取到锁），获取锁失败的节点可以按照创建顺序进行锁等待。
> 3. watcher 机制
>    可以对一个节点的读操作注册一个 watcher监听器，当节点有变化时（例如节点被删除或更新）zk 服务端将主动通知注册了监听的客户端。这样对于正在等待锁的客户端可以及时得知锁被释放的事件从而重新进行抢锁动作。
>
> 以上三种特性可以结合使用，比如创建一个临时 + 有序节点，再注册一个其它序号节点的watcher监听来感知其他节点的变化。我们可以利用 `Zookeeper` 原生提供的这些特性实现各种可靠、安全的分布式锁。
>
> ## 常用的分布式锁类型
>
> * 排它锁（MutexLock）
>   任意时刻只有一个线程能够获取到锁，其他线程等待持有这把锁的线程释放锁后才能尝试获取锁。
> * 信号量（Semaphore）
>   允许多个线程持有一定数量的租约（Lease）。在当前租约数量小于最大租约数时，允许新的请求获取到租约，一旦当前租约数等于最大租约数，则新的请求将等待已获取到租约的线程释放租约后才能尝试获取。一般用来控制访问一个资源池的最大并发度。
> * 读写锁（ReadWriteLock）
>   写锁作为排它锁，任意时刻只有一个线程能获取到写锁。读锁作为共享锁，当没有写锁被持有的前提下，允许有多个线程同时获取到读锁。
> * 联锁（MultiLock）
>   保障多个不同资源的锁获取或释放的原子性的一种组合锁。多个锁资源被封装成一个联锁后，要么全部获取成功，要么全部获取失败，联锁保障不会出现部分获取成功的情况。
>
> 注意：以上提到的”线程”可能属于同一进程内，也可能属于不同进程。`Zookeeper` 能够保障在跨进程场景下数据的一致性。
>
> ## 分布式锁的通用特性
>
> 除了 `Zookeeper` 提供的一致性保障之外，分布式锁一般还需要提供如下的通用特性：
>
> * 公平性
>   在多个客户端抢锁的过程中，需要保障获取锁的公平性，先到达 `Zookeeper` 抢锁的请求能够先获取到锁（可以基于 `Zookeeper` 的有序节点特性来实现）。
> * 等待超时
>   为了避免死锁，一般在获取锁时都需要传递一个超时时间，超时请求则获取锁失败。
> * 可重入性
>   在一个线程内，如果已经持有一把锁，则在这把锁被释放前可以多次重复获取锁，其获取次数和释放次数需要保障一致。
>
> ## 分布式锁的实现库
>
> 推荐使用 Apache Curator库来实现分布式锁，它不仅封装了分布式锁的所有实现细节，还提供友好易用的 API。以下是 `Curator` 已经实现的分布式锁相关功能：
>
> * 可重入锁：`InterProcessMutex` 实现了可重入的排它锁，支持锁等待超时、保证获取锁的公平性。
> * 不可重入锁：`InterProcessSemaphoreMutex` 实现了不可重入的排它锁，支持锁等待超时、保证获取锁的公平性。可以在多个线程间传递和释放锁，从而满足异步调用场景下的锁需求。
> * 信号量：`InterProcessSemaphoreV2` 实现了信号量，支持信号量等待超时、保证获取信号量的公平性。客户端每次获取信号量成功都会返回一个租约（Lease）对象，建议客户端在 finally 代码块 close 这个租约对象以释放租约。注意在线程重入时，每次获取信号量成功也会占用一个租约。另外，在多进程场景下，可以通过 `SharedCountReader` 来保障最大租约数的一致性，避免不同的进程设置不同的最大租约数。
> * 读写锁：`InterProcessReadWriteLock` 实现了可重入读写锁，支持锁等待超时、保证获取锁的公平性。并且支持写锁降级（持有写锁的线程可以同时获取到读锁），不支持读锁升级（持有读锁的线程不能同时获取到写锁）。
> * 联锁：`InterProcessMultiLock` 实现了联锁，它使用装饰器模式实现多把锁的组合，与可重入锁、不可重入锁实现相同的接口，使得可以像使用单锁一样使用联锁。联锁获取成功代表它拥有的所有内部锁都获取成功，联锁获取失败则会自动释放所有内部已经获取成功的部分锁，从而保证联锁的原子性语义。

## 安装ZooKeeper环境

首先在本地安装ZooKeeper环境

```
brew install zookeeper
```

安装完成后，启动服务，默认配置文件不用修改，即/usr/local/etc/zookeeper/zoo.cfg
```
zkServer  -h
zkServer  start
zkServer  status
```

## 测试代码

### maven导入curator

curator是比ZooKeeper的源生API更好用的包，使用的人也较多。

```xml
<dependency>
    <groupId>org.apache.curator</groupId>
    <artifactId>curator-framework</artifactId>
    <version>2.4.2</version>
</dependency>
<dependency>
    <groupId>org.apache.curator</groupId>
    <artifactId>curator-client</artifactId>
    <version>2.4.2</version>
</dependency>
```

### ZKLock.java

ZKLock.java我自己对curator的接口的封装，将基本的方法封装便于调用

```java
package com.yanss.zk;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.apache.curator.RetryPolicy;
import org.apache.curator.framework.CuratorFramework;
import org.apache.curator.framework.CuratorFrameworkFactory;
import org.apache.curator.retry.ExponentialBackoffRetry;
import org.apache.log4j.Logger;
import org.apache.zookeeper.CreateMode;
import org.apache.zookeeper.WatchedEvent;
import org.apache.zookeeper.Watcher;
import org.apache.zookeeper.ZooDefs;
import org.apache.zookeeper.ZooKeeper;

public final class ZKLock {

    private static final Logger LOG = Logger.getLogger(ZKLock.class);
    private static final String CHILD_NODE_PATH = "temp";
    private String baseLockPath;
    private String finalLockId;

    private boolean needInterrupt = false;
    private boolean connected = false;
    private boolean acquireLock = false;

    private String host = "127.0.0.1:2181";
    private ZooKeeper zooKeeper;
    private FatherNodeWatcher fatherNodeWatcher;

    private ZKLock(String lock) {
        this.baseLockPath = "/" + lock;
        this.fatherNodeWatcher = new FatherNodeWatcher(this);
    }

    public static ZKLock create(String lock) {
        ZKLock zkLock = new ZKLock(lock);
        zkLock.connectZooKeeper();
        return zkLock;
    }

    public boolean getLock() {
        if (!connected) {
            return false;
        }
        int i = 0;
        while (!needInterrupt) {
            try {
                Thread.sleep(1000);
            } catch (Exception e) {
                LOG.warn(e.getMessage(), e);
            }
            if (acquireLock) {
                return true;
            }
            if (i++ > 5) {
                break;
            }
        }
        return false;
    }

    public boolean releaseLock() {
        try {
            if (zooKeeper != null && connected) {
                zooKeeper.delete(finalLockId, -1);
            }
        } catch (Exception e) {
            LOG.warn(e.getMessage(), e);
        }
        return disconnectZooKeeper();
    }

    private boolean disconnectZooKeeper() {
        if (zooKeeper == null && !connected) {
            return false;
        }
        try {
            connected = false;
            acquireLock = false;
            zooKeeper.close();
        } catch (Exception e) {
            LOG.warn(String.format("ZK disconnect failed. [%s]", e.getMessage()), e);
        }
        return true;
    }

    private boolean connectZooKeeper() {
        try {
            RetryPolicy retryPolicy = new ExponentialBackoffRetry(1000, 3);
            CuratorFramework client = CuratorFrameworkFactory.newClient(host, 5000, 3000, retryPolicy);

            zooKeeper = new ZooKeeper(host, 60000, new Watcher() {
                @Override
                public void process(WatchedEvent event) {
                    if (event.getState() == Watcher.Event.KeeperState.AuthFailed) {
                        needInterrupt = true;
                    } else if (event.getState() == Watcher.Event.KeeperState.Disconnected) {
                        needInterrupt = true;
                    } else if (event.getState() == Watcher.Event.KeeperState.Expired) {
                        needInterrupt = true;
                    } else {
                        if (event.getType() == Watcher.Event.EventType.None) {
                            connected = true;
                        }
                    }
                }
            });

            int i = 1;
            while (!connected) {
                if (i == 100) {
                    break;
                }
                Thread.sleep(300);
                i++;
            }

            if (connected) {
                if (zooKeeper.exists(baseLockPath, true) == null) {
                    zooKeeper.create(baseLockPath, "".getBytes(), ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.PERSISTENT);
                }

                finalLockId = zooKeeper.create(baseLockPath + "/" + CHILD_NODE_PATH, "".getBytes(),
                        ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.EPHEMERAL_SEQUENTIAL);

                checkAcquire();
            } else {
                needInterrupt = true;
                LOG.warn("Connect zookeeper failed. Time consumes 30 s");
                return false;
            }
        } catch (Exception e) {
            LOG.warn(e.getMessage(), e);
            return false;
        }
        return true;
    }

    private void checkAcquire() {
        if (!connected) {
            return;
        }
        try {
            List<String> childrenList = zooKeeper.getChildren(baseLockPath, fatherNodeWatcher);
            if (judgePathNumMin(childrenList)) {
                acquireLock = true;
            }
        } catch (Exception e) {
            LOG.warn(e.getMessage(), e);
            disconnectZooKeeper();
        }
    }

    private boolean judgePathNumMin(List<String> paths) {
        if (paths.isEmpty()) {
            return true;
        }
        if (paths.size() >= 2) {
            Collections.sort(paths, new Comparator<String>() {
                @Override
                public int compare(String str1, String str2) {
                    int num1;
                    int num2;
                    String string1 = str1.substring(CHILD_NODE_PATH.length(), str1.length());
                    String string2 = str2.substring(CHILD_NODE_PATH.length(), str2.length());
                    num1 = Integer.parseInt(string1);
                    num2 = Integer.parseInt(string2);
                    if (num1 > num2) {
                        return 1;
                    } else if (num1 < num2) {
                        return -1;
                    } else {
                        return 0;
                    }
                }
            });
        }

        String minId = paths.get(0);
        return finalLockId.equals(baseLockPath + "/" + minId);
    }

    private class FatherNodeWatcher implements Watcher {
        private ZKLock context;

        FatherNodeWatcher(ZKLock context) {
            this.context = context;
        }

        @Override
        public void process(WatchedEvent event) {
            if (event.getState() == Watcher.Event.KeeperState.AuthFailed) {
                context.needInterrupt = true;
            } else if (event.getState() == Watcher.Event.KeeperState.Disconnected) {
                context.needInterrupt = true;
            } else if (event.getState() == Watcher.Event.KeeperState.Expired) {
                context.needInterrupt = true;
            } else {
                if (event.getType() == Event.EventType.NodeChildrenChanged) {
                    context.checkAcquire();
                }
            }
        }
    }

}
```

### TestZKLockThread.java

为了测试ZooKeeper的分布式锁是非有用，在本地开启多线程，同时段去请求锁，然后查看锁的竞争情况。

```java
package com.yanss.zk;

import org.apache.log4j.Logger;

public class TestZKLockThread extends Thread {
    private static final Logger LOG = Logger.getLogger(TestZKLockThread.class);

    private String lockPath;
    private String num;

    /**
     * @param threadNum 线程编号
     */
    public TestZKLockThread(String lockPath, String threadNum) {
        this.lockPath = lockPath;
        this.num = threadNum;
    }

    @Override
    public void run() {
        ZKLock zkLock = ZKLock.create(lockPath);
        if (zkLock.getLock()) {
            LOG.error(String.format("线程:[%s]获取到任务锁,并开始执行任务", num));
            try {
                Thread.sleep(2000);
            } catch (Exception e) {
            }
            LOG.error(String.format("线程:[%s]已完成任务", num));
        } else {
            LOG.error(String.format("线程:[%s]没有获取到任务锁,放弃执行任务", num));
        }
        zkLock.releaseLock();
    }
}
```

### TestZKLockWithMultiThread.java

运行测试方法`TestZKLockWithMultiThread.java`，查看控制台输出。

```java
package com.yanss.zk;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.BasicConfigurator;

public class TestZKLockWithMultiThread {

    public static void main(String[] args) {
        BasicConfigurator.configure();
        int threadCount = 5;
        List<TestZKLockThread> testZKLockThreads = new ArrayList<>();
        for (int i = 0; i < threadCount; i++) {
            testZKLockThreads.add(new TestZKLockThread("lockpath", "Thread" + i ));
        }
        testZKLockThreads.forEach(tmp -> tmp.start());
    }

}

```

## 测试结果

1. 设置每个线程获取锁的等待时间为无限长（或者较长的时间比如60s），在`ZKLock.java`的第58行可修改时间，将

   ```java
   if (i++ > 5) {
   	break;
   }
   ```

   注释掉，每个线程取得锁权限后处理逻辑时间为2s，运行`TestZKLockWithMultiThread.java`，控制台输出（已删去ZooKeeper的输出日志）

   ```
   0 [Thread-0] INFO com.yanss.zk.TestZKLockThread  - 线程:[Thread0]获取到任务锁,并开始执行任务
   2011 [Thread-0] INFO com.yanss.zk.TestZKLockThread  - 线程:[Thread0]已完成任务
   3018 [Thread-1] INFO com.yanss.zk.TestZKLockThread  - 线程:[Thread1]获取到任务锁,并开始执行任务
   5022 [Thread-1] INFO com.yanss.zk.TestZKLockThread  - 线程:[Thread1]已完成任务
   5027 [Thread-4] INFO com.yanss.zk.TestZKLockThread  - 线程:[Thread4]获取到任务锁,并开始执行任务
   7030 [Thread-4] INFO com.yanss.zk.TestZKLockThread  - 线程:[Thread4]已完成任务
   7035 [Thread-2] INFO com.yanss.zk.TestZKLockThread  - 线程:[Thread2]获取到任务锁,并开始执行任务
   9036 [Thread-2] INFO com.yanss.zk.TestZKLockThread  - 线程:[Thread2]已完成任务
   9041 [Thread-3] INFO com.yanss.zk.TestZKLockThread  - 线程:[Thread3]获取到任务锁,并开始执行任务
   11048 [Thread-3] INFO com.yanss.zk.TestZKLockThread  - 线程:[Thread3]已完成任务
   ```

2. 设置每个线程获取锁的时间为5s，将第一步中注释掉的代码还原，同时将`TestZKLockThread.java`中32行的`zkLock.releaseLock();`注释掉，即获取锁完成任务后不再释放锁，控制台输出如下：

   ```
   0 [Thread-4] INFO com.yanss.zk.TestZKLockThread  - 线程:[Thread4]获取到任务锁,并开始执行任务
   2002 [Thread-4] INFO com.yanss.zk.TestZKLockThread  - 线程:[Thread4]已完成任务
   6024 [Thread-2] INFO com.yanss.zk.TestZKLockThread  - 线程:[Thread2]没有获取到任务锁,放弃执行任务
   6024 [Thread-3] INFO com.yanss.zk.TestZKLockThread  - 线程:[Thread3]没有获取到任务锁,放弃执行任务
   6024 [Thread-0] INFO com.yanss.zk.TestZKLockThread  - 线程:[Thread0]没有获取到任务锁,放弃执行任务
   6024 [Thread-1] INFO com.yanss.zk.TestZKLockThread  - 线程:[Thread1]没有获取到任务锁,放弃执行任务
   ```

   

通过这两个测试用例，可以发现我在我的Mac上安装的ZooKeeper服务启动后，通过用本地5个线程进行获取锁和释放锁的操作，在ZooKeeper服务的调度下，可以达到预期的分布式锁的效果。更详细的服务性能不好测试，留待未来实际应用中再记录。



<br>
<p id="div-border-top-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>