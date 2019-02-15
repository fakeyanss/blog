---
title: [201902W5 Algorithm] Leetcode 4 and 11
categories:
tags:
  - Leetcode
  - Algorithm
mathjax: false
copyright: true
reward: true
toc: true
date: 2019-02-15 21:27:23
kewords:
description:
password:
---
### 11. Container With Most Water

Given n non-negative integers a1, a2, ..., an , where each represents a point at coordinate (i, ai). nvertical lines are drawn such that the two endpoints of line i is at (i, ai) and (i, 0). Find two lines, which together with x-axis forms a container, such that the container contains the most water.

**Note:** You may not slant the container and n is at least 2.

![](http://pic.yanss.top/2019/20190215203328.png)

The above vertical lines are represented by array [1,8,6,2,5,4,8,3,7]. In this case, the max area of water (blue section) the container can contain is 49. 

Example:
```
Input: [1,8,6,2,5,4,8,3,7]
Output: 49
```

**Submission:**
```java
class Solution {
    public int maxArea(int[] height) {
        int maxarea = 0;
        int l = 0;
        int r = height.length - 1;
        while (l < r) {
            maxarea = Math.max(maxarea, Math.min(height[l], height[r]) * (r - l));
            if (height[l] < height[r]) {
                l++;
            } else {
                r--;
            }
        }
        return maxarea;
    }
}
```
**Detail:**
![](http://pic.yanss.top/2019/20190215203653.png)


### 4. Median of Two Sorted Arrays

There are two sorted arrays nums1 and nums2 of size m and n respectively.

Find the median of the two sorted arrays. The overall run time complexity should be O(log (m+n)).

You may assume nums1 and nums2 cannot be both empty.

Example 1:
```
nums1 = [1, 3]
nums2 = [2]

The median is 2.0
```
Example 2:
```
nums1 = [1, 2]
nums2 = [3, 4]

The median is (2 + 3)/2 = 2.5
```

**Submission:**
```java
class Solution {
    public double findMedianSortedArrays(int[] nums1, int[] nums2) {
        int[] merge = new int[nums1.length + nums2.length];
        int i = 0, j = 0, k = 0;
        while (i < nums1.length && j < nums2.length) {
            if (nums1[i] < nums2[j]) {
                merge[k++] = nums1[i++];
            } else {
                merge[k++] = nums2[j++];
            }
        }
        while (i < nums1.length) {
            merge[k++] = nums1 [i++];
        }
        while (j < nums2.length) {
            merge[k++] = nums2 [j++];
        }
        k = merge.length;
        if (k % 2 == 0) {
            return (merge[k / 2 - 1] + merge[k / 2]) * 1d / 2;
        } else {
            return merge[k / 2];
        }
    }
}
```

**Detail:**
![](http://pic.yanss.top/2019/20190215204526.png)



<br>

<p id="div-border-top-green"><i>最后要说的是: [博客源码](https://github.com/fakeYanss/fakeYanss.github.io/tree/source), 欢迎 star</i></p>