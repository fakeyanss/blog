---
title: java主线程等待子线程的几种方法
categories:
  - Java
tags:
  - Java
  - concurrent
  - Thread
  - CountDownLatch
  - ExecutorService
mathjax: false
copyright: true
reward: true
toc: true
date: 2018-04-04 09:47:35
kewords:
description:
password:
---

在很多时候, 都需要在主线程中等待所有线程执行完毕, 再进行其他的操作. 在这种情况下, 显然如下的写法是不行的.
```java
public class Main {
    public static void main(String[] args) {
        long start = System.currentTimeMillis();

        Thread thread = new Thread() {
            public void run() {
                System.out.println(this.getName() + " start");
                try {
                    Thread.sleep(5000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println(this.getName() + " end");
            }
        };
        thread.start();

        long end = System.currentTimeMillis();
        System.out.println("runtime: " + (end - start));
    }
}
```
这时候的输出是
```
runtime: 0
Thread-0 start
Thread-0 end
```

这时候需要阻塞主线程, 让其等待子线程执行完毕, 方法有几种, 下面开始介绍.

## 准备工作
先创建一个类实现Runnable接口.
```java
public class MyRunnable implements Runnable {

    @Override
    public void run() {
        System.out.println(Thread.currentThread().getName() + " start");
        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(Thread.currentThread().getName() + " end");

    }

}
```

## Thread.join()

### 等待一个子线程
```java
public class Main {

    public static void main(String[] args) {
        long start = System.currentTimeMillis();

        MyRunnable runnable = new MyRunnable();
        Thread thread = new Thread(runnable, "thread-0");
        thread.start();
        try {
            thread.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        long end = System.currentTimeMillis();
        System.out.println("runtime: " + (end - start));
    }

}
```

### 等待多个子线程
```java
public class Main {

    public static void main(String[] args) {
        long start = System.currentTimeMillis();
        for(int i = 0; i < 5; i++) {
            MyRunnable runnable = new MyRunnable();
            Thread thread = new Thread(runnable, "thread-" + i);
            thread.start();
            try {
                thread.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        long end = System.currentTimeMillis();
        System.out.println("runtime: " + (end - start));
    }

}
```
输出, 显然是串行执行的5个线程.
```
thread-0 start
thread-0 end
thread-1 start
thread-1 end
thread-2 start
thread-2 end
thread-3 start
thread-3 end
thread-4 start
thread-4 end
runtime: 25004
```
如果想异步并发执行多个子线程, 可在循环体外join
```java
import java.util.ArrayList;
import java.util.List;

public class Main {

    public static void main(String[] args) {
        long start = System.currentTimeMillis();
        List<Thread> list = new ArrayList<Thread>();
        for(int i = 0; i < 5; i++) {
            MyRunnable runnable = new MyRunnable();
            Thread thread = new Thread(runnable, "thread-" + i);
            thread.start();
            list.add(thread);
        }

        try {
            for(Thread thread : list) {
                thread.join();
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        long end = System.currentTimeMillis();
        System.out.println("runtime: " + (end - start));
    }

}
```
输出.
```
thread-1 start
thread-3 start
thread-4 start
thread-0 start
thread-2 start
thread-1 end
thread-3 end
thread-4 end
thread-2 end
thread-0 end
runtime: 5004
```
由于每个线程都会抢占cpu执行, 执行的顺序是随机的, 所以每次输出都会不同.

## CountDownLatch
CountDownLatch是java.util.concurrent下的一个类, 作用是允许一个或多个线程等待其他线程执行完毕.
> A synchronization aid that allows one or more threads to wait until a set of operations being performed in other threads completes.

CountDownLatch源码如下.
```java
public class CountDownLatch {

    /**
    * Synchronization control For CountDownLatch. The details are not 
    * writted. please read the official docs.
    */
    private static final class Sync extends AbstractQueuedSynchronizer {...}

    private final Sync sync;

    // Constructs a CountDownLatch initialized with the given count.
    public CountDownLatch(int count) {
        if (count < 0) throw new IllegalArgumentException("count < 0");
        this.sync = new Sync(count);
    }

    /**
     * Causes the current thread to wait until the latch has counted down to
     * zero, unless the thread is interrupted.
     */
    public void await() throws InterruptedException {
        sync.acquireSharedInterruptibly(1);
    }

    /**
     * Causes the current thread to wait until the latch has counted down to
     * zero, unless the thread is interrupted, or the specified waiting time 
     * elapses.
     */
    public boolean await(long timeout, TimeUnit unit)
        throws InterruptedException {
        return sync.tryAcquireSharedNanos(1, unit.toNanos(timeout));
    }

    /**
     * Decrements the count of the latch, releasing all waiting threads if the
     * count reaches zero.
     */
    public void countDown() {
        sync.releaseShared(1); 
    }

    public long getCount() {
        return sync.getCount(); //Returns the current count.
    }

    public String toString() {
        return super.toString() + "[Count = " + sync.getCount() + "]";
    }

}

```
有一个构造器和几个方法, 构造时传参用于定义CountDownLatch大小, 且不可修改. 具体应用时, 每次执行一个线程后, 就countdown()一次. 在所有线程开始执行后, 立即await()等待, 直到所有线程执行完, 再执行await()后的代码段.

使用CountDownLatch实现主线程等待子线程如下.
```java
import java.util.concurrent.CountDownLatch;

public class Main {

    public static void main(String[] args) {
        long start = System.currentTimeMillis();
        CountDownLatch latch = new CountDownLatch(5);
        for(int i = 0; i < 5; i++) {
            new Thread() {
                public void run() {
                    System.out.println(Thread.currentThread().getName() + " start");
                    try {
                        Thread.sleep(5000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    } finally {
                        latch.countDown();
                    }
                    System.out.println(Thread.currentThread().getName() + " end");
                }
            } .start();
        }
        try {
            latch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        long end = System.currentTimeMillis();
        System.out.println("runtime: " + (end - start));
    }

}
```
输出
```java
Thread-2 start
Thread-3 start
Thread-0 start
Thread-1 start
Thread-4 start
Thread-2 end
Thread-3 end
Thread-0 end
Thread-1 end
Thread-4 end
runtime: 5004
```

## 线程池
java.util.concurrent.ExecutorService是java线程池的一个接口, 通过ExecutorService实现主线程等待子线程的方法很多, 比如submit()的返回Future对象判断提交的任务是否执行完, 或者在线程池中使用CountDownLatch, 或者用isTerminated()或awiatTermination(long, TimeUnit)判断线程池shutdown后所有任务是否完成. 具体可以查一下ExecutorService的文档

这里, 讲一个最简单的isTerminated().
```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Main {

    public static void main(String[] args) {
        long start = System.currentTimeMillis();
        ExecutorService pool = Executors.newFixedThreadPool(5);
        for(int i = 0; i < 5; i++) {
            MyRunnable runnable = new MyRunnable();
            pool.execute(runnable);
        }
        pool.shutdown();
        while(!pool.isTerminated());
        long end = System.currentTimeMillis();
        System.out.println("runtime: " + (end - start));
    }

}
```
输出
```
pool-1-thread-4 start
pool-1-thread-2 start
pool-1-thread-3 start
pool-1-thread-5 start
pool-1-thread-1 start
pool-1-thread-5 end
pool-1-thread-4 end
pool-1-thread-2 end
pool-1-thread-1 end
pool-1-thread-3 end
runtime: 5003

```
或者用awaitTermination(long, TimeUnit)更好, long传一个长整型, TimeUnit传时间单位, 常用的有MILLISECONDS, SECONDS, MINUTES等等, long和TimeUnit组合表示超时时间. 当线程池所有任务执行完,返回true. 未执行完前超时返回false. 如下.
```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class Main {

    public static void main(String[] args) {
        long start = System.currentTimeMillis();
        ExecutorService pool = Executors.newFixedThreadPool(5);
        for(int i = 0; i < 5; i++) {
            MyRunnable runnable = new MyRunnable();
            pool.execute(runnable);
        }
        pool.shutdown();
        try {
            //可以让while循环每2s执行一次, 而不是一直循环消耗性能
            while(!pool.awaitTermination(2, TimeUnit.SECONDS));
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        long end = System.currentTimeMillis();
        System.out.println("runtime: " + (end - start));
    }

}
```
输出
```
pool-1-thread-2 start
pool-1-thread-5 start
pool-1-thread-1 start
pool-1-thread-4 start
pool-1-thread-3 start
pool-1-thread-2 end
pool-1-thread-5 end
pool-1-thread-1 end
pool-1-thread-3 end
pool-1-thread-4 end
runtime: 5003

```

## 最后
CountDownLatch相对于join()来说, 在复杂场景下更能体现出优势. 比如需要主线程在其他线程执行一半或执行到某个阶段时开始, 这种情况是join()没法做到的.




<br>
<p id="div-border-top-green"><i>最后要说的是：[博客源码](https://github.com/fakeYanss/blog) ， 欢迎 star</i></p>
