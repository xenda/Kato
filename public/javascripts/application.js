Cufon.replace('h1,h2,h3'); // Works without a selector engine

function openWindow(url, name, width, height){
	centerWidth = (window.screen.width - width)/2;
	centerHeight = (window.screen.height - height)/2;

	newWindow = window.open(url, name, 'resize=no,toolbar=no,width=' + width +
    ',height=' + height +
    ',left=' + centerWidth +
    ',top=' + centerHeight);

	newWindow.focus();
	return newWindow.name;
}

$(function(){

  $('#contest_logo a').click(function(event){
    event.preventDefault();
    window.location = '/';
  });

  $('.disabled').click(function(e){
    e.preventDefault();
  });

  $('a.remove_message').live('click', function(event){
    event.preventDefault();
    $(this).parent().remove();

    rename_inputs();
  });

  $('a#new_message').live('click', function(event){
    event.preventDefault();
    var index = $('#ingredients .input_collection').length;
    $('#ingredients a#new_message').remove();
    $('#ingredients .input_collection').last().append('<a class="remove_message" href="#">-</a>');
    $('#ingredients').append('<div class="input_collection"><div class="input string optional"><input class="string optional" id="message_ingredients_attributes_'+index+'_quantity" maxlength="255" name="message[ingredients_attributes]['+index+'][quantity]" placeholder="#" size="3" type="text"></div><div class="input string optional"><input class="string optional" id="message_ingredients_attributes_'+index+'_ingredient_type" maxlength="255" name="message[ingredients_attributes]['+index+'][ingredient_type]" placeholder="Tipo" size="14" type="text"></div><div class="input string optional"><input class="string optional" id="message_ingredients_attributes_'+index+'_product" maxlength="255" name="message[ingredients_attributes]['+index+'][product]" placeholder="Ingrediente" size="28" type="text"></div><a href="#" id="new_message">+</a></div>');

    rename_inputs();
  });

  function rename_inputs(){
    $('#ingredients .input_collection').each(function(index, item){
      var inputs = $(item).find('.input input');
      $(inputs[0]).attr({'id':'message_ingredients_attributes_'+index+'_quantity', 'name':'message[ingredients_attributes]['+index+'][quantity]'});
      $(inputs[1]).attr({'id':'message_ingredients_attributes_'+index+'_ingredient_type', 'name':'message[ingredients_attributes]['+index+'][ingredient_type]'});
      $(inputs[2]).attr({'id':'message_ingredients_attributes_'+index+'_product', 'name':'message[ingredients_attributes]['+index+'][product]'});
    });
  }

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

$('a.twitter_icon').click(function(event){
  event.preventDefault();
  openWindow($(this).attr('href'), 'social', 550, 300);
});

$('a.facebook_icon').click(function(event){
  event.preventDefault();
  streamPublish('Concurso Más bueno que el Pan', $(this).parent().parent().find('.title').attr('rel'), $(this).attr('href'), '', '');
  //$('.fb_dialog').css({'top':'82.5px', 'left':'116.5px'});
  //$('.fb_dialog').first().remove();
});

$('li.message.longer').each(function(index,item){
  $(item).append('<div class="tooltip" title="" id="tooltip_' + $(item).attr('id') + '"><div class="content" title="">' + $(item).attr('title') + '</div><div class="arrow" title=""></div></div>');
  $(item).attr('title',""); //  = "";
});

$('li.message .tooltip').each(function(index, item){
  var top = (173-$(item).height())/2;
  var left = (155-$(item).width())/2;
  $(item).css({'top':top+'px', 'left': left+'px'});
});

$('li.message').mouseenter(function(){
//  var id = '#tooltip_' + $(this).attr('id');
    $(this).find('.tooltip').fadeIn('fast');
}).mouseleave(function(){
//  var id = '#tooltip_' + $(this).attr('id');
    $(this).find('.tooltip').fadeOut('fast');
});

//$("li.message").tipsy({gravity: 's', fade:true});

  // Enable pusher logging - don't include this in production

  // Pusher.log = function(message) {
  //   if (window.console && window.console.log) window.console.log(message);
  // };

  // // Flash fallback logging - don't include this in production
  // WEB_SOCKET_DEBUG = true;

  // var pusher = new Pusher('e5e83dab1c59e257be10');
  // var channel = pusher.subscribe('alpha-skunk');
  // channel.bind('message:create', function(data) {
  //   addNewMessage(data);
  // });
  // channel.bind('vote:create', function(data) {
  //   updateVotesCount(data);
  // });

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
var scroll = $(window).scrollTop();
function streamPublish(name, caption, link, description, picture){
    FB.ui({ method  : 'feed',
            app_id  : 136578643087393,
            name    : name,
            link    :  link,
            picture : picture,
            caption : caption,
            description: description,
            display : 'iframe',
            access_token: fb_token
          }, function(response){
            $(window).scrollTop(scroll);
            console.log($('.fb_dialog'));
          });
        //http://developers.facebook.com/docs/reference/dialogs/feed/
}
function publishStream(){
    streamPublish("Stream Publish", 'Thinkdiff.net is simply awesome.','http://wp.me/pr3EW-sv', ' I just learned how to develop Iframe+Jquery+Ajax base facebook application development using php sdk 3.0. ', 'Checkout the Tutorial');
}
