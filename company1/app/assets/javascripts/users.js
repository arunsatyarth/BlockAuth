$(document).on("click","#signinbtn1",function(e){
	  $.ajax({
             url: '/signinform', //your server side script
             data: {  }, //our data
              dataType:"script",
             type: 'POST'
         });
});
global_uuid=null;
$(document).on("click","#actual_signin",function(e){

});