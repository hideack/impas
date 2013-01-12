// Put your application scripts here
$(document).ready(function() {
    $('#addGroup').click(function(n){
        opKey = $('#opKey').html();
        newName = $(this).prev().val();

        $.ajax({
            type: 'POST',
            url: '/api/group/' + opKey,
            contentType: 'application/json',
            data: JSON.stringify({ "name": newName}),
            success: function(data){
                location.href = "/user";
            },
            error: function(){
                alert("グループの登録に失敗しました");
            }
        });
    });
});

