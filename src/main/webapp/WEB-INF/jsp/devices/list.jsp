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
	font-size: 12pt;
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
    border: 1px solid rgb(221, 221, 221);
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

.sw-device-update-imgwrapper {
	float: left;
	margin-left: 60px;
	margin-right: 20px;
	width: 100px;
	height: 100px;
	position: relative;
}

.sw-device-update-img {
	display: block;
	margin-left: auto;
	margin-right: auto;
    max-width: 100px;
    max-height: 100px;
    border: 1px solid rgb(221, 221, 221);
}

.sw-device-update-label {
	font-size: 10pt;
	font-weight: bold;
	min-width: 100px;
	display: inline-block;
}

.k-grid-content {
	min-height: 200px;
}

.command-buttons {
	text-align: center;
}

#device-metadata {
	margin-top: 15px;
	margin-bottom: 15px;
}
</style>

<%@ include file="../includes/deviceCreateDialog.inc"%>

<%@ include file="../includes/deviceUpdateDialog.inc"%>

<%@ include file="../includes/assignmentCreateDialog.inc"%>

<!-- Title Bar -->
<div class="sw-title-bar content k-header">
	<h1 class="ellipsis"><c:out value="${sitewhere_title}"/></h1>
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
	<div class="sw-device-list-entry gradient-bg">
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
				<img class="sw-device-list-entry-logo" src="#:assignment.assetImageUrl#"/>
				<span class="label label-info sw-device-list-entry-logo-tag">Asset</span>
			</div>
			<p class="sw-device-list-entry-heading ellipsis">#:assignment.assetName#</p>
			<p class="ellipsis"><span class="sw-device-list-entry-label">Assigned:</span> #= formattedDate(assignment.activeDate) #</p>
# if (assignment.status == 'Active') { #
			<span class="sw-device-list-entry-label">Status:</span> 
			<div class="btn-group" style="margin-top: -6px;">
				<a class="btn btn-small dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
					Active
					<span class="caret"></span>
				</a>
				<ul class="dropdown-menu">
					<li><a tabindex="-1" href="javascript:void(0)" title="Release Assignment"
						onclick="onReleaseAssignment(event, '#:assignment.token#')">Release Assignment</a></li>
					<li><a tabindex="-1" href="javascript:void(0)" title="Report Device/Asset Missing"
						onclick="onMissingAssignment(event, '#:assignment.token#')">Report Missing</a></li>
				</ul>
			</div>
# } else if (assignment.status == 'Missing') { #
			<span class="sw-device-list-entry-label">Status:</span> 
			<div class="btn-group" style="margin-top: -6px;">
				<a class="btn btn-small dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
					Missing
					<span class="caret"></span>
				</a>
				<ul class="dropdown-menu">
					<li><a tabindex="-1" href="javascript:void(0)" title="Release Assignment"
						onclick="onReleaseAssignment(event, '#:assignment.token#')">Release Assignment</a></li>
				</ul>
			</div>
# } else { #
			<p class="ellipsis"><span class="sw-device-list-entry-label">Status:</span> #:assignment.status#</p>
# } #
		</div>
# } else { #
		<div class="sw-device-list-entry-no-assignment">
    		<div class="alert alert-info">
    			<p>Device is not currently assigned.</p>
				<a class="btn" title="Assign Device" href="javascript:void(0)" 
					onclick="acOpen(event, '#:hardwareId#', onAssignmentAdded)" style="margin-top: -4px;">Assign Device</a>
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

<!-- Static content in top of update dialog -->
<script type="text/x-kendo-tmpl" id="device-update-static">
	<div class="sw-device-update-imgwrapper">
		<img class="sw-device-update-img" src="#:deviceAsset.imageUrl#"/>
	</div>
	<p class="ellipsis"><span class="sw-device-update-label">Hardware Id:</span> #:hardwareId#</p>
	<p class="ellipsis"><span class="sw-device-update-label">Hardware Type:</span> #:deviceAsset.name#</p>
	<p class="ellipsis"><span class="sw-device-update-label">Created:</span> #= formattedDate(kendo.parseDate(createdDate)) #</p>
	<p class="ellipsis"><span class="sw-device-update-label">Updated:</span> #= formattedDate(kendo.parseDate(updatedDate)) #</p>
</script>

<%@ include file="../includes/assetTemplates.inc"%>

<script>
	/** Reference for device list datasource */
	var devicesDS;
	
	/** Reference for metadata datasource */
	var metaDatasource;
	
	/** Reference to tabs in update dialog */
	var updateTabs;
	
	/** Called when edit button on the list entry is pressed */
	function onDeviceEditClicked(e, hardwareId) {
		var event = e || window.event;
		event.stopPropagation();
		$.getJSON("${pageContext.request.contextPath}/api/devices/" + hardwareId, 
			onUpdateGetSuccess, onUpdateGetFailed);
	}
    
    /** Called on successful device load request */
    function onUpdateGetSuccess(data, status, jqXHR) {
    	$('#du-general-form')[0].reset();
		$('#du-dialog').modal('show');
		
		var template = kendo.template($("#device-update-static").html());
		$('#du-static-header').html(template(data));
		$('#du-hardware-id').val(data.hardwareId);
		$('#du-comments').val(data.comments);
		$('#du-asset-id').val(data.deviceAsset.id);
		metaDatasource.data(data.metadata);
		updateTabs.select(0);
    }
    
	/** Handle error on getting site */
	function onUpdateGetFailed(jqXHR, textStatus, errorThrown) {
		handleError(jqXHR, "Unable to get device for update.");
	}
	
	/** Called when delete button is clicked */
	function onDeviceDeleteClicked(e, hardwareId) {
		var event = e || window.event;
		event.stopPropagation();
		bootbox.confirm("Delete device?", function(result) {
			if (result) {
				$.deleteJSON("${pageContext.request.contextPath}/api/devices/" + hardwareId + "?force=true", 
						onDeleteSuccess, onDeleteFail);
			}
		});
	}
    
    /** Called on successful delete */
    function onDeleteSuccess() {
    	devicesDS.read();
    }
    
	/** Handle failed delete call */
	function onDeleteFail(jqXHR, textStatus, errorThrown) {
		handleError(jqXHR, "Unable to delete device.");
	}
	
	/** Called to release a device assignment */
	function onReleaseAssignment(e, token) {
		bootbox.confirm("Release device assignment?", function(result) {
			if (result) {
				$.postJSON("${pageContext.request.contextPath}/api/assignments/" + token + "/end", 
					null, onDeleteSuccess, onDeleteFail);
			}
		});
	}
    
    /** Called on successful release */
    function onReleaseSuccess() {
    	devicesDS.read();
    }
    
	/** Handle failed release call */
	function onReleaseFail(jqXHR, textStatus, errorThrown) {
		handleError(jqXHR, "Unable to release assignment.");
	}
	
	/** Called to report an assignment missing */
	function onMissingAssignment(e, token) {
		bootbox.confirm("Report assignment missing?", function(result) {
			if (result) {
				$.postJSON("${pageContext.request.contextPath}/api/assignments/" + token + "/missing", 
					null, onMissingSuccess, onMissingFail);
			}
		});
	}
    
    /** Called on successful missing report */
    function onMissingSuccess() {
    	devicesDS.read();
    }
    
	/** Handle failed missing report */
	function onMissingFail(jqXHR, textStatus, errorThrown) {
		handleError(jqXHR, "Unable to mark assignment as missing.");
	}
	
	/** Called on succesfull device assignment */
	function onAssignmentAdded() {
		devicesDS.read();
	}
	
	/** Called when a device has been successfully created */
	function onDeviceCreated() {
    	devicesDS.read();
	}
	
	/** Validate fields for update */
	function validateForUpdate() {
		$.validity.setup({ outputMode:"label" });
		$.validity.start();

        /** Validate hidden fields */
		$("#du-hardware-id").require();
		$("#du-asset-id").require();
     
		var result = $.validity.end();
		return result.valid;
	}
	
    $(document).ready(function() {
		/** Create AJAX datasource for devices list */
		devicesDS = new kendo.data.DataSource({
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
			template : kendo.template($("#device-entry").html()),
		});
		
		/** Pager for device list */
        $("#pager").kendoPager({
            dataSource: devicesDS
        });
		
		/** Create tab strip for the update dialog */
		updateTabs = $("#du-tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
		
		/** Local source for metadata entries */
		metaDatasource = new kendo.data.DataSource({
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
        $("#du-metadata").kendoGrid({
            dataSource: metaDatasource,
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
		
        /** Handle create dialog */
		$('#btn-add-device').click(function(event) {
			dcOpen(event, onDeviceCreated)
		});
		
        /** Handle update dialog submit */
		$('#du-dialog-submit').click(function(event) {
			event.preventDefault();
			if (!validateForUpdate()) {
				return;
			}
			var hardwareId = $('#du-hardware-id').val();
			var deviceData = {
				"hardwareId": hardwareId, 
				"comments": $('#du-comments').val(), 
				"assetId": $('#du-asset-id').val(), 
				"metadata": metaDatasource.data(),
			}
			$.putJSON("${pageContext.request.contextPath}/api/devices/" + hardwareId, 
					deviceData, onUpdateSuccess, onUpdateFail);
		});
        
        /** Called on successful update */
        function onUpdateSuccess() {
        	$('#du-dialog').modal('hide');
        	devicesDS.read();
        }
        
		/** Handle failed call to update device */
		function onUpdateFail(jqXHR, textStatus, errorThrown) {
			handleError(jqXHR, "Unable to update device.");
		}
   });
</script>

<%@ include file="../includes/bottom.inc"%>