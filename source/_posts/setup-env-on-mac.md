---
title: Mac从零搭建开发环境
date: 2021-03-15 00:05:16
tags: Mac, 开发环境
---

手上一台几乎闲置的mbp mid 2015，最近升级了Big Sur，感觉焕然一新，想作为主力机使用了，毕竟硬件配置比公司给的低配mbp还好一截。按照现在习惯的开发环境，重新装了一遍（下次试试用dotfiles管理）。

<!-- more -->

## 安装字体

```
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh
```

## 安装homebrew

国内网络环境太差，安装速度过慢，挂了代理依然只有几十KB的速度，只能选择换镜像源。

首先，需要已经安装了 bash、git 和 curl，以及 Command Line Tools (CLT) for Xcode， `xcode-select --install` 。

接着，在终端输入以下几行命令设置环境变量：

```bash
BREW_TYPE="homebrew"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/${BREW_TYPE}-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/${BREW_TYPE}-bottles"
```

最后，在终端运行以下命令以安装 Homebrew / Linuxbrew：

```bash
git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
/bin/bash -c "$(
    cat brew-install/install.sh |
    sed -E 's|^(\s*HOMEBREW_BREW_GIT_REMOTE=)(.*)$|\1"${HOMEBREW_BREW_GIT_REMOTE:-\2}"|g' |
    sed -E 's|^(\s*HOMEBREW_CORE_GIT_REMOTE=)(.*)$|\1"${HOMEBREW_CORE_GIT_REMOTE:-\2}"|g'
)"
rm -rf brew-install
```

这样在首次安装的时候也可以使用镜像。

安装好homebrew之后，需要设置常用taps以及换源：

```bash
BREW_TAPS="$(brew tap)"
for tap in core cask{,-fonts,-drivers,-versions}; do
    if echo "$BREW_TAPS" | grep -qE "^homebrew/${tap}\$"; then
        # 将已有 tap 的上游设置为本镜像并设置 auto update
        # 注：原 auto update 只针对托管在 GitHub 上的上游有效
        git -C "$(brew --repo homebrew/${tap})" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-${tap}.git
        git -C "$(brew --repo homebrew/${tap})" config homebrew.forceautoupdate true
    else   # 在 tap 缺失时自动安装（如不需要请删除此行和下面一行）
        brew tap --force-auto-update homebrew/${tap} https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-${tap}.git
    fi
done
```

更换上游后需重新设置 git 仓库 HEAD：

```bash
brew update-reset
```

如有问题，可以复原仓库上游：

```bash
BREW_TAPS="$(brew tap)"
for tap in core cask{,-fonts,-drivers,-versions}; do
    if echo "$BREW_TAPS" | grep -qE "^homebrew/${tap}\$"; then
        git -C "$(brew --repo homebrew/${tap})" remote set-url origin https://github.com/Homebrew/homebrew-${tap}.git
    fi
done

# 重新设置 git 仓库 HEAD
brew update-reset
```

二进制预编译包bottles换源：

```bash
# 临时替换
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"

# 长期替换
# bash
echo 'export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"' >> ~/.bash_profile
# zsh
echo 'export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"' >> ~/.zprofile
```

## 安装iTerm2

使用homebrew安装：

```
brew install --cask iterm2
```

安装主题nord：

```
wget https://raw.sevencdn.com/arcticicestudio/nord-iterm2/develop/src/xml/Nord.itermcolors
```

`preferences → profiles → colors → color preset → import`，选择下载的主题文件。

![image-20210314212900552](https://foreti.me/imgplace/2021/2021-03-15_2021-03-14_image-20210314212900552-39213e-57127d.png)

设置光标跳转，`preferences → Keys → Preset → Natural Text Editing` 。

![image-20210314232121400](https://foreti.me/imgplace/2021/2021-03-15_2021-03-14_image-20210314232121400-6d9e01-4e6ffa.png)

## 安装oh-my-zsh

安装oh-my-zsh与命令补全、高亮：

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

然后修改 `vim.zshrc`，找到 `plugins=(git)` 改为 `plugins=(git zsh-autosuggestions zsh-syntax-highlighting)`

设置主题：

Clone this repo:

```
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
```

Symlink `spaceship.zsh-theme` to your oh-my-zsh custom themes directory:

```
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme" 
```

Set `ZSH_THEME="spaceship"` in your `.zshrc`.

最终样式：

![image-20210317234829665](https://foreti.me/imgplace/2021/2021-03-17_image-20210317234829665-06705d.png)

## 安装tmux

安装tmux：

```bash
brew install tmux
```

### oh-my-tmux

选择用oh-my-tmux一键配置：

```
cd ~
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .


brew install reattach-to-user-namespace
```

后续所有tmux配置在 `.tmux.conf.local` 中修改即可。

### 主题nord-tmux

nord是一个干净的、冷色调的配色主题，提供了一组主题插件集合，包含诸如 jetbrains、vscode、vim、tmux 的主题插件，这里有全部的[插件仓库](https://github.com/arcticicestudio?tab=repositories&q=nord-&type=&language=)。

在 `.tmux.conf.local` 中搜索plugin位置，在下面增加一行：

```bash
set -g @plugin "arcticicestudio/nord-tmux"
```

最终效果：

![image-20210317235420004](https://foreti.me/imgplace/2021/2021-03-17_image-20210317235420004-e88c55.png)

## 安装多版本jdk

activate the AdoptOpenJDK：

```
brew tap AdoptOpenJDK/openjdk
```

使用国内镜像安装jdk8，编辑rb文件，替换下载的url：

```ruby
vim /usr/local/Homebrew/Library/Taps/adoptopenjdk/homebrew-openjdk/Casks/adoptopenjdk8.rb


cask "adoptopenjdk8" do
  version "8,282:b08"
  sha256 "f12d380ceae806d02c4cae23bdc601402c543692c763122286b99d8ef6059794"

  # github.com/AdoptOpenJDK was verified as official when first introduced to the cask
  #url "https://github.com/AdoptOpenJDK/openjdk#{version.before_comma}-binaries/releases/download/jdk8u282-b08/OpenJDK8U-jdk_x64_mac_hotspot_8u282b08.pkg",
  url "https://mirrors.tuna.tsinghua.edu.cn/AdoptOpenJDK/8/jdk/x64/mac/OpenJDK8U-jdk_x64_mac_hotspot_8u282b08.pkg",
      verified: "https://github.com/AdoptOpenJDK"
  appcast "https://github.com/adoptopenjdk/openjdk#{version.before_comma}-binaries/releases/latest"
  name "AdoptOpenJDK 8"
  desc "AdoptOpenJDK OpenJDK (Java) Development Kit"
  homepage "https://adoptopenjdk.net/"

  pkg "OpenJDK8U-jdk_x64_mac_hotspot_8u282b08.pkg"

  postflight do
    system_command "/usr/sbin/pkgutil", args: ["--pkg-info", "net.adoptopenjdk.8.jdk"], print_stdout: true
  end

  uninstall pkgutil: "net.adoptopenjdk.8.jdk"
end
```

同样，jdk11、jdk15可以替换url安装：

```bash
vim /usr/local/Homebrew/Library/Taps/adoptopenjdk/homebrew-openjdk/Casks/adoptopenjdk11.rb

url "https://mirrors.tuna.tsinghua.edu.cn/AdoptOpenJDK/11/jdk/x64/mac/OpenJDK11U-jdk_x64_mac_hotspot_11.0.10_9.pkg"


vim /usr/local/Homebrew/Library/Taps/adoptopenjdk/homebrew-openjdk/Casks/adoptopenjdk15.rb

url "https://mirrors.tuna.tsinghua.edu.cn/AdoptOpenJDK/15/jdk/x64/mac/OpenJDK15U-jdk_x64_mac_hotspot_15.0.2_7.pkg"
```

替换url之后，执行：

```bash
brew install --cask adoptopenjdk8
brew install --cask adoptopenjdk11
brew install --cask adoptopenjdk15
```

可以使用 jenv 管理jdk多版本：

```bash
brew install jenv
```

在 `.zshrc` 中添加jenv环境：

```bash
# java env
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
```

查看已安装的jdk版本和路径：

```bash
/usr/libexec/java_home -V

Matching Java Virtual Machines (3):
    15.0.2 (x86_64) "AdoptOpenJDK" - "AdoptOpenJDK 15" /Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home
    11.0.10 (x86_64) "AdoptOpenJDK" - "AdoptOpenJDK 11" /Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home
    1.8.0_282 (x86_64) "AdoptOpenJDK" - "AdoptOpenJDK 8" /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
```

添加到 jenv 中管理：

```bash
jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-15.jdk/Contents/Home
jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home
jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
```

设置全局默认 jdk 版本：

```bash
jenv global 1.8
```

## 安装maven
homebrew安装：
```bash
brew install maven
```

设置环境（一般不需要）：
```bash
# 查询安装路径
mvn --version

Apache Maven 3.6.3 (cecedd343002696d0abb50b32b541b8a6ba2883f)
Maven home: /usr/local/Cellar/maven/3.6.3_1/libexec
Java version: 15.0.2, vendor: N/A, runtime: /usr/local/Cellar/openjdk/15.0.2/libexec/openjdk.jdk/Contents/Home
Default locale: zh_CN_#Hans, platform encoding: UTF-8
OS name: "mac os x", version: "11.2.3", arch: "x86_64", family: "mac"

# 设置环境变量
vim ~/.zshrc

export M2_HOME=/usr/local/Cellar/maven/3.6.3_1/libexec
export M2=$M2_HOME/bin
```

## 安装node

homebrew安装n（node版本管理）：

```bash
brew install n
```

下载最新lts版本node和npm：

```bash
n lts
```

设置npm镜像：

```bash
vim ~/.zshrc

# node, npm
export NODE_MIRROR=https://npm.taobao.org/dist/
```

## 安装python

homebrew安装anaconda：

```bash
brew cask install anaconda
```

创建python环境

```bash
conda create -n py2 python=2.7
conda create -n py3 python=3.8
```

## 安装vscode

jetbrains全家桶固然爽，但是我的账号已经过期，又不想交钱，而且公司配的电脑是乞丐版mbp，8g内存太吃紧了。不过公司提供的开发机倒是有4 c 16g的配置，而且提供了定制化的vscode server软件包，在开发机docker启动vscode server，然后本地mbp运行一个配套的定制化vscode client，等于直接在开发机远程coding。这本来是大多数使用c++开发的同事的方案，不过参考vscode提供的[support for java](https://code.visualstudio.com/docs/languages/java)方案，加入必要的java、maven、spring等插件后，完全可以作为jetbrain idea intellij的替代方案。

目前使用了近半年vscode做为主力开发ide，我的低配办公mbp已经很少发出风扇的声音，习惯vscode的coding、debug流程之后，效率反而变高了不少，毕竟再也不卡顿了。

安装vscode：

```bash
brew install --cask visual-studio-code
```

去应用市场安装插件

```
Java Extension Pack(包含Java开发常用插件)
Spring Boot Extension Pack(包含springboot开发常用插件)
```

## 别名配置

### git

设置git全局config：
```bash
git config --global -e


[user]
    name = fakeyanss
    email = yanshisangc@gmail.com
[core]
    editor = vim
[alias]
    # Shortening aliases
    co = checkout
    cob = checkout -b
    f = fetch -p
    c = commit
    p = push
    ba = branch -a
    bd = branch -d
    bD = branch -D
    dc = diff --cached

    # Feature improving aliases
    st = status -sb
    a = add -p

    # Complex aliases
    plog = log --graph --pretty='format:%C(red)%d%C(reset) %C(yellow)%h%C(reset) %ar %C(green)%aN%C(reset) %s'
    tlog = log --stat --since='1 Day Ago' --graph --pretty=oneline --abbrev-commit --date=relative
    lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
    rank = "!git shortlog -sn --no-merges"
    bdm = "!git branch --merged | grep -v '*' | xargs -n 1 git branch -d"
    ranks = "!git log --format='%aN' | sort -u | while read name; do echo \"\\033[32m$name\\033[0m\t\"; git log --author=\"$name\" --pretty=tformat: --numstat | awk \"{ add += \\$1; subs += \\$2; loc += \\$1 - \\$2 } END { printf \\\"added lines: %s, removed lines: %s, total lines: %s\\n\\\", add, subs, loc }\" -; done"
```

### mysql

安装mycli客户端
```bash
brew install mycli
```

配置常用连接别名：
```bash
vim ~/.zshrc
alias devdb='mycli -h127.0.0.1 -P3306 -Ddev -udev -pdev'
```