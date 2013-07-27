$.postJSON = function(url, data, onSuccess, onFail) {
	return jQuery.ajax({
		'type' : 'POST',
		'url' : url,
		'contentType' : 'application/json',
		'data' : JSON.stringify(data),
		'dataType' : 'json',
		'success' : onSuccess,
		'error' : onFail
	});
};

$.putJSON = function(url, data, onSuccess, onFail) {
	return jQuery.ajax({
		'type' : 'PUT',
		'url' : url,
		'contentType' : 'application/json',
		'data' : JSON.stringify(data),
		'dataType' : 'json',
		'success' : onSuccess,
		'error' : onFail
	});
};

$.getJSON = function(url, onSuccess, onFail) {
	return jQuery.ajax({
		'type' : 'GET',
		'url' : url,
		'contentType' : 'application/json',
		'success' : onSuccess,
		'error' : onFail
	});
}

$.deleteJSON = function(url, onSuccess, onFail) {
	return jQuery.ajax({
		'type' : 'DELETE',
		'url' : url,
		'contentType' : 'application/json',
		'success' : onSuccess,
		'error' : onFail
	});
}

/** Common error handler for AJAX calls */
function handleError(jqXHR, info) {
	var respError = jqXHR.getResponseHeader("X-SiteWhere-Error");
	if (respError) {
		bootbox.alert(respError);
	} else {
		bootbox.alert(info);
	}
}

// Format date if available, otherwise, show N/A
function formattedDate(date) {
	if (date) {
		return kendo.toString(date, 'g');
	}
	return "N/A";
}

