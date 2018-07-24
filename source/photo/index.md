---
title:
date: 2017-12-29 22:32:22
type: "photos"
comments: false
---
<link rel="stylesheet" href="./ins.css">
<link rel="stylesheet" href="./photoswipe.css">
<link rel="stylesheet" href="./default-skin/default-skin.css">
<div class="photos-btn-wrap">
  <a class="photos-btn active" id="photoA" href="javascript:void(0)" onclick="setActive('photo')" style="border-bottom:1px #999">Photo</a><a class="photos-btn" id="gameA" href="javascript:void(0)" onclick="setActive('game')" style="border-bottom:1px #999">GameRecord</a>
</div>
<div class="instagram itemscope" id="photoD">
  <a href="http://foreti.me" target="_blank" class="open-ins">图片正在加载中…</a>
</div>

<div class="instagram itemscope" id="gameD" style="display: none;">
  <a href="http://foreti.me" target="_blank" class="open-ins">图片正在加载中…</a>
</div>

<script>
(function() {
var loadScript = function(path) {
var $script = document.createElement('script')
document.getElementsByTagName('body')[0].appendChild($script)
$script.setAttribute('src', path)
}
setTimeout(function() {
loadScript('./ins.js')
}, 0)
})()
</script>
<script type="text/javascript" src="./toggle.js"></script>