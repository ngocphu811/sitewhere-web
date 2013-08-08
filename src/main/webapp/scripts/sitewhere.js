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

/** Formats metadata array into a comma-delimited string */
function formattedMetadata(metadata) {
	var result = "";
	for (var i = 0; i < metadata.length; i++) {
		if (i > 0) {
			result += ", ";
		}
		result += metadata[i].name + "=" + metadata[i].value;
	}
	return result;
}

/** Converts fields that need to be parsed in a site */
function parseSiteData(item) {
    if (item.createdDate && typeof item.createdDate === "string") {
    	item.createdDate = kendo.parseDate(item.createdDate);
    }
    if (item.updatedDate && typeof item.updatedDate === "string") {
    	item.updatedDate = kendo.parseDate(item.updatedDate);
    }
}

/** Converts fields that need to be parsed in a device */
function parseDeviceData(item){
	if (item.createdDate && typeof item.createdDate === "string") {
		item.createdDate = kendo.parseDate(item.createdDate);
	}
	if (item.updatedDate && typeof item.updatedDate === "string") {
		item.updatedDate = kendo.parseDate(item.updatedDate);
	}
	if (item.assignment) {
	    if (item.assignment.activeDate && typeof item.assignment.activeDate === "string") {
	    	item.assignment.activeDate = kendo.parseDate(item.assignment.activeDate);
	    }
	}
}

/** Converts fields that need to be parsed in an assignment */
function parseAssignmentData(item) {
    if (item.createdDate && typeof item.createdDate === "string") {
    	item.createdDate = kendo.parseDate(item.createdDate);
    }
    if (item.updatedDate && typeof item.updatedDate === "string") {
    	item.updatedDate = kendo.parseDate(item.updatedDate);
    }
    if (item.activeDate && typeof item.activeDate === "string") {
    	item.activeDate = kendo.parseDate(item.activeDate);
    }
    if (item.releasedDate && typeof item.releasedDate === "string") {
    	item.releasedDate = kendo.parseDate(item.releasedDate);
    }
}

/** Converts fields that need to be parsed in an event */
function parseEventData(item) {
    if (item.eventDate && typeof item.eventDate === "string") {
    	item.eventDate = kendo.parseDate(item.eventDate);
    }
    if (item.receivedDate && typeof item.receivedDate === "string") {
    	item.receivedDate = kendo.parseDate(item.receivedDate);
    }
}

