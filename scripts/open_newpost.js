var spawn = require('child_process').exec;
hexo.on('new', function(data){
  spawn('start  "D:\Application\Typora\Typora.exe" ' + data.path);
});