---
title: ThoughtWorks笔试题
categories:
  - 面经
tags:
  - ThoughtWorks
mathjax: false
copyright: true
reward: true
toc: true
abbrlink: fd067be5
date: 2018-01-30 23:11:03
kewords:
description:
password:
---

# 2018_SPRING_DEV

## 题目

[下载](http://ouat6a0as.bkt.clouddn.com/2018_SPRING_DEV.pdf)

![ThoughtWorks2018Spring](http://ouat6a0as.bkt.clouddn.com/ThoughtWorks2018Spring.png)

## 解决思路

- 首先需要一个逐行读取文件内容的方法， 构造文件输入流，再构造Scanner类输入即可。然后将读取的逐行信息切分为一个数组，保存到ArrayList1中；再以ArrayList2嵌套ArrayList1即可
- 在main方法中获取键盘输入信息作为消息序号id，然后遍历从第0条到第id条消息，得出第id条消息的输出

## 步骤

* 新建一个`input.txt`文件记录无人机活动信号

```
plane1 1 1 1
plane1 1 1 1 1 2 3
plane1 2 3 4 1 1 1
plane1 3 4 5
plane1 1 1 1 1 2 3
```

* 新建一个`PositionOfPlane.java`

```java
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.regex.Pattern;

/**
 * Auther: 桂晨
 * Date: 2018年1月23日00:14:33
 * 
 */
public class PositionOfPlane {
	public static String PLANEID = ""; //无人机编号
	public static String PATH = "input.txt"; //记录无人机活动信号的文本文件路径

	public static void main(String args[]) {
		List<List<Integer>> plane;
		try {
			plane = ReadFile(PATH);
			System.out.println("请输入消息序号(自然数):");
			Scanner sc = new Scanner(System.in);
			boolean flag = true;
			String _id = "";
			int id;
			//判断输入是不是自然数
			while(flag) {
				_id = sc.next();
				Pattern pattern = Pattern.compile("[0-9]*");
				if(pattern.matcher(_id).matches()){
					flag = false;
				}else{
					System.out.println("请重新输入");
				}
			}
			id = Integer.valueOf(_id);
			//将输入消息序号id分为三种情况，0，超出数据集，和在数据集中(不为0)
			if (id == 0) {
				System.out.println(PLANEID + " " + id + " " + plane.get(0).get(0) + " " + plane.get(0).get(1) + " " + plane.get(0).get(2));
			} else if (id > plane.size() - 1) {
				System.out.println("Cannot find " + id);
			} else {
				Print(id, plane);
			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	//输入消息序号id和信号数据plane，打印结果
	public static void Print(int id, List<List<Integer>> plane) {
		int num = 1;
		int x, y, z, offsetx, offsety, offsetz;
		x = plane.get(0).get(0);
		y = plane.get(0).get(1);
		z = plane.get(0).get(2);
		while (num <= id) {
			if (plane.get(num).size() != 6
					|| x != plane.get(num).get(0) || y != plane.get(num).get(1) || z != plane.get(num).get(2)) {
				System.out.println("Error: " + id);
				return;
			}
			offsetx = plane.get(num).get(3);
			offsety = plane.get(num).get(4);
			offsetz = plane.get(num).get(5);
			x += offsetx;
			y += offsety;
			z += offsetz;
			num++;
		}
		System.out.println(PLANEID + " " + id + " " + x + " " + y + " " + z);
	}

	//使用Scanner类nextLine()方法，读取文件每一行的数据，并将每个数据切分，保存到List<List<>>的嵌套集合(动态二维数组)中
	public static List<List<Integer>> ReadFile(String path) throws FileNotFoundException {
		FileInputStream fis = new FileInputStream(path);
		Scanner scanner = new Scanner(fis);
		String[] str;
		List<List<Integer>> plane = new ArrayList<List<Integer>>();
		List<Integer> col = new ArrayList<Integer>();
		while (scanner.hasNextLine()) {
			str = scanner.nextLine().split(" ");
			for (int i = 1; i < str.length; i++) {
				col.add(Integer.parseInt(str[i]));
			}
			PLANEID = str[0];
			plane.add(new ArrayList<Integer>(col));
			col.clear();
		}
		scanner.close();
		return plane;
	}
}

```

## 运行

先编译生成字节码

```
javac -encoding utf-8 PositionOfPlane.java
```

然后运行

```
java PositionOfPlane
```

然后输入ID

```
2（或其他数字）
```

# 2017秋季武汉招聘

## 题目

[PDF download](http://otzlyqzo6.bkt.clouddn.com//作业题_武汉_AOUJYEHN.pdf)
![](http://otzlyqzo6.bkt.clouddn.com//tw0001.jpg width="50%")
![](http://otzlyqzo6.bkt.clouddn.com//tw0002.jpg width="50%")
![](http://otzlyqzo6.bkt.clouddn.com//tw0003.jpg width="50%")
![](http://otzlyqzo6.bkt.clouddn.com//tw0004.jpg width="50%")
![](http://otzlyqzo6.bkt.clouddn.com//tw0005.jpg width="50%")


<br>
<p id="div-border-top-green"><i>最后要说的是：博客源码 ， 欢迎 star</i></p>


