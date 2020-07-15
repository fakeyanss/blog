---
title: centos搭建Jupyter Notebook
tags:
  - jupyter
date: 2018-07-06 20:56:58
---
centos搭建Jupyter Notebook, 添加多语言支持(R,Ruby,Octave,JS,Java,C++).

<!-- more -->

---

![](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/centos-jn-overview.png)

# 常用命令
主要熟悉常用命令， 
`wget [url]`下载，

`tar -xvf`解压`.tar.gz`，

使用yum包管理工具`yum search xx`搜索, `yum install xx`下载。

`whereis`，`which`查找文件， `find [path] -name xxx`查找指定目录下的文件

`ps -ef | grep jupyter` 查看jupyter运行的pid

# 安装jupyter

1. 下载Anaconda最新版本，省事。在官网找到下载链接，python3.6版本，然后
```sh
wget https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh 
```
    然后运行脚本
    ```sh
    bash Anaconda3-3-5.2.0-Linux-x86_64.sh
    ```
    中间需要确定时确定即可，等待安装完成，会自动写入环境变量。
    ```sh
    conda --version
    jupyter --version
    ```

2. 然后按照官网步骤，设置config
```sh
jupyter notebook --generate-config
# 会生成config文件为 .jupyter/jupyter_notebook_config.py
```
    设置密码
    ```
    from notebook.auth import passwd
    passwd()
    # 会生成类似 sha1:xxxxxxxxxxxxxxxxxxx， 需要记一下
    ```

    然后编辑 config文件
    ```
    vim .jupyter/jupyter_notebook_config.py
    ```

    修改这些行，去掉注释，填相应值。其他选项也可以自己设置
    ```
    c.NotebookApp.password = 'sha1:xxxxxxxxxxxxxxxxxxx'
    c.NotebookApp.ip = '*'
    c.NotebookApp.open_browser = False
    c.NotebookApp.port = 8888
    ```

3. 开放和重启防火墙
    centos7：
    ``` 
    firewall-cmd --zone=public --add-port=8888/tcp --permanent # 永久开放8888端口
    firewall-cmd --reload # 重启firewall
    firewall-cmd --list-ports # 查看开放端口
    ```

    centos6：
    ```
    /sbin/iptables -I INPUT -p tcp --dport 8888 -j ACCEPT # 开放8888端口
    /etc/rc.d/init.d/iptables save # 保存
    service iptables status # 查看防火墙状态
    ```

4. 启动server，`jupyter notebook`。如果需要后台启动，运行
`nohup jupyter notebook > jupyter.log 2>&1 &`


# 安装其他kernel

主要根据 [Jupyter kernels wiki](https://github.com/jupyter/jupyter/wiki/Jupyter-kernels）

## py2.7

```
conda create -n ipykernel_py2 python=2 ipykernel
source activate ipykernel_py2
python -m ipykernel install --user
```

## ruby

[iruby](https://github.com/SciRuby/iruby), ruby需要版本大于2.1

1. 准备工作，安装环境。
yum 下载的可能不是最新的ruby，所以用
```
sudo yum install -y git-core ruby-devel ruby zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make
```

2. ruby kernel需要ZeroMQ
```
sudo yum install zeromq-devel zeromq czmq
gem install cztop rbczmq ffi_rzmq
```

3. 安装iruby kernel
```
gem install cztop iruby
iruby register --force
```

## R
按照[irkernel](https://irkernel.github.io/)的安装步骤，
或者直接
```
conda install -c r r-essentials
```

## octave

pip

```
pip install octave_kernel
```

或者conda

```
conda config --add channels conda-forge
conda install octave_kernel
```

## js

首先安装nodejs和npm，然后

```
npm install -g ijavascript
ijsinstall
```

## java

[IJava](https://github.com/SpencerPark/IJava) ,需要安装java 9或10，设置好环境变量，

```
export JAVA_HOME=/usr/java/jdk-10.0.1/
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$JAVA_HOME/bin:$PATH
```

然后

```
git clone https://github.com/SpencerPark/IJava.git --depth 1
cd IJava/
chmod u+x gradlew
./gradlew installKernel
```

## c++

[xues-cling](https://github.com/QuantStack/xeus-cling)

```
conda create -n cling
source activate cling
conda install xeus-cling notebook -c QuantStack -c conda-forge
```

有个问题是需要切换到cling环境启动jupyter才会有c++的kernel，找了一下cling 的kernel文件

```
find anaconda3/envs/cling -name kernels
```

输出

```
anaconda3/envs/cling/lib/python3.6/site-packages/notebook/services/kernels
anaconda3/envs/cling/lib/python3.6/site-packages/notebook/static/services/kernels
anaconda3/envs/cling/share/jupyter/kernels
```

进入到`/share/jupyter/kernels`，发现了

```
cd anaconda3/envs/cling/share/jupyter/kernels
ll
```

输出

```
total 16
drwxr-xr-x 2 root root 4096 Jul  5 14:48 python3
drwxr-xr-x 2 root root 4096 Jul  5 14:48 xeus-cling-cpp11
drwxr-xr-x 2 root root 4096 Jul  5 14:48 xeus-cling-cpp14
drwxr-xr-x 2 root root 4096 Jul  5 14:48 xeus-cling-cpp17
```

现在，看一下jupyter kernel的文件目录在哪

```
jupyter kernelspec list
```

输出

```
Available kernels:
  java                /root/.ipython/kernels/java
  ruby                /root/.ipython/kernels/ruby
  ir                  /root/.local/share/jupyter/kernels/ir
  javascript          /root/.local/share/jupyter/kernels/javascript
  python2             /root/.local/share/jupyter/kernels/python2
  python3             /root/.local/share/jupyter/kernels/python3
  octave              /root/anaconda3/share/jupyter/kernels/octave
  bash                /usr/local/share/jupyter/kernels/bash
```

确定是`.ipython/kernels/`的这一个。

将`xeus-cling-cpp11  xeus-cling-cpp14  xeus-cling-cpp17`这三个文件夹复制到`.ipython/kernels/`下

```
cp xeus-cling-cpp11 .ipython/kernels/
cp xeus-cling-cpp14 .ipython/kernels/
cp xeus-cling-cpp17 .ipython/kernels/
```

完成。




