<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="sitewhere_title" value="View Site - ${site.name}" />
<c:set var="sitewhere_section" value="sites" />
<%@ include file="../includes/top.inc"%>

<style>
.sw-assignment-list {
	border: 0px;
}

.sw-assignment-list-entry {
	clear: both;
	height: 70px;
	padding: 10px;
	margin-bottom: 15px;
	font-size: 10pt;
	text-align: left;
	display: block;
	cursor: pointer;
	position: relative;
}

.sw-assignment-list-entry-heading {
	font-size: 12pt;
	font-weight: bold;
	line-height: 1;
}

.sw-assignment-list-entry-label {
	font-size: 10pt;
	font-weight: bold;
	display: inline-block;
}

.sw-min-40 {
	min-width: 40px;
}

.sw-min-70 {
	min-width: 70px;
}

.sw-assignment-list-entry-logowrapper {
	float: left;
	margin-right: 15px;	
	width: 70px;
	height: 70px;
	position: relative;
}

.sw-assignment-list-entry-logo-tag {
	position: absolute;
	top: -2px;
	left: -4px;
}

.sw-assignment-list-entry-logo {
	display: block;
	margin-left: auto;
	margin-right: auto;
    max-width: 70px;
    max-height: 70px;
    border: 1px solid rgb(221, 221, 221);
}

.sw-assignment-list-entry-device {
	float: right;
	width: 300px;
	height: 100%;
	padding-left: 10px;
	margin-left: 10px;
	border-left: solid 1px #e0e0e0;
}

.sw-assignment-list-entry-no-device {
	float: right;
	width: 300px;
	height: 100%;
	padding-left: 10px;
	margin-left: 10px;
	border-left: solid 1px #e0e0e0;
	text-align: center;
}

.sw-assignment-list-entry-actions {
	float: right;
	width: 260px;
	height: 100%;
	padding-left: 10px;
	margin-left: 10px;
	border-left: solid 1px #e0e0e0;
	position: relative;
}

.sw-assignment-status-indicator {
	height: 3px;
	position: absolute;
	top: 0px;
	left: 0px;
	right: 0px
}

.sw-button-bar {
	padding: 5px;
	border: 1px solid #e0e0e0;
	margin-top: 10px;
	margin-bottom: 10px;
	text-align: right;
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
	<div></div>
	<div></div>
	<div></div>
</div>

<!-- Template for assignment row -->
<script type="text/x-kendo-tmpl" id="assignment-entry">
# if (data.status == 'Active') { #
	<div class="sw-assignment-list-entry sw-assignment-active">
		<div class="sw-assignment-active-indicator sw-assignment-status-indicator"></div>
# } else if (data.status == 'Missing') { #
	<div class="sw-assignment-list-entry sw-assignment-missing">
		<div class="sw-assignment-missing-indicator sw-assignment-status-indicator"></div>
# } else { #
	<div class="sw-assignment-list-entry sw-assignment-released">
		<div class="sw-assignment-status-indicator"></div>
# } #
# if (data.assetType == 'Person') { #
		<div class="sw-assignment-list-entry-logowrapper">
			<img class="sw-assignment-list-entry-logo" src="#:associatedPerson.photoUrl#"/>
			<span class="label label-info sw-assignment-list-entry-logo-tag">Asset</span>
		</div>
# } else if (data.assetType == 'Hardware') { #
		<div class="sw-assignment-list-entry-logowrapper">
			<img class="sw-assignment-list-entry-logo" src="#:associatedHardware.imageUrl#"/>
			<span class="label label-info sw-assignment-list-entry-logo-tag">Asset</span>
		</div>
# } else if ((data.assetType == 'Unassociated') && (data.device)) { #
		<div class="sw-assignment-list-entry-logowrapper">
			<img class="sw-assignment-list-entry-logo" src="#:device.assetImageUrl#"/>
			<span class="label label-info sw-assignment-list-entry-logo-tag">Unassociated</span>
		</div>
# } #
		<div class="sw-assignment-list-entry-actions">
			<p class="ellipsis"><span class="sw-min-70 sw-assignment-list-entry-label">Assigned:</span> #= formattedDate(activeDate) #</p>
			<p class="ellipsis"><span class="sw-min-70 sw-assignment-list-entry-label">Released:</span> #= formattedDate(releasedDate) #</p>
# if (data.status == 'Active') { #
			<span class="sw-min-70 sw-assignment-list-entry-label">Status:</span>			
			<div class="btn-group" style="margin-top: -6px;">
				<a class="btn btn-small dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
					Active
					<span class="caret"></span>
				</a>
				<ul class="dropdown-menu">
					<li><a tabindex="-1" href="javascript:void(0)" title="Release Assignment"
						onclick="onReleaseAssignment(event, '#:token#')">Release Assignment</a></li>
					<li><a tabindex="-1" href="javascript:void(0)" title="Report Device/Asset Missing"
						onclick="onMissingAssignment(event, '#:token#')">Report Missing</a></li>
				</ul>
			</div>
# } else if (data.status == 'Missing') { #
			<span class="sw-min-70 sw-assignment-list-entry-label">Status:</span>			
			<div class="btn-group" style="margin-top: -6px;">
				<a class="btn btn-small dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
					Missing
					<span class="caret"></span>
				</a>
				<ul class="dropdown-menu">
					<li><a tabindex="-1" href="javascript:void(0)" title="Release Assignment"
						onclick="onReleaseAssignment(event, '#:token#')">Release Assignment</a></li>
				</ul>
			</div>
# } else { #
			<p class="ellipsis"><span class="sw-min-70 sw-assignment-list-entry-label">Status:</span> #:status#</p>
# } #
			<div class="btn-group btn-group-vertical" style="position: absolute; right: 0px; top: -2px;">
				<a class="btn btn-small btn-primary" title="Edit Assignment">
					<i class="icon-pencil icon-white"></i></a>
				<a class="btn btn-small btn-danger" title="Delete Assignment" 
					href="javascript:void(0)" onclick="onDeleteAssignment(event, '#:token#')">
					<i class="icon-remove icon-white"></i></a>
				<a class="btn btn-small btn-success" title="View Assignment">
					<i class="icon-chevron-right icon-white"></i></a>
			</div>
		</div>
# if (data.device) { #
		<div class="sw-assignment-list-entry-device">
			<div class="sw-assignment-list-entry-logowrapper">
				<img class="sw-assignment-list-entry-logo" src="#:device.assetImageUrl#" width="100"/>
				<span class="label label-info sw-assignment-list-entry-logo-tag">Device</span>
			</div>
			<p class="sw-assignment-list-entry-heading ellipsis">#:device.assetName#</p>
			<p class="ellipsis"><span class="sw-min-40 sw-assignment-list-entry-label">Id:</span> #:device.hardwareId#</p>
			<p class="ellipsis"><span class="sw-min-40 sw-assignment-list-entry-label">Info:</span> #:device.comments#</p>
		</div>
# } else { #
		<div class="sw-assignment-list-entry-no-device">
    		<div class="alert alert-error">
    			Invalid hardware id. Device not found!
			</div>
		</div>
# } #
# if (data.assetType == 'Person') { #
		<div>
			<p class="sw-assignment-list-entry-heading ellipsis">#:associatedPerson.name#</p>
			<p class="ellipsis"><span class="sw-min-40 sw-assignment-list-entry-label">Email:</span> #:associatedPerson.emailAddress#</p>
			<p class="ellipsis"><span class="sw-min-40 sw-assignment-list-entry-label">Roles:</span> #:asCommaDelimited(associatedPerson.roles)#</p>
		</div>
# } else if (data.assetType == 'Hardware') { #
		<div>
			<p class="sw-assignment-list-entry-heading ellipsis">#:associatedHardware.name#</p>
			<p class="ellipsis"><span class="sw-min-40 sw-assignment-list-entry-label">SKU:</span> #:associatedHardware.sku#</p>
			<p class="ellipsis"><span class="sw-min-40 sw-assignment-list-entry-label">Info:</span> #:associatedHardware.description#</p>
		</div>
# } else if (data.assetType == 'Unassociated') { #
		<div>
			<p class="sw-assignment-list-entry-heading ellipsis">Unassociated Device</p>
		</div>
# } #
	</div>
</script>

<%@ include file="../includes/commonFunctions.inc"%>

<script>
	var siteToken = '<c:out value="${site.token}"/>';

	/** Datasource for assignments */
	var assignmentsDS;
	
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
		
		/** Create the site list */
		$("#assignments").kendoListView({
			dataSource : assignmentsDS,
			template : kendo.template($("#assignment-entry").html())
		});
		
	    $("#assignments-pager").kendoPager({
	        dataSource: assignmentsDS
	    });
		
	    $("#btn-refresh-assignments").click(function() {
	    	assignmentsDS.read();
	    });
		
		/** Create the tab strip */
		tabs = $("#tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
	});
	
	/** Gets a string array as a comma-delimited string */
	function asCommaDelimited(input) {
		var result = "";
		if (!input) {
			return result;
		}
		for (var i =0; i<input.length; i++) {
			if (i != 0) {
				result += ", ";
			}
			result += input[i];
		}
		return result;
	}
</script>

<%@ include file="../includes/bottom.inc"%>