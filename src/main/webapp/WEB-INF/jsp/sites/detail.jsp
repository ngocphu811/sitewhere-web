<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="sitewhere_title" value="View Site: ${site.name}" />
<c:set var="sitewhere_section" value="sites" />
<%@ include file="../includes/top.inc"%>

<style>
.sw-assignment-list {
	border: 0px;
}

.sw-assignment-list-entry {
	clear: both;
	height: 70px;
	border: 1px solid #dcdcdc;
	padding: 10px;
	margin-bottom: 15px;
	font-size: 10pt;
	text-align: left;
	display: block;
	cursor: pointer;
}

.sw-assignment-list-entry-heading {
	font-size: 12pt;
	font-weight: bold;
	line-height: 1;
}

.sw-assignment-list-entry-label {
	font-size: 10pt;
	font-weight: bold;
	min-width: 70px;
	display: inline-block;
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
	<h1><c:out value="${sitewhere_title}"/></h1>
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
				<a id="btn-create-assignment" class="btn" href="javascript:void(0)">
					<i class="icon-plus"></i> Create Assignment</a>
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
	<div class="sw-assignment-list-entry gradient-bg">
		<div class="sw-assignment-list-entry-logowrapper">
			<img class="sw-assignment-list-entry-logo" src="#:assetImageUrl#" width="100"/>
			<span class="label label-info sw-assignment-list-entry-logo-tag">Asset</span>
		</div>
		<div class="sw-assignment-list-entry-actions">
			<p class="ellipsis"><span class="sw-assignment-list-entry-label">Assigned:</span> #= formattedDate(activeDate) #</p>
			<p class="ellipsis"><span class="sw-assignment-list-entry-label">Released:</span> #= formattedDate(releasedDate) #</p>
# if (data.status == 'Active') { #
			<span class="sw-assignment-list-entry-label">Status:</span>			
			<div class="btn-group" style="margin-top: -6px;">
				<a class="btn btn-small dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
					Active
					<span class="caret"></span>
				</a>
				<ul class="dropdown-menu">
					<li><a tabindex="-1" href="javascript:void(0)">Release Assignment</a></li>
					<li><a tabindex="-1" href="javascript:void(0)">Report Missing</a></li>
				</ul>
			</div>
# } else { #
			<p class="ellipsis"><span class="sw-assignment-list-entry-label">Status:</span> #:status#</p>
# } #
			<div class="btn-group btn-group-vertical" style="position: absolute; right: 0px; top: -2px;">
				<a class="btn btn-small btn-primary" title="Edit Device">
					<i class="icon-pencil icon-white"></i></a>
				<a class="btn btn-small btn-danger" title="Delete Device">
					<i class="icon-remove icon-white"></i></a>
				<a class="btn btn-small btn-success" title="View Device">
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
			<p class="ellipsis"><b>#:device.hardwareId#</b></p>
			<p class="ellipsis">#:device.comments#</p>
		</div>
# } else { #
		<div class="sw-assignment-list-entry-no-device">
    		<div class="alert alert-error">
    			Invalid hardware id. Device not found!
			</div>
		</div>
# } #
		<div>
			<p class="sw-assignment-list-entry-heading ellipsis">#:assetName#</p>
		</div>
	</div>
</script>

<script>
	var siteToken = '<c:out value="${site.token}"/>';

	/** Datasource for assignments */
	var assignmentsDS;
	
	/** Reference to tab panel */
	var tabs;
	
	$(document).ready(function() {
		
		/** Create AJAX datasource for assignments list */
		assignmentsDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/sites/" + siteToken + "/assignments?includeDevice=true",
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
		
		/** Create the tab strip */
		tabs = $("#tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
	});
</script>

<%@ include file="../includes/bottom.inc"%>