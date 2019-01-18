$.loadScript('./js/JQT/jQueryTermLog.js', function(){});

var animation = false;
var timer;
var prompt;
var string;

function timeStamp() {
    var dt = new Date();
    return dt.toUTCString();
}

function progress(percent, width) {
    var size = Math.round(width*percent/100);
    var left = '', taken = '', i;
    
    for (i=size; i--;) {
        taken += '=';
    }    
    if (taken.length > 0) {
        taken = taken.replace(/=$/, '>');
    }    
    for (i=width-size; i--;) {
        left += ' ';
    }    
    return '[' + taken + left + '] ' + percent + '%';
}

function progressBar(size, callback) {
    logTerm.echo(timeStamp() + " - Initiating progress bar...");            
    var i = 0;
    prompt = mainTerm.get_prompt();
    string = progress(0, size);
    mainTerm.set_prompt(progress);
    animation = true;

    (function loop() {
        string = progress(i++, size);
        mainTerm.set_prompt(string);
        
        if (i < 100) {
            timer = setTimeout(loop, 30);
        }
        else {
            logTerm.echo(timeStamp() + " - progress bar done.");
            mainTerm.echo(progress(i, size) + ' [[b;green;]OK]').set_prompt(prompt);
            animation = false;
            callback();
        }
    })();
}

function typeWriter(txt2type, speed) {
    var i = 0;
    if (i < txt2type.length) {
        document.getElementById("demo").innerHTML += txt2type.charAt(i);
        i++;
        setTimeout(typeWriter(txt2type, speed), speed);
    }
}