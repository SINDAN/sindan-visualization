import "eonasdan-bootstrap-datetimepicker";

$(function () {
    var datetime_format = 'YYYY-MM-DDTHH:mm:ssZ'

    $('#datetime_from').datetimepicker({
        format: datetime_format
    });

    $('#datetime_to').datetimepicker({
        format: datetime_format
    });
});
