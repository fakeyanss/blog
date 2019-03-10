---
title: ThoughtWorks笔试题
tags: offer
date: 2018-10-30 23:11:03
---
记录一下2017-2018年的三次ThoughtWorks笔试的题目和我的解法。
<!--more-->

# 2018_Q3_校招（软件开发工程师）

## 题目

[下载](http://pic.yanss.top/2019/20190216182913.png)

## 复试题目

![](http://pic.yanss.top/2019/第二部分题目1.png)

![](http://pic.yanss.top/2019/第二部分题目2.png)

![](http://pic.yanss.top/2019/第二部分题目3.png)

## 题解

[全部代码](http://pic.yanss.top/Maze.zip)，包括复试题的答案。

## 思路

抽象问题内容, 发现要做的事就是读取命令输入和构建迷宫矩阵

细致分析一下, 有以下步骤

* 读取从第一行输入的命令, 先用 `MazeFactory` 的 `checkFirstLineInput()` 方法检测输入, 得到的结果可以构建初始的迷宫矩阵, 即这种, 共有九个 `[R]`, 在代码中是 `MazeFactory` 的 `init()` 方法.

```
[W] [W] [W] [W] [W] [W] [W]
[W] [R] [W] [R] [W] [R] [W]
[W] [W] [W] [W] [W] [W] [W]
[W] [R] [W] [R] [W] [R] [W]
[W] [W] [W] [W] [W] [W] [W]
[W] [R] [W] [R] [W] [R] [W]
[W] [W] [W] [W] [W] [W] [W]
```

* 然后读取第二行命令, 提取出一组组的Road, 如 `(0,1) (0,2)`, 由于这是在 cell 中的下标, 我们将它转变为 maze 矩阵的下标, 即`(1,3) (1,5)`, 这样就是可以连通的两个Road节点, 并且得到需要被转变为Road 的 Wall 节点`(1,4)`. 

  重复这样的操作, 可以得到一组需要被转变为Road 的 Wall节点的List, 在代码中是 `MazeFactory` 的 `checkSecondLineInput()` 方法, 此方法同时处理了对第二行命令输入的检测.

  然后将它们的节点信息`[W]`变为`[R]`, 即 `connectRoad()`

* 最后, 对 maze 矩阵信息进行打印输入, 即 `maze.render()

# 2018_SPRING_DEV

## 题目

[下载](http://pic.yanss.top/2018_SPRING_DEV.pdf)

![ThoughtWorks2018Spring](http://pic.yanss.top/ThoughtWorks2018Spring.png)

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
	public static String PLANEID; //无人机编号
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

        while (scanner.hasNextLine()) {
            List<Integer> col = new ArrayList<Integer>();
            str = scanner.nextLine().split(" ");
            for (int i = 1; i < str.length; i++) {
                col.add(Integer.parseInt(str[i]));
            }
            PLANEID = str[0];
            plane.add(col);
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

[PDF download](http://otzlyqzo6.bkt.clouddn.com/作业题_武汉_AOUJYEHN.pdf)
![](http://pic.yanss.top/tw0001.jpg)
![](http://pic.yanss.top/tw0002.jpg)
![](http://pic.yanss.top/tw0003.jpg)
![](http://pic.yanss.top/tw0004.jpg)
![](http://pic.yanss.top/tw0005.jpg)

## 思路
主要是对字符串的切分处理。其中为了调试方便，将控制台输入数据转为json数据，然后再io流和gson包读取

## 题解
下载全部[eclipse项目文件](http://pic.yanss.top/badmintonCourt.zip)

代码ReadJson.java
```java
package pers.yanss.badmintonCourt.utils;

import java.io.FileReader;
import com.google.gson.*;

public class ReadJson {
	/**
	 * 传入json文件名，解析json数据，将需要的信息保存到一个一维数组str中
	 * 
	 * @param fileName
	 * @return str
	 * @throws Exception
	 */
	public String[] Read(String fileName) throws Exception {
		// 创建json解析器
		JsonParser parser = new JsonParser();
		String[] str;
		JsonObject object = (JsonObject) parser.parse(new FileReader("resource/" + fileName + ".json"));
		JsonArray scanIn = object.getAsJsonArray("scanIn");
		str = new String[scanIn.size()];
		for (int i = 0; i < scanIn.size(); i++) {
			JsonObject _scanIn = scanIn.get(i).getAsJsonObject();
			str[i] = _scanIn.get("str").toString().replaceAll("\"", "");
		}
		return str;
	}
}
```

代码DataUtils.java
```java
package pers.yanss.badmintonCourt.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class DateUtils {
	/**
	 * 判断日期格式是否合法，合法返回true
	 * 
	 * @param str
	 * @return convertSuccess
	 */
	public boolean isValidDate(String str) {
		boolean convertSuccess = true;
		// 指定日期格式为四位年/两位月份/两位日期，注意yyyy-MM-dd区分大小写
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		try {
			// 设置lenient为false.
			// 否则SimpleDateFormat会比较宽松地验证日期，比如2007/02/29会被接受，并转换成2007/03/01
			format.setLenient(false);
			format.parse(str);
		} catch (ParseException e) {
			// e.printStackTrace();
			// 如果throw java.text.ParseException或者NullPointerException，就说明格式不对
			convertSuccess = false;
		}
		return convertSuccess;
	}

	/**
	 * 判断预订时间是否合法，合法返回相应数据，1表示验证时间通过，2表示时间输入不合法，3表示预订时间和之前预订过的有冲突，4表示取消的订单不存在
	 * 
	 * @param str
	 *            预订时间段，如19:00~22:00
	 * @return convertSuccess
	 */
	public int isValidTime(String[][] str, int num) {
		int convertSuccess = 1;
		String[] time = str[num][2].split("~");
		if (Integer.parseInt(time[0].split(":")[0]) >= Integer.parseInt(time[1].split(":")[0])) {
			convertSuccess = 2;
			str[num][5] = "0";
		}
		if (!(time[0].split(":")[1].equals("00") && time[1].split(":")[1].equals("00"))) {
			convertSuccess = 2;
			str[num][5] = "0";
		}
		if (str[num][4].equals(" ")) {
			// 输入信息是下订单
			for (int i = 0; i < num; i++) {
				if (str[i][1].equals(str[num][1]) && str[i][3].equals(str[num][3]) && str[i][4].equals(" ")
						&& str[i][5].equals("1")) {
					// 如果预订时间段的起始时间小于之前预订信息的结束时间，或者预订时间段的结束时间大于之前预订信息的起始时间，则冲突
					if (Integer.parseInt(str[num][2].split("~")[0].split(":")[0]) < Integer
							.parseInt(str[i][2].split("~")[1].split(":")[0])) {
						convertSuccess = 3;
						str[num][5] = "0";

					}
					if (Integer.parseInt(str[num][2].split("~")[1].split(":")[0]) > Integer
							.parseInt(str[i][2].split("~")[0].split(":")[0])) {
						convertSuccess = 3;
						str[num][5] = "0";
					}
				}
			}
		} else {
			// 输入信息是取消订单
			for (int i = 0; i < num; i++) {
				if (str[i][1].equals(str[num][1]) && str[i][2].equals(str[num][2]) && str[i][3].equals(str[num][3])
						&& str[i][4].equals(" ") && str[i][5].equals("1")) {
					convertSuccess = 1;
					str[i][5] = "0";
					str[i][6] = "1";
					str[num][5] = "0";
					break;
				} else {
					str[num][5] = "0";
					convertSuccess = 4;
				}
			}
		}
		return convertSuccess;
	}

	/**
	 * 判断当前日期是星期几
	 * @param pTime 要判断的时间
	 * @return dayForWeek 判断结果
	 * @Exception 发生异常
	 */
	public int dayForWeek(String pTime) throws Exception {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		Calendar c = Calendar.getInstance();
		c.setTime(format.parse(pTime));
		int dayForWeek = 0;
		if (c.get(Calendar.DAY_OF_WEEK) == 1) {
			dayForWeek = 7;
		} else {
			dayForWeek = c.get(Calendar.DAY_OF_WEEK) - 1;
		}
		return dayForWeek;
	}

}

```

代码PringBill.java
```java
package pers.yanss.badmintonCourt.utils;

public class PrintBill {
	static int total = 0;

	/**
	 * 打印输出账单信息
	 * 
	 * @param str
	 *            保存输入信息的字符串数组
	 * @param txt
	 *            保存输出信息的字符串
	 * @return txt
	 * @throws Exception
	 */
	public String Print(String[][] str, String txt) throws Exception {
		System.out.println();
		txt += "\r\n";
		System.out.println("> 收入汇总");
		txt += "> 收入汇总" + "\r\n";
		System.out.println("> ---");
		txt += "> ---" + "\r\n";
		System.out.println("> 场地:A");
		txt += "> 场地:A" + "\r\n";
		txt = Court("A", str, txt);
		System.out.println(">");
		txt += ">" + "\r\n";
		System.out.println("> 场地:B");
		txt += "> 场地:B" + "\r\n";
		txt = Court("B", str, txt);
		System.out.println(">");
		txt += ">" + "\r\n";
		System.out.println("> 场地:C");
		txt += "> 场地:C" + "\r\n";
		txt = Court("C", str, txt);
		System.out.println(">");
		txt += ">" + "\r\n";
		System.out.println("> 场地:D");
		txt += "> 场地:D" + "\r\n";
		txt = Court("D", str, txt);
		System.out.println("> ---");
		txt += "> ---" + "\r\n";
		System.out.println("> 总计: " + total + " 元");
		txt += "> 总计: " + total + " 元" + "\r\n";
		return txt;
	}

	/**
	 * 根据羽毛球场地输出账单信息
	 * 
	 * @param type
	 *            羽毛球场地，可以为A,B,C,D
	 * @param str
	 *            保存输入信息的字符串数组
	 * @param txt
	 *            保存输出信息的字符串
	 * @return txt
	 * @throws Exception
	 */
	private static String Court(String type, String[][] str, String txt) throws Exception {
		DateUtils dateUtils = new DateUtils();
		int money = 0;
		int subtotal = 0;
		for (int i = 0; i < str.length; i++) {
			if (str[i][3].equals(type)) {
				int m = Integer.parseInt(str[i][2].split("~")[0].split(":")[0]);
				int n = Integer.parseInt(str[i][2].split("~")[1].split(":")[0]);
				if (str[i][5].equals("1")) {
					money = Bill(dateUtils.dayForWeek(str[i][1]), m, n);
					subtotal += money;
					total += subtotal;
					System.out.println("> " + str[i][1] + " " + str[i][2] + " " + money + " 元");
					txt += "> " + str[i][1] + " " + str[i][2] + " " + money + " 元" + "\r\n";

				} else if (str[i][5].equals("0") && str[i][6].equals("1")) {
					money = Bill(dateUtils.dayForWeek(str[i][1]), m, n) / 2;
					subtotal += money;
					System.out.println("> " + str[i][1] + " " + str[i][2] + " 违约金 " + money + " 元");
					txt += "> " + str[i][1] + " " + str[i][2] + " 违约金 " + money + " 元" + "\r\n";
				}
			}
		}
		System.out.println("> 小计: " + subtotal + " 元");
		txt += "> 小计: " + subtotal + " 元" + "\r\n";
		return txt;
	}

	/**
	 * 根据预订时间，求出消费金额。 首先判断星期几，再对开始时间进行划分，然后对结束时间进行划分，最后根据单位时长金额和时长求出消费金额
	 * 
	 * @param day
	 *            日期对应的星期几
	 * @param timeBegin
	 *            预订时间的起始时间
	 * @param timeOver
	 *            预订时间的结束时间
	 * @return money 消费金额
	 */
	private static int Bill(int day, int timeBegin, int timeOver) {
		int money = 0;
		if (day >= 1 && day <= 5) {
			if (timeBegin < 12) {
				if (timeOver < 12) {
					money = 30 * (timeOver - timeBegin);
				} else if (timeOver >= 12 && timeOver < 18) {
					money = 30 * (12 - timeBegin) + 50 * (timeOver - 12);
				} else if (timeOver >= 18 && timeOver < 20) {
					money = 30 * (12 - timeBegin) + 50 * (18 - 12) + 80 * (timeOver - 18);
				} else {
					money = 30 * (12 - timeBegin) + 50 * (18 - 12) + 80 * (20 - 18) + 60 * (timeOver - 20);
				}
			} else if (timeBegin >= 12 && timeBegin < 18) {
				if (timeOver < 18) {
					money = 50 * (timeOver - timeBegin);
				} else if (timeOver >= 18 && timeOver < 20) {
					money = 50 * (18 - timeBegin) + 80 * (timeOver - 18);
				} else {
					money = 50 * (18 - timeBegin) + 80 * (20 - 18) + 60 * (timeOver - 20);
				}
			} else if (timeBegin >= 18 && timeBegin < 20) {
				if (timeOver <= 20) {
					money = 80 * (timeOver - timeBegin);
				} else {
					money = 80 * (20 - timeBegin) + 60 * (timeOver - 20);
				}
			} else {
				money = 60 * (timeOver - timeBegin);
			}
		} else {
			if (timeBegin < 12) {
				if (timeOver < 12) {
					money = 40 * (timeOver - timeBegin);
				} else if (timeOver >= 12 && timeOver < 18) {
					money = 40 * (12 - timeBegin) + 50 * (timeOver - 12);
				} else {
					money = 40 * (12 - timeBegin) + 50 * (18 - 12) + 60 * (timeOver - 18);
				}
			} else if (timeBegin >= 12 && timeBegin < 18) {
				if (timeOver < 18) {
					money = 50 * (timeOver - timeBegin);
				} else {
					money = 50 * (18 - timeBegin) + 60 * (timeOver - 18);
				}
			} else {
				money = 60 * (timeOver - timeBegin);
			}
		}
		return money;
	}

}
```

代码TextToFile.java
```java
package pers.yanss.badmintonCourt.utils;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class TextToFile {
	/**
	 * 传入文件名以及字符串, 将字符串信息保存到文件中
	 * 
	 * @param strFilename
	 * @param strBuffer
	 */
	public void toFile(final String strFilename, final String strBuffer) {
		try {
			// 创建文件对象
			File fileText = new File(strFilename);
			// 向文件写入对象写入信息
			FileWriter fileWriter = new FileWriter(fileText);

			// 写文件
			fileWriter.write(strBuffer);
			// 关闭
			fileWriter.close();
		} catch (IOException e) {
			//
			e.printStackTrace();
		}
	}
}
```

代码ChargeSolution.java
```java
package pers.yanss.badmintonCourt.charge;

import pers.yanss.badmintonCourt.utils.DateUtils;
import pers.yanss.badmintonCourt.utils.PrintBill;
import pers.yanss.badmintonCourt.utils.ReadJson;
import pers.yanss.badmintonCourt.utils.TextToFile;

public class ChargeSolution {
	static String FILE = "data2";// 输入信息储存到了json文件中，这里只需改变json文件名即可改变输入信息
	static String txt = "";// 输出信息保存到字符串txt中，最后将txt字符串信息写保存到一个文本文件中

	public static void main(String[] args) throws Exception {
		ReadJson json = new ReadJson();
		String[] data = json.Read(FILE);
		String[][] str = new String[data.length][7];// data每个元素以"
													// "切分后最大长度为5，加上星期几和两个标志位后长度为7
		DateUtils date = new DateUtils();
		str = transArray(str, data);
		// System.out.println(date.dayForWeek("2017-09-10"));
		// System.out.println(str[2].split(" ")[0]);
		for (int i = 0; i < str.length; i++) {
			System.out.println(data[i]);
			txt += data[i] + "\r\n";
			if (str[i][0].startsWith("U")) {
				if (date.isValidDate(str[i][1])) {
					if (date.isValidTime(str, i) == 1) {
						if (str[i][3].equals("A") || str[i][3].equals("B") || str[i][3].equals("C")
								|| str[i][3].equals("D")) {
							if (str[i][4].equals("C") || str[i][4].equals(" ")) {
								System.out.println("> Success: the booking is accepted!");
								txt += "> Success: the booking is accepted!" + "\r\n";
							} else {
								printInvalid();
							}
						} else {
							printInvalid();
						}
					} else if (date.isValidTime(str, i) == 2) {
						printInvalid();
					} else if (date.isValidTime(str, i) == 3) {
						System.out.println("> Error: the booking conflicts with existing bookings!");
						txt += "> Error: the booking conflicts with existing bookings!" + "\r\n";
					} else {
						System.out.println("> Error: the booking being cancelled does not exist!");
						txt += "> Error: the booking being cancelled does not exist!" + "\r\n";
					}
				} else {
					str[i][5] = "0";
					printInvalid();
				}
			} else {
				str[i][5] = "0";
				printInvalid();
			}
		}
		PrintBill printBill = new PrintBill();
		txt = printBill.Print(str, txt);
		TextToFile textToFile = new TextToFile();
		textToFile.toFile("bill.txt", txt);
	}

	/**
	 * 打印不合法的输出语句
	 */
	private static void printInvalid() {
		System.out.println("> Error: the booking is invalid!");
		txt += "> Error: the booking is invalid!" + "\r\n";
	}

	/**
	 * 将一维数组每个元素以" "切分，转化为二维数组,并在每行后面加上两个标志位 第一个标志位，1表示成功预订，0表示预订失败或取消预订
	 * 第二个标志位，1表示取消订单成功，0表示没有取消订单
	 * 
	 * @param str
	 *            二维数组
	 * @param data
	 *            一维数组
	 * @return str 转化后的二维数组
	 * @throws Exception
	 */
	private static String[][] transArray(String[][] str, String[] data) throws Exception {
		for (int i = 0; i < str.length; i++) {
			for (int j = 0; j < str[0].length; j++) {
				if (data[i].split(" ").length > j) {
					str[i][j] = data[i].split(" ")[j];
				} else if (j == 4) {
					str[i][j] = " ";
				} else if (j == 5) {
					str[i][j] = "1";
				} else {
					str[i][j] = "0";
				}
			}
		}
		return str;
	}
}

```


<br>
<p id="div-border-top-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>


