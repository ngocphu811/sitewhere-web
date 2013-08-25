<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="sitewhere_title" value="View Assignment" />
<c:set var="sitewhere_section" value="sites" />
<%@ include file="../includes/top.inc"%>

<style>
.event-pager {
	margin-top: 10px;
}
</style>

<!-- Title Bar -->
<div class="sw-title-bar content k-header" style="margin-bottom: -1px;">
	<h1 class="ellipsis"><c:out value="${sitewhere_title}"/></h1>
	<div class="sw-title-bar-right">
		<a id="btn-emulator" class="btn" href="javascript:void(0)">
			<i class="icon-bolt sw-button-icon"></i> Emulate Assignment</a>
		<a id="btn-edit-assignment" class="btn" href="javascript:void(0)">
			<i class="icon-edit sw-button-icon"></i> Edit Assignment</a>
	</div>
</div>

<!-- Detail panel for selected assignment -->
<div id="assignment-details" style="line-height: normal;"></div>

<!-- Tab panel -->
<div id="tabs">
	<ul>
		<li class="k-state-active">Locations</li>
		<li>Measurements</li>
		<li>Alerts</li>
	</ul>
	<div>
		<div class="k-header sw-button-bar">
			<div class="sw-button-bar-title">Device Locations</div>
			<div>
				<a id="btn-filter-locations" class="btn" href="javascript:void(0)">
					<i class="icon-search sw-button-icon"></i> Filter Results</a>
				<a id="btn-refresh-locations" class="btn" href="javascript:void(0)">
					<i class="icon-refresh sw-button-icon"></i> Refresh</a>
			</div>
		</div>
		<table id="locations">
			<colgroup>
				<col style="width: 24%;"/>
				<col style="width: 40%;"/>
				<col style="width: 18%;"/>
				<col style="width: 18%;"/>
			</colgroup>
			<thead>
				<tr>
					<th>Asset</th>
					<th>Location (Lat/Long)</th>
					<th>Event Date</th>
					<th>Received Date</th>
				</tr>
			</thead>
			<tbody>
				<tr><td colspan="4"></td></tr>
			</tbody>
		</table>
		<div id="locations-pager" class="k-pager-wrap event-pager"></div>
	</div>
	<div>
		<div class="k-header sw-button-bar">
			<div class="sw-button-bar-title">Device Measurements</div>
			<div>
				<a id="btn-filter-measurements" class="btn" href="javascript:void(0)">
					<i class="icon-search sw-button-icon"></i> Filter Results</a>
				<a id="btn-refresh-measurements" class="btn" href="javascript:void(0)">
					<i class="icon-refresh sw-button-icon"></i> Refresh</a>
			</div>
		</div>
		<table id="measurements">
			<colgroup>
				<col style="width: 24%;"/>
				<col style="width: 40%;"/>
				<col style="width: 18%;"/>
				<col style="width: 18%;"/>
			</colgroup>
			<thead>
				<tr>
					<th>Asset</th>
					<th>Measurements</th>
					<th>Event Date</th>
					<th>Received Date</th>
				</tr>
			</thead>
			<tbody>
				<tr><td colspan="4"></td></tr>
			</tbody>
		</table>
		<div id="measurements-pager" class="k-pager-wrap event-pager"></div>
	</div>
	<div>
		<div class="k-header sw-button-bar">
			<div class="sw-button-bar-title">Device Alerts</div>
			<div>
				<a id="btn-filter-alerts" class="btn" href="javascript:void(0)">
					<i class="icon-search sw-button-icon"></i> Filter Results</a>
				<a id="btn-refresh-alerts" class="btn" href="javascript:void(0)">
					<i class="icon-refresh sw-button-icon"></i> Refresh</a>
			</div>
		</div>
		<table id="alerts">
			<colgroup>
				<col style="width: 20%;"/>
				<col style="width: 10%;"/>
				<col style="width: 20%;"/>
				<col style="width: 10%;"/>
				<col style="width: 4%;"/>
				<col style="width: 18%;"/>
				<col style="width: 18%;"/>
			</colgroup>
			<thead>
				<tr>
					<th>Asset</th>
					<th>Type</th>
					<th>Message</th>
					<th>Source</th>
					<th>Ack</th>
					<th>Event Date</th>
					<th>Received Date</th>
				</tr>
			</thead>
			<tbody>
				<tr><td colspan="7"></td></tr>
			</tbody>
		</table>
		<div id="alerts-pager" class="k-pager-wrap event-pager"></div>
	</div>
</div>

<%@ include file="../includes/assignmentUpdateDialog.inc"%>

<%@ include file="../includes/templateAssignmentEntry.inc"%>

<%@ include file="../includes/templateLocationEntry.inc"%>

<%@ include file="../includes/templateMeasurementsEntry.inc"%>

<%@ include file="../includes/templateAlertEntry.inc"%>

<%@ include file="../includes/commonFunctions.inc"%>

<script>
	var token = '<c:out value="${assignment.token}"/>';
	
	/** Datasource for locations */
	var locationsDS;
	
	/** Datasource for measurements */
	var measurementsDS;
	
	/** Datasource for alerts */
	var alertsDS;
	
	/** Reference to tab panel */
	var tabs;
	
	/** Called when 'edit assignment' is clicked */
	function onEditAssignment(e, token) {
		var event = e || window.event;
		event.stopPropagation();
		auOpen(token, onEditAssignmentComplete);
	}
	
	/** Called after successful edit assignment */
	function onEditAssignmentComplete() {
		// Handle reload.
	}
	
	/** Called when 'release assignment' is clicked */
	function onReleaseAssignment(e, token) {
		var event = e || window.event;
		event.stopPropagation();
		swReleaseAssignment(token, onReleaseAssignmentComplete);
	}
	
	/** Called after successful release assignment */
	function onReleaseAssignmentComplete() {
		loadAssignment();
	}
	
	/** Called when 'missing assignment' is clicked */
	function onMissingAssignment(e, token) {
		var event = e || window.event;
		event.stopPropagation();
		swAssignmentMissing(token, onMissingAssignmentComplete);
	}
	
	/** Called after successful missing assignment */
	function onMissingAssignmentComplete() {
		loadAssignment();
	}
	
	$(document).ready(function() {
		
		/** Create AJAX datasource for locations list */
		locationsDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/assignments/" + token + "/locations",
					dataType : "json",
				}
			},
			schema : {
				data: "results",
				total: "numResults",
				parse: parseEventResults,
			},
			pageSize: 10
		});
		
		/** Create the location list */
        $("#locations").kendoGrid({
			dataSource : locationsDS,
            rowTemplate: kendo.template($("#tpl-location-entry").html()),
            scrollable: false,
        });
		
	    $("#locations-pager").kendoPager({
	        dataSource: locationsDS
	    });
		
	    $("#btn-refresh-locations").click(function() {
	    	locationsDS.read();
	    });
	    
		/** Create AJAX datasource for measurements list */
		measurementsDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/assignments/" + token + "/measurements",
					dataType : "json",
				}
			},
			schema : {
				data: "results",
				total: "numResults",
				parse: parseEventResults,
			},
			pageSize: 10
		});
		
		/** Create the measurements list */
        $("#measurements").kendoGrid({
			dataSource : measurementsDS,
            rowTemplate: kendo.template($("#tpl-measurements-entry").html()),
            scrollable: false,
        });
		
	    $("#measurements-pager").kendoPager({
	        dataSource: measurementsDS
	    });
		
	    $("#btn-refresh-measurements").click(function() {
	    	measurementsDS.read();
	    });
	    
		/** Create AJAX datasource for alerts list */
		alertsDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/assignments/" + token + "/alerts",
					dataType : "json",
				}
			},
			schema : {
				data: "results",
				total: "numResults",
				parse: parseEventResults,
			},
			pageSize: 10
		});
		
		/** Create the measurements list */
        $("#alerts").kendoGrid({
			dataSource : alertsDS,
            rowTemplate: kendo.template($("#tpl-alert-entry").html()),
            scrollable: false,
        });
		
	    $("#alerts-pager").kendoPager({
	        dataSource: alertsDS
	    });
		
	    $("#btn-refresh-alerts").click(function() {
	    	alertsDS.read();
	    });
		
	    $("#btn-edit-assignment").click(function() {
			auOpen(token, onAssignmentEditSuccess);
	    });
		
		/** Create the tab strip */
		tabs = $("#tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
		
		loadAssignment();
	});
	
	/** Loads information for the selected assignment */
	function loadAssignment() {
		$.getJSON("${pageContext.request.contextPath}/api/assignments/" + token, 
			loadGetSuccess, loadGetFailed);
	}
    
    /** Called on successful assignment load request */
    function loadGetSuccess(data, status, jqXHR) {
		var template = kendo.template($("#tpl-assignment-entry").html());
		parseAssignmentData(data);
		data.inDetailView = true;
		$('#assignment-details').html(template(data));
    }
    
	/** Handle error on getting assignment data */
	function loadGetFailed(jqXHR, textStatus, errorThrown) {
		handleError(jqXHR, "Unable to load assignment data.");
	}
	
	/** Parses event response records to format dates */
	function parseEventResults(response) {
	    $.each(response.results, function (index, item) {
			parseEventData(item);
	    });
	    return response;
	}
	
	/** Called after successful edit of assignment */
	function onAssignmentEditSuccess() {
		loadAssignment();
	}
</script>

<%@ include file="../includes/bottom.inc"%>