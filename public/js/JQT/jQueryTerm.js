var mainTerm = '';

jQuery(function($) {
    $.loadScript('./js/JQT/jQueryTermLog.js', function(){});
    $.loadScript('./js/JQT/extras.js', function(){});

    mainTerm = $('.terminal_main').terminal(function(command, term) {        
        ga('send', 'event', 'Commands', 'enter', command);

        if (command == '') {
            //do nothing
        }
        else if (command == 'hi' || command == 'hello') {
            logTerm.echo(timeStamp() + " - getting hello message...");
            term.echo("Hello! It's nice to finally talk to someone. They don't let me out much :)")
        }
        else if (command == 'help') {
            logTerm.echo(timeStamp() + " - help tried...");
            term.echo("Ah ah ah, you didn't say the magic word :(");
        }
        else if (command == 'please') {
            logTerm.echo(timeStamp() + " - please initiated...");
            term.echo("Please what?");
        }
        else if (command == 'help please' || command == 'please help') {
            logTerm.echo(timeStamp() + " - getting help menu...");
            term.echo("ok. ok. i'll help you. below are a list of commands you can try. go team venture.\n\n" +
                    "js: You will enter javascript mode. Kewl.\n"+
                    "flip: flip the screen! neat CSS stuff.\n"+
                    "peoplefinder: Find. People. Destroy.\n"+
                    "github: takes you to my github page. Not much to see but it'll kill 5 mins.\n"+
                    "progressBar: progress bar example in JS.\n"+
                    "airhorn: check out the Alexa AirHorn skill world rankings.\n"+
                    "\nthat's all for now. come back later for more!");
        }
        else if (command == 'ls' || command == 'dir') {
            logTerm.echo(timeStamp() + " - no directory found.");
            term.echo('no directory found')
        }
        else if (command == 'airhorn') {
            window.location.href = '/airhorn';
        }
        else if (command == 'progressBar') {
            progressBar(50);
        }
        else if (command == 'github') {
            window.location.href = 'http://github.com/bspeagle';
        }
        else if (command == 'mellon') {
            window.location.replace("/home");
        }
        else if (command == 'peoplefinder') {
            window.location = "/peoplefinder";
        }
        else if (command == 'flip' || command == 'clear') {
            logTerm.echo(timeStamp() + " - flipping main screen now...");
            
            $('.terminal_main_master').addClass('animated flip');

            //mainTerm.clear();

            setTimeout(function(){
                $('.terminal_main_master').removeClass('animated flip');
            }, 1000);
        }

        else if (command == "js") {
            logTerm.echo(timeStamp() + " - entering JS console...");
            term.echo('js interface accessed.');

            term.push(function(command, term) {
                ga('send', 'event', 'Commands', 'JS enter', command);

                if (command !== '') {
                    if (command == 'help') {
                        logTerm.echo(timeStamp() + " - getting JS help...");
                        term.echo("it's javascript. google it!");
                    }
                    else {
                        try {
                            var result = window.eval(command);
                            if (result !== undefined) {
                                logTerm.echo(timeStamp() + " - " + command);
                                term.echo(new String(result));
                            }
                        }
                        catch(e) {
                            term.error(new String(e));
                        }
                    }
                }
                else {
                    term.echo('');
                }
            },
            {
                name: 'js',
                greetings: 'javascript time!',
                prompt: 'js> '
            }
            );
        }
        else {
            term.error("unknown command.");
        }
    },
        {
            name: 'mainTerm',
            greetings: 'Welcome.',
            prompt: '> ',
            exit: true
        }
    );
});