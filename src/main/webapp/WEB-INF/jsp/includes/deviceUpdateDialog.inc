<style>
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
</style>

<!-- Dialog for device update -->
<div id="du-dialog" class="modal hide">
	<div class="modal-header k-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>Update Device</h3>
	</div>
	<div class="modal-body">
		<div id="du-tabs">
			<ul>
				<li class="k-state-active">Device Details</li>
				<li>Metadata</li>
			</ul>
			<div>
				<div style="padding-top: 20px;">
					<div id="du-static-header"></div>
				</div>
				<form id="du-general-form" class="form-horizontal" style="padding-top: 10px;">
					<div class="control-group">
						<label class="control-label" for="du-comments">Comments</label>
						<div class="controls">
							<textarea id="du-comments" class="input-xlarge" style="height: 10em;"></textarea>
						</div>
					</div>
					<input type="hidden" id="du-hardware-id"/>
					<input type="hidden" id="du-asset-id"/>
				</form>
			</div>
			<div>
				<div id="du-metadata"></div>
            </div>
		</div>
	</div>
	<div class="modal-footer">
		<a href="javascript:void(0)" class="btn" data-dismiss="modal">Cancel</a> 
		<a id="du-dialog-submit" href="javascript:void(0)" class="btn btn-primary">Save</a>
	</div>
</div>

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

<script>
	/** Function called when dialog is submitted */
	var duSubmitCallback;
	
	/** Provides external access to tabs */
	var duTabs;
	
	/** Metadata datasource */
	var duMetadataDS;
	
    $(document).ready(function() {
		/** Create tab strip for the update dialog */
		duTabs = $("#du-tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
		
		/** Local source for metadata entries */
		duMetadataDS = new kendo.data.DataSource({
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
            dataSource: duMetadataDS,
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
		
        /** Handle update dialog submit */
		$('#du-dialog-submit').click(function(event) {
			event.preventDefault();
			if (!duValidate()) {
				return;
			}
			var hardwareId = $('#du-hardware-id').val();
			var deviceData = {
				"hardwareId": hardwareId, 
				"comments": $('#du-comments').val(), 
				"assetId": $('#du-asset-id').val(), 
				"metadata": duMetadataDS.data(),
			}
			$.putJSON("${pageContext.request.contextPath}/api/devices/" + hardwareId, 
					deviceData, onUpdateSuccess, onUpdateFail);
		});
        
        /** Called on successful update */
        function onUpdateSuccess() {
        	$('#du-dialog').modal('hide');
			if (duSubmitCallback != null) {
				duSubmitCallback();
			}
        }
        
		/** Handle failed call to update device */
		function onUpdateFail(jqXHR, textStatus, errorThrown) {
			handleError(jqXHR, "Unable to update device.");
		}
    });
	
	/** Validate fields for update */
	function duValidate() {
		$.validity.setup({ outputMode:"label" });
		$.validity.start();

        /** Validate hidden fields */
		$("#du-hardware-id").require();
		$("#du-asset-id").require();
     
		var result = $.validity.end();
		return result.valid;
	}
	
	/** Called when edit button on the list entry is pressed */
	function duOpen(hardwareId, callback) {
		// Function called on submit.
		duSubmitCallback = callback;
		
		// Get latest device data for hardware id.
		$.getJSON("${pageContext.request.contextPath}/api/devices/" + hardwareId, 
			duUpdateGetSuccess, duUpdateGetFailed);
	}
    
    /** Called on successful device load request */
    function duUpdateGetSuccess(data, status, jqXHR) {
    	$('#du-general-form')[0].reset();
		
		var template = kendo.template($("#device-update-static").html());
		$('#du-static-header').html(template(data));
		$('#du-hardware-id').val(data.hardwareId);
		$('#du-comments').val(data.comments);
		$('#du-asset-id').val(data.deviceAsset.id);
		duMetadataDS.data(data.metadata);
		
		duTabs.select(0);
		
		$('#du-dialog').modal('show');
    }
    
	/** Handle error on getting site */
	function duUpdateGetFailed(jqXHR, textStatus, errorThrown) {
		handleError(jqXHR, "Unable to get device for update.");
	}
</script>