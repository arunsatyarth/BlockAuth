$(document).on("click","#signinbtn1",function(e){
	$("#signinarea").removeClass("hide")
	  $.ajax({
             url: '/signinform', //your server side script
             data: {  }, //our data
              dataType:"script",
             type: 'POST'
         });
});
global_uuid=null;
$(document).on("click","#actual_signin",function(e){

	$('#signinarea').html($('#waitgif').html());

	App.login();
});