$(document).ready(function(){
  $('#submitButton').click(function(){
      $("#languageInput").css("border", "solid 1px #AAAAAA");
      $("#wordsInput").css("border", "solid 1px #AAAAAA");
      $.ajax({
          type: 'POST',
          url: '/words',
          data: $("#wordsForm").serialize(),
          success: function(){
              $("form").html("<h1>Thank you!!</h1>");
          },
          statusCode: {
              400: function(data){
                  $("#" + data.responseText + "Input").css("border","solid 2px #FF0000");
                  $("#" + data.responseText + "Input").focus();
                  return false;
              },
              500: function(){
                  $("#feedback").html("Sorry an error occured, please try again later!");
                  return false;
              }
          }
      });      
      return false;
  });
});
