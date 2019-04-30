title: 你应该知道的10个Git命令
date: 2019-03-17 21:48:24
tags: git
---
201902W11 Review, Git的一些常用且很有用的命令
<!-- more -->

原文链接：[10 Git Commands You Should Know](https://towardsdatascience.com/10-git-commands-you-should-know-df54bea1595c)

在这篇文章，我们将讨论你作为一名开发者、数据科学家或者产品经理应该知道的各种 Git 命令。我们将关注用 Git 进行审查、移除和整理。我们还提供方法去设置 Git 编辑器配置来避免 Vim 和使用 Bash 别名节省时间。

如果你对基础的 git 命令不熟悉，先读一下我的[前一篇文章](https://towardsdatascience.com/learn-enough-git-to-be-useful-281561eef959)，关于 Git 工作流。

这里有 10 个要知道的命令和一些公共的标志。每个命令都链接到相关的 Atlassian Bitbucket 指导。

## 审查

让我们先检查变化。

![](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190430170003.png)

- [git diff](https://www.atlassian.com/git/tutorials/saving-changes/git-diff) —— 查看本地所有文件的变化。后面加上文件名可以只查看一个文件的变化
- [git log](https://www.atlassian.com/git/tutorials/git-log) —— 查看所有的提交历史。也可以用于一个文件，`git log -p my_file`。输入`q`退出。
- [git balme my_file]() —— 查看改变了 *my_file* 的人，以及改变的内容和时间。
- [git reflog](https://www.atlassian.com/git/tutorials/rewriting-history/git-reflog) —— 查看变化的日志，直到本地仓库的 HEAD。有利于找到丢失的工作。
 
使用 Git 审查事情并不是非常让人困惑。相反的，Git 提供了太多的移除和撤回提交以及文件改动操作。

## 撤回

`git reset`，`git checkout` 和 `git revert` 被用于撤回变化对仓库的影响。这些命令可能回难以保持直线。

`git reset` 和 `git checkout` 可以被用于提交和单独的文件。`git revert` 只被用在提交级别。

[to be continue]


<br>
<p id="div-border-top-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>