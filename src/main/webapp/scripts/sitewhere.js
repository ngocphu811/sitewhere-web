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