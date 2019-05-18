title: TODO with Mac Menubar
date: 2019-05-17 20:18:43
tags: Tool
---
BitBar 使我工作更快乐！
<!-- more -->

---

最近觉得每天的计划总是完不成，明明也不多，但是很容易被其他事情干扰。我一直不喜欢用日程表来排每天的事情，但我很喜欢给自己制定一个 TODO 列表，这个列表包含了短期内要做的事情，但不限于某一天或者某一个小时，不至于太细致，让自己经常不能按时完成，获得过多的挫败感。

我希望的展现形式是在电脑桌面上时刻可以看到的，这样的话，就不能用各种流行的 GTD 工具。像 OmniFocus、Microsoft To-Do等，都需要先打开再确认的过程。

像桌面便签也不太好，因为平时是打开了不同的应用铺满了桌面。

于是想到了菜单栏上可以做点事情。

找了一圈，Mac平台上的 TODO in menubar 的应用还不少，最合心意的是 [TODO Menubar](https://www.mactodo.app/?ref=producthunt)。
![TODO Menubar](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190517153927.png)
但是它收费...

还有一个[Doo](https://itunes.apple.com/us/app/doo-get-things-done/id1066322956?mt=8)，也收费，而且太花哨了，好看但不直观。
![](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190517160402.png)


在 Github 上也搜到了一个[postit-todo](https://github.com/Praseetha-KR/postit-todo)，不错但是用起来太卡，而且关闭后重新打开加载数据很慢。
![](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190517160158.png)

最后，在 AppSo 的一篇推 TODO Menubar 的文章评论里看到了 [BitBar](https://getbitbar.com/)。

BitBar 是一个可以编写脚本，将你能想到的任何信息，放到 menubar 里显示。

我下载 BitBar，并且在它的插件市场里找了一个 TODO 的[脚本](https://raw.githubusercontent.com/matryer/bitbar-plugins/master/Tools/todolist.2m.sh)。这个脚本实现的是在 Mac 的原生 Reminder 应用里指定一个提醒列表，将这个列表里的提醒事项放到菜单栏显示，并且只显示第一个，在菜单栏点击这个提醒事项，可以将它再 Reminder 里标记为完成。

我觉得这个脚本基本实现了我想要的，但是偶尔事情太多，不想只看第一个事项，也不行点一下就标记完成，所以改了下脚本内容。

```sh
#!/bin/sh

if [ "$1" = "open" ]; then
	osascript -e 	'tell application "Reminders" to activate'
fi

reminder=$(osascript -e 'tell application "Reminders"
	set activeReminders to (reminders of list "任务" whose completed is true)
	set numOfActiveReminders to (count of activeReminders)
	set allReminders to (reminders of list "任务")
	set numOfAllReminders to (count of allReminders)
	set result to ((numOfActiveReminders as string) & "/" & numOfAllReminders as string)
	return result
end tell')

# check icon
image=iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAACXBIWXMAABYlAAAWJQFJUiTwAAABWWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS40LjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyI+CiAgICAgICAgIDx0aWZmOk9yaWVudGF0aW9uPjE8L3RpZmY6T3JpZW50YXRpb24+CiAgICAgIDwvcmRmOkRlc2NyaXB0aW9uPgogICA8L3JkZjpSREY+CjwveDp4bXBtZXRhPgpMwidZAAADHklEQVRIDbWWvWsUURTFN35iExXsFGtjoSgY+0WMtWAKsbARJVoJFv4TgmAQLIMI1hZ+FFpHIYIKiqmUpFHBYOn37zc7Z/I2u2a2MAfOzp377r3nvfvezOxYZxBjuLbAH/XQONcp2IUH4D64E4oVuAzfwafwMfwGxVb4E/7xJrB4Ce83wV9wG7wCz0GTX8J5+BZ+gWIPnIDH4RHoJO/CW/A73Ax/wz5R7isoJMUktPgbOAN3wTYYY6w55lpDlHV7Hn6zMh3T8BOchTtgYKIrtd0l9WWimFWOudawlnC86aaGSxcGfIUXvamxnasCbTDG2MAa1oqoGpWoMxST0FlFzMGMYY4MRbNia1nT2qKp5wGx77ZCKDbKqqrg4idCuqrVcLWmtdVocBXLzc6eNTNpItqNbIuR5qeGNa2tRgWfswU407vt24fa1Xopu3GH6At1RhZgbTXU6pyBziBHv0x2vA3lym4S/BEerJPSRmuroVbnNpzTAOUe9Dzr/xqfnOvYHpBDdUomnvE5/Gp1nsHLGiB913bTm6OsYw3Kg3WesRV4oo4p68RWQ63OIuxqgLWz6nlXn9PcK5ZCp7AV8xUorJETmnuvarzXWNuGBDvbswbUiIC3sY9if4bXdALbJ0tkEbZarQHBJDhzX9I3DKqhkA+22A8/wHK8PEDGiAHB9Vp6jATHH8HdMBjHeAXvxcE1hQtXZcZvSxddzRKcqIZWe+8nxbEX0NeS9nN4GIoH0Pak5a7cb98wZIvUWLKQH0+/Z8LvYKCoz5Ev4JPwIbwPX0OLnIZCMb+D/0JqqqFW64OfA2LsJfgEun+iHOt5+n/Tzr4H3/1YgDN1bA5FmZrE0md32pBa1lZDrQq+WNte3gpkP0YRy+p9n/a9vFV0r+bhrDfAwsNWpX/Y0TenhLmZnDWtrUaFzOR/fYCtF7GhH+By1tMEb/hfDJepaPZFUZ8xW2H/A8edve0qqS+5mO1/ogwSJiXR9tp3N9sT5rFugzHGmmOuNURZt+l1b2h1pRv2RzibG0Gv+mxZ3h4+O1OwC/2rvxdmxSvYy3Dkv/p/ATQejPjjKGMzAAAAAElFTkSuQmCC

echo "$reminder | length=30 bash='$0' param1='open' terminal=false refresh=true templateImage=$image"
```

我将未完成的任务和所有任务做个计数，显示在 menubar，然后点击它就可以打开 Reminder。
![](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190517155648.png)

![](https://raw.githubusercontent.com/fakeYanss/imgplace/master/2019/20190517155805.png)
这样，每天只用维护自己的 Reminder 的任务列表就行了。如果很多天过去，任务总数太多，可以再创建一个 Archive 提醒列表，将过去完成的任务都移动到里面。

快乐的写 TODO 吧！



<br>

---

<p id="div-border-left-red"><i>DigitalOcean 优惠码，注册充值 $5 送 $100，[链接一](https://m.do.co/c/282d5e1cf06e) [链接二](https://m.do.co/c/5eefb87c26cd)</i></span>
<p id="div-border-left-red"><i>Lastly, welcome to follow me on [github](https://github.com/fakeYanss)</i></p>