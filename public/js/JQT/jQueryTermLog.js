var logTerm = $('.terminal_logger').terminal(function(command, term) {    
    if (command == '') {
        //do nothing
    }
    else {
        term.error("unknown command.");
    }
},
    {
        name: 'logger',
        greetings: '--Logger--',
        keydown: function(e) {
            return false;
        }
    }
);

logTerm.set_prompt('');
logTerm.focus(false);

$('.terminal_main').terminal().focus();