$(function() {
    jQuery.loadScript = function (url, callback) {
        jQuery.ajax({
            url: url,
            dataType: 'script',
            success: callback,
            async: true
        });
    }
    
    $.loadScript('./js/loader.js', function(){});
});