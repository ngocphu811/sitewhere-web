<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="sitewhere_title" value="Assignment Emulator" />
<c:set var="sitewhere_section" value="sites" />
<c:set var="use_map_includes" value="true" />
<c:set var="use_mqtt" value="true" />
<%@ include file="../includes/top.inc"%>

<style>
	.emulator-map {
		height: 320px; 
		margin-top: 10px; 
		border: 1px solid #cccccc;
		cursor: crosshair;
	}
</style>

<!-- Title Bar -->
<div class="sw-title-bar content k-header" style="margin-bottom: -1px;">
	<h1 class="ellipsis"><c:out value="${sitewhere_title}"/></h1>
	<div class="sw-title-bar-right">
		<a id="btn-assignment-detail" class="btn" href="detail.html?token=<c:out value="${assignment.token}"/>">
			<i class="icon-circle-arrow-left sw-button-icon"></i> Assignment Details</a>
	</div>
</div>


<!-- Tab panel -->
<div id="tabs">
	<ul>
		<li class="k-state-active">Emulator</li>
		<li>MQTT</li>
	</ul>
	<div>
		<div class="k-header sw-button-bar">
			<div class="sw-button-bar-title">Device Assignment Emulator</div>
			<div>
				<a id="btn-refresh-locations" class="btn" href="javascript:void(0)">
					<i class="icon-refresh sw-button-icon"></i> Refresh Locations</a>
				<a id="mqtt-btn-connect" class="btn btn-primary" href="javascript:void(0)">
					<i class="icon-bolt sw-button-icon"></i> Connect</a>
			</div>
		</div>
		<div id="emulator-map" class="emulator-map"></div>
	</div>
	<div>
		<div class="k-header sw-button-bar">
			<div class="sw-button-bar-title">MQTT Information</div>
			<div>
				<a id="mqtt-btn-test-connect" class="btn" href="javascript:void(0)">
					<i class="icon-bolt sw-button-icon"></i> Test Connection</a>
			</div>
		</div>
		<div>
			<div id="mqtt-tabs">
				<ul>
					<li class="k-state-active">Settings</li>
					<li>Messages</li>
				</ul>
				<div>
					<form class="form-horizontal" style="padding-top: 20px; display: inline-block; vertical-align: top">
						<div class="control-group">
							<label class="control-label" for="mqtt-host-name">MQTT Host Name</label>
							<div class="controls">
								<input type="text" id="mqtt-host-name" value="localhost"
									class="input-large" title="Host name">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="mqtt-port">MQTT Websocket Port</label>
							<div class="controls">
								<input id="mqtt-port" type="number" value="61623" min="0" step="1" class="input-large"
									title="Port" onkeyup="this.value=this.value.replace(/[^\d]/,'')"/>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="mqtt-client-id">Client ID</label>
							<div class="controls">
								<input type="text" id="mqtt-client-id" value="SiteWhereWeb"
									class="input-large">
							</div>
						</div>
					</form>
					<form class="form-horizontal" style="padding-top: 20px; display: inline-block; vertical-align: top">
						<div class="control-group">
							<label class="control-label" for="mqtt-username">Username</label>
							<div class="controls">
								<input type="text" id="mqtt-username" class="input-large" value="admin">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="mqtt-password">Password</label>
							<div class="controls">
								<input type="password" id="mqtt-password" class="input-large" value="password">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="mqtt-topic">Topic</label>
							<div class="controls">
								<input type="text" id="mqtt-topic" class="input-large" value="SiteWhere/input">
							</div>
						</div>
					</form>
				</div>
				<div>
					Messages go here.
				</div>
			</div>
		</div>
	</div>
</div>

<!-- Dialog for creating a new location -->
<div id="lc-dialog" class="modal hide">
	<div class="modal-header k-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>Create Location</h3>
	</div>
	<div class="modal-body">
		<div id="lc-tabs" style="clear: both;">
			<ul>
				<li class="k-state-active">Location</li>
				<li>Metadata</li>
			</ul>
			<div>
				<form class="form-horizontal" style="padding-top: 20px">
					<div class="control-group">
						<label class="control-label" for="lc-lat">Latitude</label>
						<div class="controls">
							<input type="number" id="lc-lat" class="input-large">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="lc-lng">Longitude</label>
						<div class="controls">
							<input type="number" id="lc-lng" class="input-large">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="lc-elevation">Elevation</label>
						<div class="controls">
							<input type="number" id="lc-elevation" class="input-large" value="0">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="lc-event-date">Event Date</label>
						<div class="controls">
							<input id="lc-event-date" class="input-large">
						</div>
					</div>
				</form>
			</div>
			<div>
				<div id="lc-metadata"></div>
            </div>
		</div>
	</div>
	<div class="modal-footer">
		<a href="javascript:void(0)" class="btn" data-dismiss="modal">Cancel</a> 
		<a id="lc-dialog-submit" href="javascript:void(0)" class="btn btn-primary">Create</a>
	</div>
</div>

<script>
	/** Assignment token */
	var token = '<c:out value="${assignment.token}"/>';
	
	/** Site token */
	var siteToken = '<c:out value="${assignment.siteToken}"/>';
	
	/** Device hardware id */
	var hardwareId = '<c:out value="${assignment.deviceHardwareId}"/>';

	/** Tab strip */
	var tabs;
	
	/** Tabs for MQTT */
	var mqttTabs;

	/** Provides external access to tabs */
	var lcTabs;
	
	/** Metadata datasource */
	var lcMetadataDS;
	
	/** Picker for event date */
	var lcDatePicker;

	/** MQTT client */
	var client;
	
	/** Indicates if client is connected */
	var connected = false;
	
	/** Emulator map */
	var map;
	
	/** Indicates if we are testing the connection */
	var testingConnection = false;
	
	/** Shows text instructions for adding location */
	var tooltip;
	
	/** Layer that holds most recent location info */
	var locationsLayer;
	
	/** Attempt to connect */
	function doConnect() {
		if (client && connected) {
			client.disconnect();
			delete client;
		}
		var host = $('#mqtt-host-name').val();
		var port = $('#mqtt-port').val();
		var clientId = $('#mqtt-client-id').val();
		var username = $('#mqtt-username').val();
		var password = $('#mqtt-password').val();
		client = new Messaging.Client(host, Number(port), clientId);
		client.onConnectionLost = onConnectionLost;
		client.onMessageArrived = onMessageArrived;
		client.connect({userName:username, password:password, onSuccess:onConnect, onFailure:onConnectFailed});
	}
	
	/** Called on successful connection */
	function onConnect() {
		if (testingConnection) {
			bootbox.alert("MQTT client connected successfully");
		}
		showConnectedButton();
		testingConnection = false;
		connected = true;
	}
	
	/** Called if connection fails */
	function onConnectFailed() {
		bootbox.alert("MQTT client connection failed. Verify that MQTT settings are correct " +
				"and the MQTT broker is running.");
		showConnectButton();
		testingConnection = false;
		connected = false;
	}
	
	/** Called if connection is broken */
	function onConnectionLost(responseObject) {
		showConnectButton();
		connected = false;
	}
	
	/** Send a message to the given destination */
	function sendMessage(payload, destinationOverride) {
		if (!connected) {
			bootbox.alert("MQTT client is not connected. Verify that MQTT settings are correct " +
			"and click the 'Connect' button.");
		}
		var message = new Messaging.Message(payload);
		var destination = $('#mqtt-topic').val();
		if (destinationOverride) {
			destination = destinationOverride;
		}
		message.destinationName = destination;
		client.send(message); 
	}
	
	/** Called when a message is received */
	function onMessageArrived(message) {
	}
	
	/** Get site information from server */
	function refreshSite() {
		$.getJSON("${pageContext.request.contextPath}/api/sites/" + siteToken,
				siteGetSuccess, siteGetFailed);
	}
    
    /** Called on successful site load request */
    function siteGetSuccess(site, status, jqXHR) {
		swInitMapForSite(map, site, null, onZonesLoaded);
		hideTooltip();
    }
    
    /** Brings locations layer to front once zones are loaded */
    function onZonesLoaded() {
    	locationsLayer.bringToFront();
    }
    
	/** Handle error on getting site data */
	function siteGetFailed(jqXHR, textStatus, errorThrown) {
		handleError(jqXHR, "Unable to load site data.");
		hideTooltip();
	}
	
	/** Get locations information from server */
	function refreshLocations() {
		$.getJSON("${pageContext.request.contextPath}/api/assignments/" + token + "/locations",
				locationsGetSuccess, locationsGetFailed);
	}
    
    /** Called on successful locations load request */
    function locationsGetSuccess(response, status, jqXHR) {
    	var locations = response.results.reverse();
    	var lastLocation;
    	var marker;
    	var latLngs = [];
    	locationsLayer.clearLayers();
    	for (var i = 0; i < locations.length; i++) {
    		lastLocation = locations[i];
    		marker = L.marker([lastLocation.latitude, lastLocation.longitude]).bindPopup(lastLocation.assetName);
    		locationsLayer.addLayer(marker);
    		latLngs.push(new L.LatLng(lastLocation.latitude, lastLocation.longitude));
    	}
    	if (latLngs.length > 0) {
    		var line = L.polyline(latLngs, {color: 'white', opacity: 0.9});
    		locationsLayer.addLayer(line);
    	}
    	if (lastLocation) {
    		map.panTo(new L.LatLng(lastLocation.latitude, lastLocation.longitude));
    	}
    	locationsLayer.bringToFront();
    }
    
	/** Handle error on getting locations data */
	function locationsGetFailed(jqXHR, textStatus, errorThrown) {
		handleError(jqXHR, "Unable to load location data.");
	}
	
	/** Show the connect button */
	function showConnectButton() {
		$('#mqtt-btn-connect').removeClass('btn-sw-success').addClass('btn-primary').html('<i class="icon-bolt sw-button-icon"></i> Connect');
		$('#mqtt-btn-connect').click(function(event) {
			event.preventDefault();
			doConnect();
		});
	}
	
	/** Hide the connect button */
	function showConnectedButton() {
		$('#mqtt-btn-connect').removeClass('btn-primary').addClass('btn-sw-success').html('<i class="icon-check sw-button-icon"></i> Connected');
		$('#mqtt-btn-connect').unbind('click');
	}
	
	/** Initialize the map */
	function initMap() {
		// Create tooltip for help message.
		tooltip = new L.Tooltip(map);
		tooltip.updateContent({text: "Click map to add a new location"});
		
		// Hook up mouse events for tooltip.
		map.on('mousemove', onMouseMove);
		map.on('mouseout', onMouseOut);
		map.on('click', onMouseClick);
		
		// Create layer for locations
		locationsLayer = new L.FeatureGroup();
		map.addLayer(locationsLayer);
	}
	
	/** Called when mouse moves over map */
	function onMouseMove(e) {
		tooltip.updatePosition(e.latlng);
	}
	
	/** Called when mouse moves out of map area */
	function onMouseOut(e) {
		hideTooltip();
	}
	
	/** Hide tooltip by moving it to southeast corner */
	function hideTooltip() {
		var se = map.getBounds().getSouthEast();
		tooltip.updatePosition(se);
	}
	
	/** Called when mouse is clicked over map */
	function onMouseClick(e) {
		lcOpen(e.latlng.lat, e.latlng.lng);
	}
	
	/** Open the location dialog */
	function lcOpen(lat, lng) {
		lcTabs.select(0);
		if (checkConnected()) {
			$("#lc-lat").val(lat);
			$("#lc-lng").val(lng);
			$("#lc-elevation").val("0");
			lcDatePicker.value(new Date());
			
			$('#lc-dialog').modal('show');
		}
	}
	
	/** Submit location data via MQTT */
	function lcSubmit() {
		var lat = $("#lc-lat").val();
		var lng = $("#lc-lng").val();
		var elevation = $("#lc-elevation").val();
		var eventDate = lcDatePicker.value();
		var eventDateStr = asISO8601(eventDate);
		var batch = {"hardwareId": hardwareId};
		batch.locations = [{"latitude": lat, "longitude": lng, "elevation": elevation, 
			"eventDate": eventDateStr, "metadata": lcMetadataDS.data()}];
		sendMessage(JSON.stringify(batch));
    	$('#lc-dialog').modal('hide');
	}
	
	/** Make sure client is connected and warn if not */
	function checkConnected() {
		if (!connected) {
			bootbox.alert("MQTT client is not currently connected. Verify MQTT settings and click " +
				"the connect button to continue.");
		}
		return connected;
	}
	
	$(document).ready(function() {
		/** Create the tab strip */
		tabs = $("#tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
		
		/** Create the MQTT tab strip */
		tabs = $("#mqtt-tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
		
		/** Create tab strip */
		lcTabs = $("#lc-tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
		
        lcDatePicker = $("#lc-event-date").kendoDateTimePicker({
            value:new Date()
        }).data("kendoDateTimePicker");;
		
		/** Local source for metadata entries */
		lcMetadataDS = new kendo.data.DataSource({
	        data: new Array(),
	        schema: {
	        	model: {
	        		id: "name",
	        		fields: {
	        			name: { type: "string" },
	        			value: { type: "string" }
	        		}
	        	}
	        }
		});
		
		/** Grid for metadata */
        $("#lc-metadata").kendoGrid({
            dataSource: lcMetadataDS,
            sortable: true,
            toolbar: ["create"],
			columns: [
				{ field: "name", title: "Name", width: "125px" },
				{ field: "value", title: "Value", width: "125px" },
				{ command: ["edit", "destroy"], title: "&nbsp;", width: "175px", 
						attributes: { "class" : "command-buttons"} },
			],
            editable: "inline"
        });
		
        /** Handle location create dialog submit */
		$('#lc-dialog-submit').click(function(event) {
			lcSubmit();
		});
		
        /** Handle dialog submit */
		$('#mqtt-btn-test-connect').click(function(event) {
			testingConnection = true;
			event.preventDefault();
			doConnect();
		});
		
        /** Handle 'refresh locations' button */
		$('#btn-refresh-locations').click(function(event) {
			refreshLocations();
		});
		
        /** Start in disconnected mode */
        showConnectButton();
       
        /** Create emulator map */
		map = L.map('emulator-map');
        initMap();
       
        refreshSite();
        refreshLocations();
	});
</script>

<%@ include file="../includes/bottom.inc"%>