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
      // Enable pusher logging - don't include this in production
      Pusher.log = function(message) {
        if (window.console && window.console.log) window.console.log(message);
      };

      // Flash fallback logging - don't include this in production
      WEB_SOCKET_DEBUG = true;

      var pusher = new Pusher('e5e83dab1c59e257be10');
      var channel = pusher.subscribe('alpha-kato');
      channel.bind('message:create', function(data) {
        addNewMessage(data);
      });
      channel.bind('vote:create', function(data) {
        updateVotesCount(data);
      });
        



      
    
    
    
    
});

function addNewMessage(data){
  
  var token = $('meta[name="csrf-token"]').attr('content')
  
  $("#messages_list").prepend('<li id=\"message_' + data['id'] +'\" class=\"message masonry-brick\" style=\"position: absolute;
top: 10px; left: 10px;\"> <h4>' + data['title'] +'</h4> <div class=\"content\">'+ data['content']
+'</div> <div class=\"meta_data\"> <div class=\"avatar\"></div> <div class=\"name\"></div> <div
class=\"votes\"> <div class=\"vote_count\">' + data['votes_count']+ ' votos </div> <div
class=\"submit\"> <form method=\"post\" id=\"new_vote\" data-remote=\"true\" class=\"simple_form
vote\" action=\"/votes\" accept-charset=\"UTF-8\"><div style=\"&lt;a
href=\'margin:0;padding:0;display:inline\' class=\'oembed hidden media\'
id=\'oembed_media_503\'&gt;margin:0;padding:0;display:inline&lt;/a&gt;\"><input type=\"hidden\"
value=\"✓\" name=\"utf8\"><input type=\"hidden\" value=\"' + token +'\"
name=\"authenticity_token\"></div> <input type=\"hidden\" value=\"' + data['id'] +'\"
name=\"vote[message_id]\" id=\"vote_message_id\" class=\"hidden\"> <input type=\"submit\"
value=\"Votar\" name=\"commit\" id=\"vote_submit\" class=\"button\"> </form> </div> </div> </div>
</li>');
}

function updateVotesCount(data){
  
  var token = $('meta[name="csrf-token"]').attr('content')
  
  $('#message_' + data['message_id'] + ' .votes').html('<div class=\'vote_count\'>\n'+ data['votes_count'] +  '\nvotos\n<\/div>\n<div class=\'submit\'>\n<form accept-charset=\"UTF-8\" action=\"/votes\" class=\"simple_form vote\" data-remote=\"true\" id=\"new_vote\" method=\"post\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /><input name=\"authenticity_token\" type=\"hidden\" value=\"' + token +'\" /><\/div>\n<input class=\"hidden\" id=\"vote_message_id\" name=\"vote[message_id]\" type=\"hidden\" value=\"'+ data['message_id'] + '\" />\n<input class=\"button\" id=\"vote_submit\" name=\"commit\" type=\"submit\" value=\"Votar\" />\n<\/form>\n<\/div>\n');
  
}
