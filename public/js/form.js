var plWordsForm = {
    instrument: function(){
        $('#submitButton').click(plWordsForm.submit);
        $('#noThanksButton, #cloudsButton').click(function(){
          window.location = "/languages/" + encodeURIComponent($("#languageInput").attr("value"));
          return false;
        });
        $('#contributeButton').click(function(){
          window.location = "/contribute";
          return false;
        });
        return false;
    },
    init: function(){
        $("#languageInput").css("border", "solid 1px #BBBBBB");
        $("#feelingInput").css("border", "solid 1px #BBBBBB");
        $("#recaptchaInput").css("border", "none");
        return false;
    },
    onSuccess: function(data){
        $("#thankYouModal").modal('show');
        return false;
    },
    onValidationError: function(data){
        var fields = jQuery.parseJSON(data.responseText);
        var scrolled = false;
        $.each(fields, function(index, field){
            var elm = $("#" + field + "Input");
            if (elm){
                elm.css("border","solid 2px #FF0000");
                if (!scrolled){
                    $("html,body").animate({ scrollTop: elm.position().top-100 }, "slow");
                    scrolled = true;
                }
            }
        });
        return false;
    },
    onError: function(data){
        $("form").html("Sorry an error occured, please try again later!");
        return false;
    },
    submit: function(){
        plWordsForm.init();
        $.ajax({
            type: 'POST',
            url: '/submissions',
            data: $("#submissionForm").serialize(),
            dataType: 'json',
            success: plWordsForm.onSuccess,
            statusCode: {
                400: plWordsForm.onValidationError,
                500: plWordsForm.onError
            }
        });
        return false;
    }
}