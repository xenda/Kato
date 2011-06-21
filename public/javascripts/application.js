  window.fbAsyncInit = function() {
  FB.Canvas.setSize();
  }
// Do things that will sometimes call sizeChangeCallback()
function sizeChangeCallback() {
  FB.Canvas.setSize();

}




$(function(){

  var $container = $('#messages_list');
  $container.imagesLoaded(function(){
    $container.masonry({
      itemSelector : '.message'
    });
  });


});

