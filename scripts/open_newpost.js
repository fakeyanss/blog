var spawn = require('child_process').exec;
hexo.on('new', function(data){
  spawn('start  "/Applications/Typora.app" ' + data.path);
});