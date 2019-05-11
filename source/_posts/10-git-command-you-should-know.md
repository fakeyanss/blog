---
title: 你应该知道的10个Git命令
date: 2019-03-17 21:48:24
tags: [git, Review]
---
201902W11 Review, Git的一些常用且很有用的命令
<!-- more -->

---

原文链接：[10 Git Commands You Should Know](https://towardsdatascience.com/10-git-commands-you-should-know-df54bea1595c)

by Jeff Hale

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

如果你正在处理你没有合并到远程多人工作里的本地提交，你可以使用任何这些命令。

如果你在多人工作里需要消除一个远程分支的提交，`git revert` 是你的工具。

![undo](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190501155041.png)

每个这些命令都可以加上不同的参数。这里是通用的用法：

- [`git reset --hard HEAD`](https://www.atlassian.com/git/tutorials/resetting-checking-out-and-reverting) —— 丢弃已暂存和为暂存的改变，恢复到最近的一次提交。

特别指定一个不同的提交代替 `HEAD` 可以丢弃改变直到该条提交。`--hard` 特指已暂存和未暂存的改变都被撤除。

确认你没有从远程分支删除一个你的合作者依赖的提交。

- [`git checkout my_commit`](https://www.atlassian.com/git/tutorials/undoing-changes) —— 从 *my_commit* 后删除为暂存的改变。

`HEAD` 通常用在 `my_commit` 来撤销改变，将你本地的工作目录恢复到最近的依次提交状态。

`checkout` 被最多的用于仅在本地的撤销。它不会从远程分支弄混你的合作者依赖的提交历史！

如果你使用 `checkout` 时用一个分支代替提交，`HEAD` 被切换到指定分支，工作目录也被相应更新。这是是 `checkout` 更公共的用法。

- [`git revert my_commit`](https://www.atlassian.com/git/tutorials/undoing-changes/git-revert) —— 撤销 *my_commit* 里的改变的影响。`revert` 撤销改变时，会生成一个新的提交。

`revert` 对多人合作项目是安全的，因为它不会重写其他用户的分支可能依赖的提交历史。

![](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190501161219.png)
<div style="text-align: center;">revert is safe</div>

有时你只想删除你本地目录未被追踪的文件。比如，可能你运行了一些代码去创建大量不同类型的文件，这些文件你并不想加到你的仓库。Oops. 😏 你可以快速地清除它们。

- [`git clean -n`](https://www.atlassian.com/git/tutorials/undoing-changes/git-clean) —— 删除本地目录未追踪的文件。

`-n` 标志 "is for a dry run where nothing is deleted." ?

使用 `-f` 标志去强制移除文件。

使用 `-d` 标志去移除未追踪的目录。

默认的 *.gitignore* 指定的未追踪文件不会被删除，但是这个行为可以被更改。

![](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190501162527.png)

现在你了解了 Git 里的撤销事情的工具，让我们看下保持事情有序的两个命令。


## 整理

- [`git commit --amend`](https://www.atlassian.com/git/tutorials/rewriting-history#git-commit--amend) —— 添加暂存的改变到最近的一条提交里。

如果没有被暂存的，这个命令就只允许你编辑最近的提交信息。只在这个提交没被整合进远程主分支的时候使用这个命令！

- [git push my_remote --tags](https://www.atlassian.com/git/tutorials/syncing/git-push) —— 发送所有的本地标签到远程仓库。有利于版本变化。

如果你在使用 Python 并在你创建的包里生成改变，[bump2version](https://pypi.org/project/bump2version/) 会自动地为你创建标签。一旦你推送了你的标签，你就可以在发布中使用它们。[这是我的指导](https://towardsdatascience.com/build-your-first-open-source-python-project-53471c9942a7?source=friends_link&sk=576540dbd90cf2ee72a3a0e0bfa72ffb) ，帮你生成你的第一个 OSS Python 包。关注 [我](https://medium.com/@jeffhale) 来确认你没有遗失发版部分！

## 求助，我陷在 Vim 里出不来了！

使用 Git，你可能偶尔发现自己被丢进了一个 Vim 编辑器里。比如，你试图提交，但没写提交消息 —— Vim 将会自动打开。如果你不知道 Vim，一种糟糕的东西（大误） —— 看看 [这个 4000+ 赞同的 Stack Overflow 回答](https://stackoverflow.com/a/11828573/4590385)，了解怎样退出它。

![](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190501164225.png)
<div style="text-align: center;">Freedom!</div>

这里是保存文件退出 Vim 的 4 步计划：

1. 按 `i` 进入输入模式。
2. 在第一行输入你的提交信息。
3. 按退出键 —— `Esc`。
4. 输入 `:x`。不要忘了冒号。

欢呼，你自由了！ 😄

## 改变默认编辑器

为了完全避免 Vim，你可以在 Git 里改变你的默认编辑器。（这一段我不翻译，Vim 天下第一）

## 创建 Git 命令的快捷方式

![](https://cdn-images-1.medium.com/max/1600/1*iyvZMHER_5neLUhZaXSCdw.jpeg)

通过添加下面的别名到你的 *.bash_profile* 来添加 Git 命令的快捷方式。

```sh
alias gs='git status '
alias ga='git add '
alias gaa='git add -A '
alias gb='git branch '
alias gc='git commit '
alias gcm='git commit -m '
alias go='git checkout '
```

你可以调整这些，为你喜欢的 Git 命令添加快捷方式。

如果你没有一个 *.bash_profile*，你可以在 macOS 上创建一个：
 
 ```sh
 touch ~/.bash_profile
 ```

然后打开它：

```sh
open ~/.bash_profile
```

[在这](https://stackoverflow.com/a/30462883/4590385)查看更多有关 *.bash_profile* 的信息。

现在当你在终端输入 `gs` ，就等同于输入 `git status`。注意你可以在你的快捷方式后输入其他的参数。

你也可以生成 Git 别名，但是那需要你在你的快捷命令前输入 `git`。谁需要哪些额外的一下呢？（我，bash_profile的别名太多容易混淆，另外附赠一条更好地查看git log的别名
```
alias glg='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset" --abbrev-commit --date=relative'
```
）

## 结语

在这篇文章里你可以看到一些关键的 Git 命令，以及配置环境节省时间。现在理由了 Git 和 Github 的基础了。准备好开始下一步了吗？

* Check out [this Bitbucket Git tutorial](https://www.atlassian.com/git/tutorials/learn-git-with-bitbucket-cloud) to go deeper.
* Explore this [interactive guide](https://learngitbranching.js.org/) to Git branching. Branching can be confusing, so it’s definitely worth a look. 🔎
* Go play, learn, and explain the differences to someone else.

我希望你发现这个对 Git 和 Github 的介绍是有用的。如果你是的，请在你喜欢的社交媒体频道上分享它，这样其他人也能看见。

我写关于如何有效和便捷地使用 Python、Docker 和 其他的编程和数据科学工具。如果你有兴趣，在[这里](https://medium.com/@jeffhale)关注我了解更多。

去使用 Git 吧！

![](https://cdn-images-1.medium.com/max/2400/1*jEf16zycWCHBGCn56W-VPA.jpeg)

<br>

---
<p id="div-border-left-red"><i>DigitalOcean 优惠码，注册充值 $5 送 $100，[链接一](https://m.do.co/c/282d5e1cf06e) [链接二](https://m.do.co/c/5eefb87c26cd)</i></span>
<p id="div-border-left-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>