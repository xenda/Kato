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
  // var data = [];
  // data['id']  = "lala";
  $("#messages_list").prepend('<li class="message" id="message_'+ data["id"] +'"><h4><a href="/messages/'+data["id"]+'">'+ data["title"]+'</a></h4><div class="content">'+ data["content"] +'</div><div class="meta_data"> <div class="avatar"></div> <div class="name"></div> <div class="votes"><div class="vote_count"> '+ data["votes_count"]+' votos</div> <div class="submit"> <form accept-charset="UTF-8" action="/votes" class="simple_form vote" data-remote="true"   id="new_vote" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="✓"><input name="authenticity_token" type="hidden" value="'+ token +'"></div> <input class="hidden" id="vote_message_id" name="vote[message_id]" type="hidden" value="'+ data["id"]+'"> <input class="button" id="vote_submit" name="commit" type="submit" value="Votar"> </form> </div> </div> </div> </li>');

  var $container = $('#messages_list');
  $container.imagesLoaded(function(){
    $container.masonry( 'reload' );
  })

}

function updateVotesCount(data){
  
  var token = $('meta[name="csrf-token"]').attr('content')
  
  $('#message_' + data['message_id'] + ' .votes').html('<div class=\'vote_count\'>\n'+ data['votes_count'] +  '\nvotos\n<\/div>\n<div class=\'submit\'>\n<form accept-charset=\"UTF-8\" action=\"/votes\" class=\"simple_form vote\" data-remote=\"true\" id=\"new_vote\" method=\"post\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /><input name=\"authenticity_token\" type=\"hidden\" value=\"' + token +'\" /><\/div>\n<input class=\"hidden\" id=\"vote_message_id\" name=\"vote[message_id]\" type=\"hidden\" value=\"'+ data['message_id'] + '\" />\n<input class=\"button\" id=\"vote_submit\" name=\"commit\" type=\"submit\" value=\"Votar\" />\n<\/form>\n<\/div>\n');
 
  $("#message_" + data['message_id']).effect("shake", { distance: 3, times: 5}, 100).effect("highlight", {}, 1000);   
}

function streamPublish(name, caption, link, description){        
    FB.ui({ method : 'feed', 
            name: name,
            caption: caption,
            link   :  link,
            description: description
          });
        //http://developers.facebook.com/docs/reference/dialogs/feed/
}
function publishStream(){
    streamPublish("Stream Publish", 'Thinkdiff.net is simply awesome.','http://wp.me/pr3EW-sv', ' I just learned how to develop Iframe+Jquery+Ajax base facebook application development using php sdk 3.0. ', 'Checkout the Tutorial');
}