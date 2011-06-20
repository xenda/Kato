window.fbAsyncInit = function() {
FB.Canvas.setSize();
}
// Do things that will sometimes call sizeChangeCallback()
function sizeChangeCallback() {
FB.Canvas.setSize();
}