var spawn = require('child_process').exec;
hexo.on('new', function(data){
    var os = require('os');
    if (os.platform() == 'win32') {
        //window
        spawn('start  "D:/Application/Sublime Text 3/sublime_text.exe" ' + data.path);
    } else {
        //mac, usually is darwin
        spawn('start  "/Applications/Typora.app" ' + data.path);
    }
});
