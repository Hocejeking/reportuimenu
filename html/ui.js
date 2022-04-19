let isAdmin;
$(function (){
    function display(bool){
        if(bool){
            $("#cont").show();
            if(isAdmin == true){
                $("#adminButton").show();
                $("#admins").show();
            }
            else
            {
                $("#adminButton").hide();
            }
        }
        else
        {
            $("#cont").hide();
            $("#adminui").hide();
        }
    }
    display(false)
    
    window.addEventListener('message',function(event)
    {
        var item = event.data;
        if(item.type == "ui")
        {
            if(item.status == true)
            {
                isAdmin = item.isAdmin
                display(true)
            }
            else
            {
                display(false)
            }
        }
    })
    document.onkeyup = function(data){
        if(data.key == 27){
            $.post("https://reportuimenu/exit",JSON.stringify({
                exitReason: "exited after user input"
            }));
            return;
        }
    }
    $("#closeAdmin").click(function(){
        $.post("https://reportuimenu/exit",JSON.stringify({
            exitReason: "exited after admin button click event"
        }));
        return;
    })
    $("#close").click(function(){
        $.post("https://reportuimenu/exit",JSON.stringify({
            exitReason: "exited after button click event"
        }));
        return;
    })
    $("#admins").click(function(){
        $("#adminui").show();
        $("#cont").hide();
        $.post("https://reportuimenu/adminMenuOpened",JSON.stringify({
                exitReason: "Admin menu opened"
            }))
            return
    })
    $("#submit").click(function(){
        let inputValue = $("#input").val()
        let reportType = $("input[type='radio'][name='radio-group']:checked").val();
        if(inputValue.length >= 100)
        {
            $.post("https://reportuimenu/error",JSON.stringify({
                error: "Input was too big"
            }))
            return
        }
        else if (!inputValue)
        {
            $.post("https://reportuimenu/error",JSON.stringify({
                error: "Write something first!"
            }))
            return
        }
        if(reportType == "report")
        {
            $.post("https://reportuimenu/report", JSON.stringify({
            text: inputValue,
            type: reportType
            }));
            return;
        }
        else if (reportType == "q")
        {
            $.post("https://reportuimenu/report", JSON.stringify({
            text: inputValue,
            type: reportType
            }));
            return;
        }
        else if(reportType=="bug")
        {
            $.post("https://reportuimenu/report", JSON.stringify({
                text: inputValue,
                type: reportType
                }));
                return; 
        }
        return;
    })

})

