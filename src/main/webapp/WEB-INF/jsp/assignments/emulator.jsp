<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="sitewhere_title" value="Assignment Emulator" />
<c:set var="sitewhere_section" value="sites" />
<c:set var="use_map_includes" value="true" />
<c:set var="use_mqtt" value="true" />
<%@ include file="../includes/top.inc"%>

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
		<div id="emulator-map" style="height: 320px; margin-top: 10px; border: 1px solid #cccccc;"></div>
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
								<input type="text" id="mqtt-client-id" value="SiteWhere"
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

<script>
	/** Assignment token */
	var token = '<c:out value="${assignment.token}"/>';
	
	/** Site token */
	var siteToken = '<c:out value="${assignment.siteToken}"/>';

	/** Tab strip */
	var tabs;
	
	/** Tabs for MQTT */
	var mqttTabs;

	/** MQTT client */
	var client;
	
	/** Emulator map */
	var map;
	
	/** Indicates if we are testing the connection */
	var testingConnection = false;
	
	/** Shows text instructions for adding location */
	var tooltip;
	
	/** Attempt to connect */
	function doConnect() {
		if (client && client.connected) {
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
	}
	
	/** Called if connection fails */
	function onConnectFailed() {
		bootbox.alert("MQTT client connection failed. Verify that MQTT settings are correct " +
				"and the MQTT broker is running.");
		showConnectButton();
		testingConnection = false;
	}
	
	/** Called if connection is broken */
	function onConnectionLost(responseObject) {
		showConnectButton();
	}
	
	/** Send a message to the given destination */
	function sendMessage(payload, destination) {
		if (!client.connected) {
			bootbox.alert("MQTT client is not connected. Verify that MQTT settings are correct " +
			"and click the 'Connect' button.");
		}
		var message = new Messaging.Message(payload);
		message.destinationName = destination;
		client.send(message); 
	}
	
	/** Called when a message is received */
	function onMessageArrived(message) {
	}
	
	/** Get site information from server */
	function reloadSite() {
		$.getJSON("${pageContext.request.contextPath}/api/sites/" + siteToken,
				siteGetSuccess, siteGetFailed);
	}
    
    /** Called on successful site load request */
    function siteGetSuccess(site, status, jqXHR) {
		swInitMapForSite(map, site);
		hideTooltip();
    }
    
	/** Handle error on getting site data */
	function siteGetFailed(jqXHR, textStatus, errorThrown) {
		handleError(jqXHR, "Unable to load site data.");
		hideTooltip();
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
		tooltip = new L.Tooltip(map);
		tooltip.updateContent({text: "Click map to add a new location"});
		map.on('mousemove', onMouseMove);
		map.on('mouseout', onMouseOut);
		map.on('click', onMouseClick);
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
		alert("Mouse clicked " + e.latlng.lat + "," + e.latlng.lng);
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
		
        /** Handle dialog submit */
		$('#mqtt-btn-test-connect').click(function(event) {
			testingConnection = true;
			event.preventDefault();
			doConnect();
		});
		
        /** Start in disconnected mode */
        showConnectButton();
       
        /** Create emulator map */
		map = L.map('emulator-map');
        initMap();
       
        reloadSite();
	});
</script>

<%@ include file="../includes/bottom.inc"%>