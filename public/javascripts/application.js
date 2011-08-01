Cufon.replace('h1,h2,h3'); // Works without a selector engine

$(function(){

  // var $container = $('#messages_list');
  // $container.imagesLoaded(function(){
  //   $container.masonry({
  //     itemSelector : '.message',
  //     isAnimated : true
  //   });
  // });

// window.fbAsyncInit = function() {
//   FB.Canvas.setSize();
// }

// // Do things that will sometimes call sizeChangeCallback()

// function sizeChangeCallback() {
//   FB.Canvas.setSize();
// }


$("li.message").tipsy({gravity: 's', fade:true});

  // Enable pusher logging - don't include this in production
  Pusher.log = function(message) {
    if (window.console && window.console.log) window.console.log(message);
  };

  // Flash fallback logging - don't include this in production
  WEB_SOCKET_DEBUG = true;

  var pusher = new Pusher('e5e83dab1c59e257be10');
  var channel = pusher.subscribe('alpha-skunk');
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

function streamPublish(name, caption, link, description,picture){
    FB.ui({ method  : 'feed',
            name    : name,
            link    :  link,
            picture : picture,
            caption : caption,
            description: description

          });
        //http://developers.facebook.com/docs/reference/dialogs/feed/
}
function publishStream(){
    streamPublish("Stream Publish", 'Thinkdiff.net is simply awesome.','http://wp.me/pr3EW-sv', ' I just learned how to develop Iframe+Jquery+Ajax base facebook application development using php sdk 3.0. ', 'Checkout the Tutorial');
}
