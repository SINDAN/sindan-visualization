import { TempusDominus } from '@eonasdan/tempus-dominus';

$(function () {
    var datetime_format = 'yyyy/MM/dd HH:mm'

    new TempusDominus(document.getElementById('datetime_from_group'), {
        localization: {
	    format: datetime_format
	},
	promptTimeOnDateChange: true
    });

    new TempusDominus(document.getElementById('datetime_to_group'), {
        localization: {
	    format: datetime_format
	},
	promptTimeOnDateChange: true
    });
});
