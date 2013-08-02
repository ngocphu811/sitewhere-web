<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="sitewhere_title" value="View Site - ${site.name}" />
<c:set var="sitewhere_section" value="sites" />
<%@ include file="../includes/top.inc"%>

<style>
.sw-assignment-list {
	border: 0px;
}
</style>

<!-- Title Bar -->
<div class="sw-title-bar content k-header">
	<h1 class="ellipsis"><c:out value="${sitewhere_title}"/></h1>
	<div class="sw-title-bar-right">
		<a id="btn-edit-site" class="btn" href="javascript:void(0)">
			<i class="icon-plus"></i> Edit Site</a>
	</div>
</div>

<!-- Tab panel -->
<div id="tabs">
	<ul>
		<li class="k-state-active">Assignments</li>
		<li>Locations</li>
		<li>Measurements</li>
		<li>Alerts</li>
	</ul>
	<div>
		<div class="k-header sw-button-bar">
			<div class="sw-button-bar-title">Device Assignments</div>
			<div>
				<a id="btn-filter-assignments" class="btn" href="javascript:void(0)">
					<i class="icon-search"></i> Filter Results</a>
				<a id="btn-refresh-assignments" class="btn" href="javascript:void(0)">
					<i class="icon-refresh"></i> Refresh</a>
			</div>
		</div>
		<div id="assignments" class="sw-assignment-list"></div>
		<div id="assignments-pager" class="k-pager-wrap"></div>
	</div>
	<div>
		<div class="k-header sw-button-bar">
			<div class="sw-button-bar-title">Device Locations</div>
			<div>
				<a id="btn-filter-locations" class="btn" href="javascript:void(0)">
					<i class="icon-search"></i> Filter Results</a>
				<a id="btn-refresh-locations" class="btn" href="javascript:void(0)">
					<i class="icon-refresh"></i> Refresh</a>
			</div>
		</div>
		<table id="locations">
			<colgroup><col/><col/><col/></colgroup>
			<thead>
				<tr>
					<th>Asset</th>
					<th>Location</th>
					<th>Event Date</th>
					<th>Received Date</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<tr><td colspan="5"></td></tr>
			</tbody>
		</table>
		<div id="locations-pager" class="k-pager-wrap"></div>
	</div>
	<div>
		<div class="k-header sw-button-bar">
			<div class="sw-button-bar-title">Device Measurements</div>
			<div>
				<a id="btn-filter-measurements" class="btn" href="javascript:void(0)">
					<i class="icon-search"></i> Filter Results</a>
				<a id="btn-refresh-measurements" class="btn" href="javascript:void(0)">
					<i class="icon-refresh"></i> Refresh</a>
			</div>
		</div>
		<div id="measurements" class="sw-assignment-list"></div>
		<div id="measurements-pager" class="k-pager-wrap"></div>
	</div>
	<div>
		<div class="k-header sw-button-bar">
			<div class="sw-button-bar-title">Device Alerts</div>
			<div>
				<a id="btn-filter-alerts" class="btn" href="javascript:void(0)">
					<i class="icon-search"></i> Filter Results</a>
				<a id="btn-refresh-alerts" class="btn" href="javascript:void(0)">
					<i class="icon-refresh"></i> Refresh</a>
			</div>
		</div>
		<div id="alerts" class="sw-assignment-list"></div>
		<div id="alerts-pager" class="k-pager-wrap"></div>
	</div>
</div>

<%@ include file="../includes/assignmentUpdateDialog.inc"%>

<%@ include file="../includes/templateAssignmentEntry.inc"%>

<%@ include file="../includes/templateLocationEntry.inc"%>

<%@ include file="../includes/commonFunctions.inc"%>

<script>
	var siteToken = '<c:out value="${site.token}"/>';

	/** Datasource for assignments */
	var assignmentsDS;
	
	/** Datasource for locations */
	var locationsDS;
	
	/** Datasource for measurements */
	var measurementsDS;
	
	/** Datasource for alerts */
	var alertsDS;
	
	/** Reference to tab panel */
	var tabs;
	
	/** Called when 'delete assignment' is clicked */
	function onDeleteAssignment(e, token) {
		var event = e || window.event;
		event.stopPropagation();
		swAssignmentDelete(token, onDeleteAssignmentComplete);
	}
	
	/** Called after successful delete assignment */
	function onDeleteAssignmentComplete() {
		assignmentsDS.read();
	}
	
	/** Called when 'edit assignment' is clicked */
	function onEditAssignment(e, token) {
		var event = e || window.event;
		event.stopPropagation();
		auOpen(token, onEditAssignmentComplete);
	}
	
	/** Called after successful edit assignment */
	function onEditAssignmentComplete() {
		assignmentsDS.read();
	}
	
	/** Called when 'release assignment' is clicked */
	function onReleaseAssignment(e, token) {
		var event = e || window.event;
		event.stopPropagation();
		swReleaseAssignment(token, onReleaseAssignmentComplete);
	}
	
	/** Called after successful release assignment */
	function onReleaseAssignmentComplete() {
		assignmentsDS.read();
	}
	
	/** Called when 'missing assignment' is clicked */
	function onMissingAssignment(e, token) {
		var event = e || window.event;
		event.stopPropagation();
		swAssignmentMissing(token, onMissingAssignmentComplete);
	}
	
	/** Called after successful missing assignment */
	function onMissingAssignmentComplete() {
		assignmentsDS.read();
	}
	
	$(document).ready(function() {
		
		/** Create AJAX datasource for assignments list */
		assignmentsDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/sites/" + siteToken + 
						"/assignments?includeDevice=true&includeAsset=true",
					dataType : "json",
				}
			},
			schema : {
				data: "results",
				total: "numResults",
				parse:function (response) {
				    $.each(response.results, function (index, item) {
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
				    });
				    return response;
				}
			},
			pageSize: 10
		});
		
		/** Create the assignments list */
		$("#assignments").kendoListView({
			dataSource : assignmentsDS,
			template : kendo.template($("#tpl-assignment-entry").html())
		});
		
	    $("#assignments-pager").kendoPager({
	        dataSource: assignmentsDS
	    });
		
	    $("#btn-refresh-assignments").click(function() {
	    	assignmentsDS.read();
	    });
	    
		/** Create AJAX datasource for locations list */
		locationsDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/sites/" + siteToken + "/locations",
					dataType : "json",
				}
			},
			schema : {
				data: "results",
				total: "numResults",
				parse:function (response) {
				    $.each(response.results, function (index, item) {
				        if (item.eventDate && typeof item.eventDate === "string") {
				        	item.eventDate = kendo.parseDate(item.eventDate);
				        }
				        if (item.receivedDate && typeof item.receivedDate === "string") {
				        	item.receivedDate = kendo.parseDate(item.receivedDate);
				        }
				    });
				    return response;
				}
			},
			pageSize: 10
		});
		
		/** Create the location list */
        $("#locations").kendoGrid({
			dataSource : locationsDS,
            rowTemplate: kendo.template($("#tpl-location-entry").html()),
        });
		
	    $("#locations-pager").kendoPager({
	        dataSource: locationsDS
	    });
		
	    $("#btn-refresh-locations").click(function() {
	    	locationsDS.read();
	    });
		
		/** Create the tab strip */
		tabs = $("#tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
	});
</script>

<%@ include file="../includes/bottom.inc"%>