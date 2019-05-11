---
title: 剑指Offer刷题
tags: offer
date: 2017-09-08 14:43:33
---
刷一下算法题吧。
<!--more-->

---

# 替换空格

## 题目描述
请实现一个函数，将一个字符串中的空格替换成“%20”。例如，当字符串为We Are Happy.则经过替换之后的字符串为We%20Are%20Happy。

## 思路
看到问题第一反应是用replaceAll()方法，但这样挺没意思的。所以自己写解决方法，这样的话，就有了两种思路。

1. 从前往后替换，当遇到第一个空格时，要移动第一个空格后所有的字符一次；当遇到第二个空格时，要移动第二个空格后所有的字符一次；以此类推。
2. 从后往前，先计算需要多少空间，然后从后往前移动，则每个字符只为移动一次，这样效率更高一点。

这里提供第二种方法的代码
```java
public class Solution {
    public String replaceSpace(StringBuffer str) {
        int spacenum = 0;//spacenum为计算空格数
        for(int i=0;i<str.length();i++){
            if(str.charAt(i)==' ')
                spacenum++;
        }
        int indexold = str.length()-1; //indexold为为替换前的str下标
        int newlength = str.length() + spacenum*2;//计算空格转换成%20之后的str长度
        int indexnew = newlength-1;//indexnew为把空格替换为%20后的str下标
        str.setLength(newlength);//使str的长度扩大到转换成%20之后的长度,防止下标越界
        for(;indexold>=0 && indexold<newlength;--indexold){ 
                if(str.charAt(indexold) == ' '){  //
                str.setCharAt(indexnew--, '0');
                str.setCharAt(indexnew--, '2');
                str.setCharAt(indexnew--, '%');
                }else{
                    str.setCharAt(indexnew--, str.charAt(indexold));
                }
        }
        return str.toString();
    }
}
```

# 从尾到头打印链表

## 题目描述
输入一个链表，从尾到头打印链表每个节点的值。
思路2：
递归
```java
import java.util.ArrayList;
public class Solution {
    ArrayList<Integer> arrayList = new ArrayList<Integer>();
    public ArrayList<Integer> printListFromTailToHead(ListNode listNode) {
        if(listNode != null){
            this.printListFromTailToHead(listNode.next);
            arrayList.add(listNode.val);
        }
        return arrayList;
    }
}
```

思路2：
利用栈
```java
import java.util.Stack;
import java.util.ArrayList;
public class Solution {
    public ArrayList<Integer> printListFromTailToHead(ListNode listNode) {
        Stack<Integer> stack = new Stack<>();
        while (listNode != null) {
            stack.push(listNode.val);
            listNode = listNode.next;
        }
 
        ArrayList<Integer> list = new ArrayList<>();
        while (!stack.isEmpty()) {
            list.add(stack.pop());
        }
        return list;       
    }
}
```
# 二维数组中的查找

## 题目描述
在一个二维数组中，每一行都按照从左到右递增的顺序排序，每一列都按照从上到下递增的顺序排序。请完成一个函数，输入这样的一个二维数组和一个整数，判断数组中是否含有该整数。

## 解题思路
利用二维数组由上到下，由左到右递增的规律，
那么选取右上角或者左下角的元素a[row][col]与target进行比较，
当target小于元素a[row][col]时，那么target必定在元素a所在行的左边,
即col--；
当target大于元素a[row][col]时，那么target必定在元素a所在列的下边,
即row++；
时间复杂度是`O(2n)`
```java
public class Solution {
    public boolean Find(int target, int [][] array) {
        int row=0;
        int col=array[0].length-1;
        while(row<=array.length-1&&col>=0){
            if(target==array[row][col])
                return true;
            else if(target>array[row][col])
                row++;
            else
                col--;
        }
        return false;
    }
}
```

另一种思路是
把每一行看成有序递增的数组，
利用二分查找，
通过遍历每一行得到答案，
时间复杂度是`O(nlogn)`
```java
public class Solution {
    public boolean Find(int [][] array,int target) {
         
        for(int i=0;i<array.length;i++){
            int low=0;
            int high=array[i].length-1;
            while(low<=high){
                int mid=(low+high)/2;
                if(target>array[i][mid])
                    low=mid+1;
                else if(target<array[i][mid])
                    high=mid-1;
                else
                    return true;
            }
        }
        return false;
 
    }
}
```


<br>

---
<p id="div-border-left-red"><i>DigitalOcean 优惠码，注册充值 $5 送 $100，[链接一](https://m.do.co/c/282d5e1cf06e) [链接二](https://m.do.co/c/5eefb87c26cd)</i></span>
<p id="div-border-left-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>