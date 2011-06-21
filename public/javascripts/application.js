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
      itemSelector : '.message',
      isAnimated : true
    });
  });


  $(".message").each(function(value){ 

  // Capture each comment text
  text = $(this).html();

    	// We match the URL pattern
    	regMatches = (text.match(/\b((?:[a-z][\w-]+:(?:\/{1,3}|[a-z0-9%])|www\d{0,3}[.])(?:[^\s()<>]+|\([^\s()<>]+\))+(?:\([^\s()<>]+\)|[^`!()\[\]{};:'".,<>?«»“”‘’\s]))/gi));
        if (regMatches) {
    	// We iterate from each matches
    	$.each(regMatches, function(index,value){
        	reg_value = value.replace("?","\\?")
        	var re = new RegExp("\\s*"+reg_value+"\\s*","gim");
        	//console.debug(re);
        	randId = Math.floor(Math.random()*1000);
        	mediaId = "oembed_media_" + randId;
        	text = text.replace(re,"<a href='"+ value +"' class='oembed hidden media' id='"+mediaId+"'>"+value+"</a>");
    	})
    	$(this).html(text);
  	}
  });

  $(".oembed").oembed(null,
    {
      embedMethod:"append", maxWidth:"240",
      afterEmbed: function(oembedData) {
        $container.imagesLoaded(function(){
          $container.masonry( 'reload' );})
    }
    });
});

