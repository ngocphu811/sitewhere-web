<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="sitewhere_title" value="Assignment Emulator" />
<c:set var="sitewhere_section" value="sites" />
<c:set var="use_map_includes" value="true" />
<c:set var="use_mqtt" value="true" />
<%@ include file="../includes/top.inc"%>

<style>
	.emulator-map {
		height: 400px; 
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
				<div class="btn-group">
					<a class="btn" href="javascript:void(0)">
						<i class="icon-plus sw-button-icon"></i> Create</a>
					<button class="btn dropdown-toggle" data-toggle="dropdown">
					<span class="caret"></span>
					</button>
					<ul class="dropdown-menu" style="text-align: left;">
						<li><a tabindex="-1" href="javascript:void(0)" onclick="mcOpen()">Measurements</a></li>
						<li><a tabindex="-1" href="javascript:void(0)" onclick="acOpen()">Alert</a></li>
					</ul>
				</div>			
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
					<li>Last Message</li>
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
					<div id="mqtt-last-message">
						<div style="padding: 25px; font-size: 14pt; text-align: center;">
							JSON content of the MQTT payload is shown here when data is sent via the client.
						</div>
					</div>
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
				<div id="lc-metadata" class="sw-metadata-grid"></div>
            </div>
		</div>
	</div>
	<div class="modal-footer">
		<a href="javascript:void(0)" class="btn" data-dismiss="modal">Cancel</a> 
		<a id="lc-dialog-submit" href="javascript:void(0)" class="btn btn-primary">Create</a>
	</div>
</div>

<!-- Dialog for creating a new measurement -->
<div id="mc-dialog" class="modal hide">
	<div class="modal-header k-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>Create Measurements</h3>
	</div>
	<div class="modal-body">
		<div id="mc-tabs" style="clear: both;">
			<ul>
				<li class="k-state-active">Measurements</li>
				<li>Metadata</li>
			</ul>
			<div>
				<div id="mc-measurements"></div>
				<form class="form-horizontal" style="padding-top: 20px">
					<div class="control-group">
						<label class="control-label" for="lc-event-date">Event Date</label>
						<div class="controls">
							<input id="mc-event-date" class="input-large">
						</div>
					</div>
				</form>
            </div>
			<div>
				<div id="mc-metadata" class="sw-metadata-grid"></div>
            </div>
		</div>
	</div>
	<div class="modal-footer">
		<a href="javascript:void(0)" class="btn" data-dismiss="modal">Cancel</a> 
		<a id="mc-dialog-submit" href="javascript:void(0)" class="btn btn-primary">Create</a>
	</div>
</div>

<!-- Dialog for creating a new location -->
<div id="ac-dialog" class="modal hide">
	<div class="modal-header k-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>Create Alert</h3>
	</div>
	<div class="modal-body">
		<div id="ac-tabs" style="clear: both;">
			<ul>
				<li class="k-state-active">Alert</li>
				<li>Metadata</li>
			</ul>
			<div>
				<form class="form-horizontal" style="padding-top: 20px">
					<div class="control-group">
						<label class="control-label" for="ac-type">Alert Type</label>
						<div class="controls">
							<input type="text" id="ac-type" class="input-xlarge">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="ac-message">Message</label>
						<div class="controls">
							<textarea id="ac-message" class="input-xlarge" style="height: 120px;"></textarea>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="ac-event-date">Event Date</label>
						<div class="controls">
							<input id="ac-event-date" class="input-large">
						</div>
					</div>
				</form>
			</div>
			<div>
				<div id="ac-metadata" class="sw-metadata-grid"></div>
            </div>
		</div>
	</div>
	<div class="modal-footer">
		<a href="javascript:void(0)" class="btn" data-dismiss="modal">Cancel</a> 
		<a id="ac-dialog-submit" href="javascript:void(0)" class="btn btn-primary">Create</a>
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

	/** Provides external access to tabs */
	var mcTabs;
	
	/** Measurements datasource */
	var mcMeasurementsDS;
	
	/** Metadata datasource */
	var mcMetadataDS;
	
	/** Picker for event date */
	var mcDatePicker;

	/** Provides external access to tabs */
	var acTabs;
	
	/** Metadata datasource */
	var acMetadataDS;
	
	/** Picker for event date */
	var acDatePicker;

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
			swAlert("Connected", "MQTT client connected successfully");
		}
		showConnectedButton();
		testingConnection = false;
		connected = true;
	}
	
	/** Called if connection fails */
	function onConnectFailed() {
		swAlert("Connect Failed", "MQTT client connection failed. Verify that MQTT settings are correct " +
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
		if (checkConnected()) {
			var message = new Messaging.Message(payload);
			var destination = $('#mqtt-topic').val();
			if (destinationOverride) {
				destination = destinationOverride;
			}
			message.destinationName = destination;
			client.send(message);
			$('#mqtt-last-message').html("<pre><code>" + payload + "</code></pre>");
			hljs.highlightBlock(document.getElementById('mqtt-last-message').childNodes[0]);
		}
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
			lcMetadataDS.data(new Array());
			
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
		sendMessage(JSON.stringify(batch, null, "\t"));
    	$('#lc-dialog').modal('hide');
	}
	
	/** Open the measurements dialog */
	function mcOpen() {
		mcTabs.select(0);
		if (checkConnected()) {
			mcMeasurementsDS.data(new Array());
			mcMetadataDS.data(new Array());
			
			$('#mc-dialog').modal('show');
		}
	}
	
	/** Submit measurements data via MQTT */
	function mcSubmit() {
		var eventDate = mcDatePicker.value();
		var eventDateStr = asISO8601(eventDate);
		var batch = {"hardwareId": hardwareId};
		batch.measurements = [{"eventDate": eventDateStr, "measurements": mcMeasurementsDS.data(), 
			"metadata": mcMetadataDS.data()}];
		sendMessage(JSON.stringify(batch, null, "\t"));
    	$('#mc-dialog').modal('hide');
	}
	
	/** Open the alert dialog */
	function acOpen() {
		acTabs.select(0);
		if (checkConnected()) {
			$("#ac-type").val("");
			$("#ac-message").val("");
			acDatePicker.value(new Date());
			acMetadataDS.data(new Array());
			
			$('#ac-dialog').modal('show');
		}
	}
	
	/** Submit alert data via MQTT */
	function acSubmit() {
		var type = $("#ac-type").val();
		var message = $("#ac-message").val();
		var eventDate = acDatePicker.value();
		var eventDateStr = asISO8601(eventDate);
		var batch = {"hardwareId": hardwareId};
		batch.alerts = [{"type": type, "message": message, "eventDate": eventDateStr,
			"metadata": acMetadataDS.data()}];
		sendMessage(JSON.stringify(batch, null, "\t"));
    	$('#ac-dialog').modal('hide');
	}
	
	/** Make sure client is connected and warn if not */
	function checkConnected() {
		if (!connected) {
			swAlert("Not Connected", "MQTT client is not currently connected. Verify MQTT settings and click " +
				"the <b>Connect</b> button to continue.");
		}
		return connected;
	}
	
	$(document).ready(function() {
		/** Create the tab strip */
		tabs = $("#tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
		
		/** Create the MQTT tab strip */
		mqttTabs = $("#mqtt-tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
		
		/** Create tab strip */
		lcTabs = $("#lc-tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
		
        lcDatePicker = $("#lc-event-date").kendoDateTimePicker({
            value:new Date()
        }).data("kendoDateTimePicker");
		
		/** Local source for metadata entries */
		lcMetadataDS = swMetadataDatasource();
		
		/** Grid for metadata */
        $("#lc-metadata").kendoGrid(swMetadataGridOptions(lcMetadataDS));
		
        /** Handle location create dialog submit */
		$('#lc-dialog-submit').click(function(event) {
			lcSubmit();
		});
		
		/** Create tab strip */
		mcTabs = $("#mc-tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
		
		/** Local source for metadata entries */
		mcMeasurementsDS = swMetadataDatasource();
		
		/** Grid for metadata */
        $("#mc-measurements").kendoGrid(swMetadataGridOptions(mcMeasurementsDS, "Add Measurement"));
		
		/** Local source for metadata entries */
		mcMetadataDS = swMetadataDatasource();
		
		/** Grid for metadata */
        $("#mc-metadata").kendoGrid(swMetadataGridOptions(mcMetadataDS));
		
        mcDatePicker = $("#mc-event-date").kendoDateTimePicker({
            value:new Date()
        }).data("kendoDateTimePicker");
		
        /** Handle location create dialog submit */
		$('#mc-dialog-submit').click(function(event) {
			mcSubmit();
		});
		
		/** Create tab strip */
		acTabs = $("#ac-tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
		
        acDatePicker = $("#ac-event-date").kendoDateTimePicker({
            value:new Date()
        }).data("kendoDateTimePicker");
		
		/** Local source for metadata entries */
		acMetadataDS = swMetadataDatasource();
		
		/** Grid for metadata */
        $("#ac-metadata").kendoGrid(swMetadataGridOptions(acMetadataDS));
		
        /** Handle location create dialog submit */
		$('#ac-dialog-submit').click(function(event) {
			acSubmit();
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