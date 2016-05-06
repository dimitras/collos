// jQuery(function($) {
//   // when the #container field changes
//   $("#sample_institution_id").change(function() {
//     // make a POST call and replace the content
//     var institution = $('select#sample_institution_id :selected').val();
//     if(institution == "") institution="0";
//     jQuery.get('/samples/update_laboratoty_select/' + institution, function(data){
//         $("#addressLaboratories").html(data);
//     })
//     return false;
//   });

// })

// jQuery.ajaxSetup({
//   'beforeSend': function(xhr) { xhr.setRequestHeader("Accept", "text/javascript") }
// });

// $.fn.subSelectWithAjax = function() {
//   var that = this;

//   this.change(function() {
//     $.post(that.attr('rel'), {id: that.val()}, null, "script");
//   });
// }

// $("#widget_category").subSelectWithAjax();