$(document).on("click","#editdetails2",function(e){
     var create_account_div = $("#create_account_div");
    var account_details_div = $("#account_details_div");

    create_account_div.show();
    account_details_div.hide();
    e.preventDefault();
});