//= require_self

var width = $('#main').width() - 127;
var height = $('#main').height() - 111;

function run() {
    var top = Math.random() * height;
    var left = Math.random() * width;
    $('#add').css('top', top + 'px').css('left', left + 'px');
}

$(document).ready(function() {
    $('#add').mouseover(run);
    $('#add').mousemove(run);
});
