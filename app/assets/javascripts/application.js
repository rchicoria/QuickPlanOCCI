// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require jquery-ui

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

function showAttendances()
{
  document.getElementById('attendances').style.display = 'block';
  document.getElementById("tab1").className = 'selected topround';
  document.getElementById('record').style.display = 'none';
  document.getElementById("tab2").className = 'topround';
  document.getElementById('tasks').style.display = 'none';
  document.getElementById("tab3").className = 'topround';
}

function showRecord()
{
  document.getElementById('attendances').style.display = 'none';
  document.getElementById("tab1").className = 'topround';
  document.getElementById('record').style.display = 'block';
  document.getElementById("tab2").className = 'selected topround';
  document.getElementById('tasks').style.display = 'none';
  document.getElementById("tab3").className = 'topround';
}

function add_new_text_field(field)
{
  if($(field).val() == "")
  {
    $('hidden_button').click();  
  }
}
