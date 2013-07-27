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

#device-metadata {
	margin-top: 15px;
	margin-bottom: 15px;
}
</style>

<!-- Dialog for create/update -->
<div id="dialog" class="modal hide">
	<div class="modal-header k-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3 id="dialog-header">Create Device</h3>
	</div>
	<div class="modal-body">
		<div id="tabs">
			<ul>
				<li class="k-state-active">Device Details</li>
				<li>Hardware</li>
				<li>Metadata</li>
			</ul>
			<div>
				<form id="general-form" class="form-horizontal" style="padding-top: 20px;">
					<div class="control-group">
						<label class="control-label" for="device-hardware-id">Hardware Id</label>
						<div class="controls">
							<input type="text" id="device-hardware-id" name="hardwareId" class="input-xlarge">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="device-comments">Comments</label>
						<div class="controls">
							<textarea id="device-comments" name="comments" class="input-xlarge" style="height: 10em;"></textarea>
						</div>
					</div>
				</form>
			</div>
			<div>
				<form id="hardware-form" class="form-horizontal form-search" style="padding-top: 20px;">
					<div class="control-group">
						<label class="control-label" for="hardware-search">Choose Hardware Type</label>
						<div class="controls">
							<div class="input-append">
	    						<input class="input-xlarge" id="hardware-search" type="text">
								<span class="add-on"><i class="icon-search"></i></span>
	    					</div>
	    				</div>
	    			</div>	
	    		</form>		
				<div id="hardware-matches" style="height: 200px; overflow: auto;"></div>
    		</div>
			<div>
				<div id="device-metadata"></div>
            </div>
		</div>
	</div>
	<input id="dialog-mode" type="hidden" value="create" />
	<div class="modal-footer">
		<a href="javascript:void(0)" class="btn" data-dismiss="modal">Cancel</a> 
		<a id="dialog-submit" href="javascript:void(0)" class="btn btn-primary">Create</a>
	</div>
</div>

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

<%@ include file="../includes/asset-templates.inc"%>

<script>
	/** Reference for metadata datasource */
	var metaDatasource;
	
	/** Reference for hardware search datasource */
	var hardwareDS;
	
	/** Used for delayed submit on search */
	var timeout;
	
	/** Called when hardware search criteria has changed */
	function onHardwareSearchCriteriaUpdated() {
		var criteria = $('#hardware-search').val();
		var url = "${pageContext.request.contextPath}/api/assets/hardware?criteria=" + criteria;
		hardwareDS.transport.options.read.url = url;
		hardwareDS.read();
	}
    
    /** Clear all dialog fields */
    function clearDialog() {
    	$('#general-form')[0].reset();
    }
	
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
		
		/** Create the tab strip */
		$("#tabs").kendoTabStrip({
			animation: false
		});
		
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
        $("#device-metadata").kendoGrid({
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
		
		/** Create AJAX datasource for hardware search */
		hardwareDS = new kendo.data.DataSource({
			autoBind: false,
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/assets/hardware",
					dataType : "json",
				}
			},
			schema : {
				data: "results",
				total: "numResults",
			},
			pageSize: 10
		});
		
		/** Create the hardware match list */
		$("#hardware-matches").kendoListView({
			dataSource : hardwareDS,
			selectable : "single",
			template : kendo.template($("#hardware-asset-entry").html())
		});
		
		/** Update hardware search datasource based on entered criteria */
		$("#hardware-search").bind("change paste keyup", function() {
		    window.clearTimeout(timeout);
		    timeout = window.setTimeout(onHardwareSearchCriteriaUpdated, 300); 
		});
		
        /** Handle create dialog */
		$('#btn-add-device').click(function(event) {
			clearDialog();
			$('#dialog-header').html("Create Device");
			$('#dialog-submit').html("Create");
			$('#dialog').modal('show');
			$('#dialog-mode').val("create");
			metaDatasource.data(new Array());
		});
    });
</script>

<%@ include file="../includes/bottom.inc"%>