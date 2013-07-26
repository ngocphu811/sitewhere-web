<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="sitewhere_title" value="Manage Devices" />
<c:set var="sitewhere_section" value="devices" />
<%@ include file="../includes/top.inc"%>

<style>
.sw-device-list {
	border: 0px;
}

.sw-device-list-entry {
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

.sw-device-list-entry-heading {
	font-size: 14pt;
	font-weight: bold;
	line-height: 1;
}

.sw-device-list-entry-label {
	font-size: 10pt;
	font-weight: bold;
	min-width: 70px;
	display: inline-block;
}

.sw-device-list-entry-logowrapper {
	float: left;
	margin-right: 15px;	
	width: 70px;
	height: 70px;
	background-color: #f0f0f0;
	border: 1px solid #dddddd;
	position: relative;
}

.sw-device-list-entry-logo-tag {
	position: absolute;
	top: -2px;
	left: -4px;
}

.sw-device-list-entry-logo {
	display: block;
	margin-left: auto;
	margin-right: auto;
    max-width: 70px;
    max-height: 70px;
}

.sw-device-list-entry-assignment {
	float: right;
	width: 320px;
	height: 100%;
	padding-left: 10px;
	margin-left: 10px;
	border-left: solid 1px #e0e0e0;
}

.sw-device-list-entry-no-assignment {
	float: right;
	width: 320px;
	height: 100%;
	padding-left: 10px;
	margin-left: 10px;
	border-left: solid 1px #e0e0e0;
	text-align: center;
}

.sw-device-list-entry-actions {
	float: right;
	width: 260px;
	height: 100%;
	padding-left: 10px;
	margin-left: 10px;
	border-left: solid 1px #e0e0e0;
	position: relative;
}

.k-grid-content {
	min-height: 200px;
}

.command-buttons {
	text-align: center;
}

#metadataGrid {
	margin-top: 15px;
	margin-bottom: 15px;
}
</style>

<!-- Title Bar -->
<div class="sw-title-bar content k-header">
	<h1><c:out value="${sitewhere_title}"/></h1>
	<div class="sw-title-bar-right">
		<a id="btn-filter-results" class="btn" href="javascript:void(0)">
			<i class="icon-search"></i> Filter Results</a>
		<a id="btn-add-device" class="btn" href="javascript:void(0)">
			<i class="icon-plus"></i> Add New Device</a>
	</div>
</div>
<div id="devices" class="sw-device-list"></div>
<div id="pager" class="k-pager-wrap"></div>

<!-- Device list item template -->
<script type="text/x-kendo-tmpl" id="device-entry">
	<div class="sw-device-list-entry gradient-bg" onclick="onDeviceOpenClicked(event, '#:hardwareId#')"
		title="View Device">
		<div class="sw-device-list-entry-logowrapper">
			<img class="sw-device-list-entry-logo" src="#:assetImageUrl#" width="100"/>
			<span class="label label-info sw-device-list-entry-logo-tag">Device</span>
		</div>
		<div class="sw-device-list-entry-actions">
			<p class="ellipsis"><span class="sw-device-list-entry-label">Created:</span> #= formattedDate(createdDate) #</p>
			<p class="ellipsis"><span class="sw-device-list-entry-label">Updated:</span> #= formattedDate(updatedDate) #</p>
			<div class="btn-group btn-group-vertical" style="position: absolute; right: 0px; top: -2px;">
				<a class="btn btn-small btn-primary" title="Edit Device" 
					href="javascript:void(0)" onclick="onDeviceEditClicked(event, '#:hardwareId#');">
					<i class="icon-pencil icon-white"></i></a>
				<a class="btn btn-small btn-danger" title="Delete Device" 
					href="javascript:void(0)" onclick="onDeviceDeleteClicked(event, '#:hardwareId#')">
					<i class="icon-remove icon-white"></i></a>
				<a class="btn btn-small btn-success" title="View Device" 
					href="javascript:void(0)" onclick="onDeviceOpenClicked(event, '#:hardwareId#')">
					<i class="icon-chevron-right icon-white"></i></a>
			</div>
		</div>
# if (data.assignment) { #
		<div class="sw-device-list-entry-assignment">
			<div class="sw-device-list-entry-logowrapper">
				<img class="sw-device-list-entry-logo" src="#:assignment.assetImageUrl#" width="100"/>
				<span class="label label-info sw-device-list-entry-logo-tag">Asset</span>
			</div>
			<p class="sw-device-list-entry-heading ellipsis">#:assignment.assetName#</p>
			<p class="ellipsis"><span class="sw-device-list-entry-label">Assigned:</span> #= formattedDate(assignment.activeDate) #</p>
			<p class="ellipsis"><span class="sw-device-list-entry-label">Status:</span> #:assignment.status#</p>
		</div>
# } else { #
		<div class="sw-device-list-entry-no-assignment">
    		<div class="alert alert-info">
    			Device is not currently assigned.
			</div>
		</div>
# } #
		<div>
			<p class="sw-device-list-entry-heading ellipsis">#:assetName#</p>
			<p class="ellipsis"><b>#:hardwareId#</b></p>
			<p class="ellipsis">#:comments#</p>
		</div>
	</div>
</script>

<script>
    $(document).ready(function() {
		/** Create AJAX datasource for devices list */
		var devicesDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/devices?includeAssignment=true",
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
				        if (item.assignment) {
					        if (item.assignment.activeDate && typeof item.assignment.activeDate === "string") {
					        	item.assignment.activeDate = kendo.parseDate(item.assignment.activeDate);
					        }
				        }
				    });
				    return response;
				}
			},
			pageSize: 10
		});
		

		/** Create the list of devices */
		$("#devices").kendoListView({
			dataSource : devicesDS,
			template : kendo.template($("#device-entry").html())
		});
		
        $("#pager").kendoPager({
            dataSource: devicesDS
        });
        
        /** Handle create dialog */
		$('#btn-add-device').click(function(event) {
		});
    });
</script>

<%@ include file="../includes/bottom.inc"%>