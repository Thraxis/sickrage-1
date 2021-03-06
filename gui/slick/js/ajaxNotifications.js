var message_url = srRoot + '/ui/get_messages',
    test = !1;

var icon_url = srRoot + '/images/ico/favicon-120.png'

PNotify.prototype.options.addclass = 'stack-bottomright';
PNotify.prototype.options.buttons.closer_hover = !1;
PNotify.prototype.options.delay = 5000;
PNotify.prototype.options.desktop = {desktop: !0, icon: icon_url};
PNotify.prototype.options.hide = !0;
PNotify.prototype.options.history = !1;
PNotify.prototype.options.shadow = !1;
PNotify.prototype.options.stack = {dir1: 'up', dir2: 'left', firstpos1: 25, firstpos2: 25};
PNotify.prototype.options.styling = 'jqueryui';
PNotify.prototype.options.width = '340px';
PNotify.desktop.permission();

function displayPNotify(type, title, message) {
    var notification = new PNotify({
        type: type, title: title,
        text: message.replace(/<br[\s\/]*(?:\s[^>]*)?>/ig, "\n")
            .replace(/<[\/]?b(?:\s[^>]*)?>/ig, '*')
            .replace(/<i(?:\s[^>]*)?>/ig, '[').replace(/<[\/]i>/ig, ']')
            .replace(/<(?:[\/]?ul|\/li)(?:\s[^>]*)?>/ig, '').replace(/<li(?:\s[^>]*)?>/ig, "\n" + '* ')
    });
}

function check_notifications() {
    if ('visible' == document.visibilityState) {
        $.getJSON(message_url, function (data) {
            $.each(data, function (name, data) {
                displayPNotify(data.type, data.title, data.message);
            });
        });
    }
    setTimeout(function () {
        "use strict";
        check_notifications();
    }, 3000);
}

$(document).ready(function(){
    check_notifications();
    if(test) displayPNotify('notice', 'test', 'test<br><i class="test-class">hello <b>world</b></i><ul><li>item 1</li><li>item 2</li></ul>');
});
