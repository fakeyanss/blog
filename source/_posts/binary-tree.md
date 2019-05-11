---
title: 树和二叉树
tags:
  - binary tree
date: 2017-03-15 13:44:53
---
这里理一下数据结构中树和二叉树的知识。
<!-- more -->

---

## 树的定义

> （递归）一棵树是一些节点的集合。这个集合可以是空集；若不是空集，则树由称作**根**的节点 r 以及 0 个或多个非空的（子）树 **$T_1，T_2，···，T_k$** 组成，这些子树中每一棵的根都被来自根 r 的一条有向**边**所连结。

## 树的实现

```java
//树节点的声明
class TreeNode
{
    Object element;
    TreeNode firstChild;
    TreeNode netSibling;
}
```
将每个节点的所有儿子都放到树节点的链表中。

## 树的遍历
- 先序遍历
- 后序遍历
- 中序遍历

## 二叉树
> 二叉树（binary tree）是一棵树，其中每个节点都不能有多于两个的儿子。

二叉树平均深度为 $O(\sqrt{N})$，最大深度为 $N$。
二叉查找树的平均深度为 $O(log N)$。

```java
//二叉树节点类
class BinaryNode
{
    //Friendly data;accessible by other package toutines
    Object element;//The data in the node
    BinaryNode left;//Left child
    BinaryNode right;//right child
}
```

## 查找树ADT——二叉查找树
> 使二叉树成为查找树的性质是，对于树中的每个节点 X ，它的左子树中所有项的值小于 X 中的项，而它的右子树中所有项的值大于 X 中的项。

```java
//BinaryNode类
private static class BinaryNode<AnyType>
{
    //Constructors
    BinaryNode(AnyType theElement)
    {this(theElement, null, null);}

	BinaryNode(AnyType theElement, BinaryNode<AnyType> lt, BinaryNode<AnyType> rt)
	{element = theElement; left = lt; right = rt;}

	AnyType element;//The data in the node
	BinaryNode<AnyType> left;//Left child
	BinaryNode<AnyType> right;//Right child
}
```

### 二叉查找树架构

```java
//二叉查找树架构
public class BinarySearchTree<AnyType extends comparable<? super AnyType>>
{
	private static class BinaryNode<AnyType>
	{
		//Constructors
	    BinaryNode(AnyType theElement)
	    {this(theElement, null, null);}

		BinaryNode(AnyType theElement, BinaryNode<AnyType> lt, BinaryNode<AnyType> rt)
		{element = theElement; left = lt; right = rt;}

		AnyType element;//The data in the node
		BinaryNode<AnyType> left;//Left child
		BinaryNode<AnyType> right;//Right child
	}
		
	private BinaryNode<AnyType> root;

	public BinarySearchTree()
	{ root = null; }
	
	public void makeEmpty()
	{ root = null; }
	public boolean isEmpty()
	{ return root == null; }

	public boolean contains( AnyType x )
	{ return contains( x, root ); }
	public AnyType findMin()
	{
		if (isEmpty()) throw new UnderflowException();
		return findMin(root).element;
	}
	public AnyType finMax()
	{
		if (isEmpty()) throw new UnderflowException();
		return finMax(roow).element;
	}
	public void insert(AnyType x)
	{ root = insert(x,root); }
	public void remove(AnyType x)
	{ root = remove(x,root); } 
	public void printTree()
	{
		if (isEmpty())
			System.out.println("Empty tree");
		else
			printTree(root);
	}

	private boolean contains(AnyType x, BinaryNode<AnyType> t)
	{
		if (t == null) 
			return false;
		int compareResult = x.compareTo(t.element);

		if(compareResult < 0)
			return contains(x, t.left);
		else if(compareResult > 0)
			return contains(x, t.right);
		else
			return true; //Match
	}
	private BinaryNode<AnyType> findMin(BinaryNode<AnyType> t)
	{
		if(t == null)
			return null;
		else if(t.left == null)
			return t;
		return findMin(t.left);
	}
	private BinaryNode<AnyType> finMax(BinaryNode<AnyType> t)
	{
		if(t != null)
			while(t.right != null)
				t = t.right;

		return t;
	}
 
	private BinaryNode<AnyType> insert(AnyType x, BinaryNode<AnyType> t)
	{
		if(t == null)
			return new BinaryNode<>(x, null, null);

		int compareResult = x.compareTo(t.element);

		if(compareResult < 0)
			t.left = insert(x, t.left);
		else if(compareResult > 0)
			t.right = insert(x, t.right);
		else
			;//Duplicate; do nothing
		return t;
	}
	private BinaryNode<AnyType> remove(AnyType x, BinaryNode<AnyType> t)
	{
		if(t == null)
			return t;//Item not found; do nothing

		int compareResult = x.compareTo(t.element);

		if(compareResult < 0)
			t.left = remove(x, t.left);
		else if(compareResult > 0)
			t.right = remove(x, t.right);
		else if(t.left != null && t.right != null)//Two children
		{
			t.element = findMin(t.right).element;
			t.right = remove(t.element, t.right);
		}
		else
			t = (t.left != null) ? t.left : t.right;
		return t;
	}
	private void printTree(BinaryNode<AnyType> t)
	{
		if (t != null) {
			printTree(t.left);
			System.out.println(t.element);
			printTree(t.right);
		}
	}


}
```

### contains方法
> 如果树 $T$ 中含有项 $X$ 的节点，那么这个操作需要返回true，如果这样的节点不存在则返回false。树的结构使这种操作很简单。如果 $T$ 是空集，那么久返回false。否则，如果存储在 $T$ 处的项是 $X$ ，那么可以返回true。否则，我们对数 $T$ 的左子树或右子树进行一次递归调用，则依赖于 $X$ 与存储在 $T$ 中的项的关系。

```java
/**
 * Internal method to find an item in a subtree
 * @param  x is item to search for.
 * @param  t the node that roots the subtree.
 * @return true if the item is found; false otherwise.
 */

//二叉查找树的contains操作
private boolean contains(AnyType x, BinaryNode<AnyType> t)
	{
		if (t == null) 
			return false;
		int compareResult = x.compareTo(t.element);

		if(compareResult < 0)
			return contains(x, t.left);
		else if(compareResult > 0)
			return contains(x, t.right);
		else
			return true; //Match
	}
```

```java
	//递归用while循环代替
    while(compareResult <0)
    {
	    t=t.left;
	    compareResult = x.compareTo(t.element);
    }
```

> **算法表达式的简明性是以速度的降低为代价的。**

### findMin方法和findMax方法
> 这两个方法分别返回树中包含最小元和最大元的节点的引用。为执行findMin，从根开始并且只要有左儿子就向左进行。 终止点就是最小的元素。findMax除分支朝向右儿子其余过程相同。

```java
//用递归编写findMin，用非递归编写findMax
/**
* Internal method to find the smallest item in a subtree
* @param  t the node that roots the subtree.
* @return node containing the smallest item
*/
private BinaryNode<AnyType> findMin(BinaryNode<AnyType> t)
{
	if(t == null)
		return null;
	else if(t.left == null)
		return t;
	return findMin(t.left);
}
/**
* Internal method to find the largest item in a subtree
* @param  t the node that roots the subtree.
* @return node containing the largest item.
*/
private BinaryNode<AnyType> finMax(BinaryNode<AnyType> t)
{
	if(t != null)
		while(t.right != null)
			t = t.right;
	
	return t;
	}
```

### insert方法


```java
/**
 * Internal method to insert into a subtree
 * @param  x the item to insert
 * @param  t the node that roots the subtree
 * @return the new root of the subtree
 */ 
private BinaryNode<AnyType> insert(AnyType x, BinaryNode<AnyType> t)
{
	if(t == null)
		return new BinaryNode<>(x, null, null);

	int compareResult = x.compareTo(t.element);

	if(compareResult < 0)
		t.left = insert(x, t.left);
	else if(compareResult > 0)
		t.right = insert(x, t.right);
	else
		;//Duplicate; do nothing
	return t;
}
```

### remove方法

   

```java
	/**
	 * Internal method to remove from a subtree
	 * @param  x the item to remove.
	 * @param  t the node that roots the subtree.
	 * @return the new root of the subtree
	 */
	private BinaryNode<AnyType> remove(AnyType x, BinaryNode<AnyType> t)
	{
		if(t == null)
			return t;//Item not found; do nothing

		int compareResult = x.compareTo(t.element);

		if(compareResult < 0)
			t.left = remove(x, t.left);
		else if(compareResult > 0)
			t.right = remove(x, t.right);
		else if(t.left != null && t.right != null)//Node that has two children
		{
			t.element = findMin(t.right).element;//Find the minimum item of right subtree
			t.right = remove(t.element, t.right);//Remove the node of minimum item recursively			
		}
		else
			t = (t.left != null) ? t.left : t.right;//Node that has one children; parent of the node roots subtree of the node
		return t;
	}
```

> - 如果节点是树叶，可以直接删除。
> - 如果节点有一个儿子，这该节点需要在其父节点调整自己的链以绕过该节点
> - 如果节点有两个儿子，一般的删除策略是用其右子树的最小的数据代替该节点，并在右子树中递归地删除那个最小的节点

另外，如果删除的次数不多，通常使用的策略是懒惰删除（lazy deletion）：当一个元素要被删除时，它仍留在树中，而只是被标记为删除。

## AVL树
> AVL树是**带有平衡条件**的二叉查找树。
> 这个平衡条件必须要容易保持，而且它保证树的深度须是 $O(log N)$ 。
> 一个AVL树是其每个节点的左子树和右子树的高度最多差 1 的二叉查找树（空树的高度定义为 -1）。

可以知道，在高度为 $h$ 的AVL树中，最少节点数 $S(h)=S(h-1)+S(h-2)+1$ 给出。
对于 $h=0, S(h)=1; h=1, S(h)=2$ 。
函数 $S(h)$ 与斐波那契数密切相关。

那么重点来了，对于AVL树的插入操作，有可能破坏树的平衡性。这时候，我们就需要在这一步插入完成之前恢复平衡的性质。

可以知道，从插入的节点往上，逆行到根，若发生平衡信息改变，那么改变的节点一定在这条路径上。我们需要找出这个需要重新平衡的节点 $\alpha$ 。

对于节点 $\alpha$ ，不平衡条件可能出现在一下四种操作中：
1. 对 $\alpha$ 的左儿子的左子树进行一次插入（LL）。
2. 对 $\alpha$ 的左儿子的右子树进行一次插入（LR）。
3. 对 $\alpha$ 的右儿子的左子树进行一次插入（RL）。
4. 对 $\alpha$ 的右儿子的右子树进行一次插入（RR）。

对于1和4，是插入发生在外边的情况，通过对树的一次**单旋转**而完成调整。对于2和3，是插入发生在内部的情况，通过对树的一次**双旋转**而完成调整。

这里先对AvlNode类进行定义：

```java
private static class AvlNode<AnyType>
{
	//Constructors
	AvlNode(AnyType theElement)
	{this(theElement, null, null);}

	AvlNode(AnyType theElement, AvlNode<AnyType> lt, AvlNode<AnyType> rt)
	{element = theElement; left = lt; right = rt; height = 0;}

	AnyType element;//The data in the code
	AvlNode<AnyType> left;//Left child
	AvlNode<AnyType> right;//Right child
	int height;//Height
}
```

然后需要一个返回节点高度的方法：

​	

```java
	//返回AVL树的节点高度
	/**
	 * return the height of node t, or -1, if null.
	 */
	private int height(AvlNode<AnyType> t)
	{
		return t == null ? -1 : t.height;
	}
```

### 单旋转	
![LL单旋转](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190429221300.png)

```java
/**
 * Rotate binary tree node with left child.
 * For AVL trees, this is a single rotation for case 1.
 * Update heights, then return new root.
 */
private AvlNode<AnyType> RotationWithLeftChild(AvlNode<AnyType> k2) 
{  
    AVLTreeNode<AnyType> k1 = k2.left;  
  
    k2.left = k1.right;  
    k1.right = k2;  
  
    k2.height = Math.max( height(k2.left), height(k2.right)) + 1;  
    k1.height = Math.max( height(k1.left), k2.height) + 1;  
  
    return k1;  
}
```

![RR单旋转](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190429221627.png)

```java
/**
 * Rotate binary tree node with right child.
 * For AVL trees, this is a single rotation for case 4.
 * Update heights, then return new root.
 */
private AvlNode<AnyType> RotationWithRightChild(AvlNode<AnyType> k1) 
{  
    AVLTreeNode<AnyType> k2 = k1.right;  
  
  	k1.right = k2.left;  
   	k2.left = k1;  
   	
   	k1.height = Math.max( height(k1.left), height(k1.right)) + 1;  
    k1.height = Math.max( height(k2.right), k1.height) + 1;  
  
    return k2;  
}
```

### 双旋转
![LR双旋转](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190429221709.png)

```java
	/**
	 * Double rotate binary tree node: first left child
	 * with its right child; then node k3 with new left child.
	 * For AVL trees, this is a double rotation for case 2.
	 * Update heights, then return new root.
	 */
	private AvlNode<AnyType> doubleWithLeftChild(AvlNode<AnyType> k3)
	{
		k3.left = RotationWithRightChild(k3.left);
		return RotationWithLeftChild(k3);
	}
```

![RL双旋转](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190429221732.png)

```java
	/**
	 * Double rotate binary tree node: first right child
	 * with its left child; then node k1 with new right child.
	 * For AVL trees, this is a double rotation for case 3.
	 * Update heights, then return new root.
	 */
	private AvlNode<AnyType> doubleWithRightChild(AvlNode<AnyType> k1)
	{
		k1.right = RotationWithRightChild(k1.right);
		return RotationWithLeftChild(k1);
	}
```
### AVL树的插入方法

> 插入方法就是前文中的insert方法，只是在最后一行调用平衡的方法以保持AVL树的平衡性。
```java
	/**
	 * Internal method to insert into a subtree.
	 * @param  x the item to insert.
	 * @param  t the node that roots the subtree.
	 * @return the new root of the subtree.
	 */
	private AvlNode<AnyType> insert(AnyType x, AvlNode<AnyType> t)
	{
		if(t == null)
			return new	AvlNode<>(x, null, null);

		int compareResult = x.compareTo(t.element);

		if(compareResult < 0)
			t.left = insert(x, t.left);
		else if(compareResult > 0)
			t.right = insert(x, t.right);
		else
			;//Duplicate; do nothing
		return balance(t);
	}

	private static final int ALLOWED_IMBALLANCE = 1;

	//Assume t is either balanced of within one of being balanced
	private AvlNode<AnyType> balance(AvlNode<AnyType> t)
	{
		if(t == null)
			return t;

		if(height(t.left) - height(t.right) > ALLOWED_IMBALLANCE)
			if(height(t.left.left) >= height(t.left.right))
				t = RotationWithLeftChild(t);
			else
				t = doubleWithLeftChild(t);
		else
		if(height(t.right) - height(t.left) > ALLOWED_IMBALLANCE)
			if(height(t.right.right) >= height(t.right.left))
				t = RotationWithRightChild(t);
			else
				t = doubleWithRightChild(t);

		t.height = Math.max(height(t.left), height(t.right)) + 1;
		return t;
	}
```

### AVL树的删除方法
> 和AVL树的插入一样，只用在前文的删除方法最后加上一行调用平衡的方法即可。

```
	private AvlNode<AnyType> remove(AnyType x, AvlNode<AnyType> t)
	{
		if(t == null)
			return t;//Item not found; do nothing

		int compareResult = x.compareTo(t.element);

		if(compareResult < 0)
			t.left = remove(x, t.left);
		else if(compareResult > 0)
			t.right = remove(x, t.right);
		else if(t.left != null && t.right != null)//Node that has two children
		{
			t.element = findMin(t.right).element;//Find the minimum item of right subtree
			t.right = remove(t.element, t.right);//Remove the node of minimum item recursively			
		}
		else
			t = (t.left != null) ? t.left : t.right;//Node that has one children; parent of the node roots subtree of the node
		return balance(t);
	}
```

<br>

---
<p id="div-border-left-red"><i>DigitalOcean 优惠码，注册充值 $5 送 $100，[链接一](https://m.do.co/c/282d5e1cf06e) [链接二](https://m.do.co/c/5eefb87c26cd)</i></span>
<p id="div-border-left-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>