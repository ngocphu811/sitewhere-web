/** Value that indicates a MapQuest map type */
var MAP_TYPE_MAPQUEST = "mapquest";

/** Value that indicates a GeoServer map type */
var MAP_TYPE_GEOSERVER = "geoserver";

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

/** Converts fields that need to be parsed in a zone */
function parseZoneData(item) {
    if (item.createdDate && typeof item.createdDate === "string") {
    	item.createdDate = kendo.parseDate(item.createdDate);
    }
    if (item.updatedDate && typeof item.updatedDate === "string") {
    	item.updatedDate = kendo.parseDate(item.updatedDate);
    }
}

/** Converts sitewhere metadata format into a lookup */
function swMetadataAsLookup(metadata) {
	var lookup = {};
	for (var i = 0, len = metadata.length; i < len; i++) {
	    lookup[metadata[i].name] = metadata[i].value;
	}
	return lookup;
}

/** Initializes a map based on site map metadata */
function swInitMapForSite(map, site) {
	var lookup = swMetadataAsLookup(site.mapMetadata.metadata);
	var latitude = (lookup.centerLatitude ? lookup.centerLatitude : 39.9853);
	var longitude = (lookup.centerLongitude ? lookup.centerLongitude : -104.6688);
	var zoomLevel = (lookup.zoomLevel ? lookup.zoomLevel : 10);
	var map = map.setView([latitude, longitude], zoomLevel);
	if (site.mapType === MAP_TYPE_MAPQUEST) {
		var mapquestUrl = 'http://{s}.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png';
		var subDomains = ['otile1','otile2','otile3','otile4'];
		var mapquestAttrib = 'MapQuest data';
		var mapquest = new L.TileLayer(mapquestUrl, {maxZoom: 18, attribution: mapquestAttrib, subdomains: subDomains});		
		mapquest.addTo(map);
	} else if (site.mapType == MAP_TYPE_GEOSERVER) {
		var gsBaseUrl = (lookup.geoserverBaseUrl ? lookup.geoserverBaseUrl : "http://localhost:8080/geoserver/");
		var gsRelativeUrl = "geoserver/gwc/service/gmaps?layers=";
		var gsLayerName = (lookup.geoserverLayerName ? lookup.geoserverLayerName : "tiger:tiger_roads");
		var gsParams = "&zoom={z}&x={x}&y={y}&format=image/png";
		var gsUrl = gsBaseUrl + gsRelativeUrl + gsLayerName + gsParams;
		var geoserver = new L.TileLayer(gsUrl, {maxZoom: 18});		
		geoserver.addTo(map);
	}
	return map;
}

/** Enables drawing features on map */
function swEnableMapDrawing(map, borderColor, fillColor, fillAlpha) {
	var options = {
			position: 'topright',
			draw: {
		        polyline: false,
		        circle: false,
		        marker: false,
		        polygon: {
        	        shapeOptions: {
        	        	color: borderColor,
        	            fillColor: fillColor,
        	            fillOpacity: fillAlpha
        	        }
		        },
		        rectangle: {
        	        shapeOptions: {
        	        	color: borderColor,
        	            fillColor: fillColor,
        	            fillOpacity: fillAlpha
        	        }
		        }
		    },
		    edit: false
	};

	var drawControl = new L.Control.Draw(options);
	map.addControl(drawControl);
	return drawControl;
}