<!-- Dialog for assigning a device -->
<div id="ac-dialog" class="modal hide">
	<div class="modal-header k-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3 id="dialog-header">Assign Device</h3>
	</div>
	<div class="modal-body">
		<div id="ac-tabs">
			<ul>
				<li class="k-state-active">Assignment Details</li>
				<li>Metadata</li>
			</ul>
			<div>
				<form id="ac-general-form" class="form-horizontal" style="padding-top: 20px;">
					<div class="control-group">
						<label class="control-label" for="ac-hardware-id">Hardware Id</label>
						<div class="controls">
							<input type="text" id="ac-hardware-id" title="Hardware id" class="input-xlarge">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="ac-site-token">Site</label>
						<div class="controls">
							<input id="ac-site-token"/>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="ac-asset-type-dropdown">Asset Type</label>
						<div class="controls">
							<input id="ac-asset-type"/>
						</div>
					</div>
					<div id="ac-asset-type-forms">
						<div class="control-group" id="ac-asset-hardware-panel">
							<label class="control-label" for="ac-hardware-search">Choose Hardware</label>
							<div class="controls">
								<div class="input-append">
		    						<input class="input-xlarge" id="ac-hardware-search" type="text">
									<span class="add-on"><i class="icon-search"></i></span>
		    					</div>
								<div id="ac-hardware-matches" class="sw-form-search-results"
									style="height: 120px;"></div>
								<input type="hidden" id="ac-hardware-asset-id" title="Asset"/>
							</div>
						</div>
						<div class="control-group hide" id="ac-asset-person-panel">
							<label class="control-label" for="ac-person-search">Choose Person</label>
							<div class="controls">
								<div class="input-append">
		    						<input class="input-xlarge" id="ac-person-search" type="text">
									<span class="add-on"><i class="icon-search"></i></span>
		    					</div>
								<div id="ac-person-matches" class="sw-form-search-results"
									style="height: 120px;"></div>
								<input type="hidden" id="ac-person-asset-id" title="Asset"/>
							</div>
						</div>
						<div class="control-group hide" id="ac-asset-unassociated-panel"></div>
					</div>
				</form>
			</div>
			<div>
				<div id="ac-metadata"></div>
            </div>
		</div>
	</div>
	<div class="modal-footer">
		<a href="javascript:void(0)" class="btn" data-dismiss="modal">Cancel</a> 
		<a id="ac-submit" href="javascript:void(0)" class="btn btn-primary">Assign</a>
	</div>
</div>

<!-- Script support for assignment create dialog -->
<script>
	/** Function called when dialog is submitted */
	var acSubmitCallback;

	/** Provides external access to tabs */
	var acTabs;
	
	/** Metadata datasource */
	var acMetadataDS;
	
	/** Datasource for hardware assets */
	var acHardwareDS;
	
	/** Datasource for person assets */
	var acPersonDS;
	
	/** Hardware matches list */
	var acHardwareMatches;
	
	/** Person matches list */
	var acPersonMatches;
	
	/** Used for delayed submit on search */
	var acTimeout;
	var acLastSearch;

	$(document).ready(function() {
		
		/** Datasource for metadata entries */
		acMetadataDS = new kendo.data.DataSource({
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
        $("#ac-metadata").kendoGrid({
            dataSource: acMetadataDS,
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
		
		/** Datasource for sites dropdown */
		var acSitesDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/sites",
					dataType : "json",
				}
			},
			schema : {
				data: "results",
				total: "numResults",
			},
		});

		$("#ac-site-token").kendoDropDownList({
			dataTextField: "name",
			dataValueField: "token",
			dataSource: acSitesDS,
        });
		
		$("#ac-site-token").bind("change paste keyup", function() {
			alert("Changed to " + $("#ac-site-token").val());
		});
		
		/** Available asset types shown in dropdown */
	    var assetTypes = [
			{ text: "Hardware", value: "Hardware" },
			{ text: "Person", value: "Person" },
			{ text: "Unassociated", value: "Unassociated" },
		];

    	// create DropDownList from input HTML element
    	$("#ac-asset-type").kendoDropDownList({
    		dataTextField: "text",
    		dataValueField: "value",
    	    dataSource: assetTypes,
    	    index: 0,
    	    change: acAssetTypeChanged
    	});
		
		/** Create AJAX datasource for hardware search */
		acHardwareDS = new kendo.data.DataSource({
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
		});
		
		/** Create the hardware match list */
		acHardwareMatches = $("#ac-hardware-matches").kendoListView({
			dataSource : acHardwareDS,
			selectable : "single",
			template : kendo.template($("#hardware-asset-entry").html()),
			change: acHardwareAssetChosen
		}).data("kendoListView");
		
		/** Update hardware search datasource based on entered criteria */
		$("#ac-hardware-search").bind("change paste keyup", function() {
		    window.clearTimeout(acTimeout);
		    acTimeout = window.setTimeout(acHardwareSearchCriteriaUpdated, 300); 
		});
		
		/** Create AJAX datasource for person search */
		acPersonDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/assets/people",
					dataType : "json",
				}
			},
			schema : {
				data: "results",
				total: "numResults",
			},
		});
		
		/** Create the person match list */
		acPersonMatches = $("#ac-person-matches").kendoListView({
			dataSource : acPersonDS,
			selectable : "single",
			template : kendo.template($("#person-asset-entry").html()),
			change: acPersonAssetChosen
		}).data("kendoListView");
		
		/** Update person search datasource based on entered criteria */
		$("#ac-person-search").bind("change paste keyup", function() {
		    window.clearTimeout(acTimeout);
		    acTimeout = window.setTimeout(acPersonSearchCriteriaUpdated, 300); 
		});
		
		/** Create tab strip for the update dialog */
		acTabs = $("#ac-tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
		
        /** Handle dialog submit */
		$('#ac-submit').click(function(event) {
			event.preventDefault();
			if (!acValidate()) {
				return;
			}
	        
	        var assetType = $("#ac-asset-type").val();
	        var assetId;
	        if (assetType == "Hardware") {
	        	assetId = $('#ac-hardware-asset-id').val();
	        } else if (assetType == "Person") {
	        	assetId = $('#ac-person-asset-id').val();
	        }
	        
			var assignmentData = {
				"deviceHardwareId": $('#ac-hardware-id').val(), 
				"siteToken": $('#ac-site-token').val(), 
				"assetType": $('#ac-asset-type').val(), 
				"assetId": assetId, 
				"metadata": acMetadataDS.data(),
			}
			$.postJSON("${pageContext.request.contextPath}/api/assignments", 
					assignmentData, onCreateSuccess, onCreateFail);
		});
        
        /** Called on successful create */
        function onCreateSuccess() {
        	$('#ac-dialog').modal('hide');
			if (acSubmitCallback != null) {
				acSubmitCallback();
			}
        }
        
		/** Handle failed call to create device */
		function onCreateFail(jqXHR, textStatus, errorThrown) {
			handleError(jqXHR, "Unable to assign device.");
		}
    });
	
	/** Validate the dialog */
	function acValidate() {
		$.validity.setup({ outputMode:"label" });
		$.validity.start();

        /** Validate main form */
		$("#ac-hardware-id").require();

        /** Verify that a site was chosen */
		$("#ac-site-token").require();

        /** Verify that a site was chosen */
		$("#ac-asset-type").require();
        
        var assetType = $("#ac-asset-type").val();
        if (assetType == "Hardware") {
        	$('#ac-hardware-asset-id').require();
        } else if (assetType == "Person") {
        	$('#ac-person-asset-id').require();
        }
      
		var result = $.validity.end();
		return result.valid;
	}
	
	/** Called when hardware search criteria has changed */
	function acHardwareSearchCriteriaUpdated() {
		var criteria = $('#ac-hardware-search').val();
		if (criteria != acLastSearch) {
			var url = "${pageContext.request.contextPath}/api/assets/hardware?criteria=" + criteria;
			acHardwareDS.transport.options.read.url = url;
			acHardwareDS.read();
		}
		acLastSearch = criteria;
	}
	
	/** Called when hardware search criteria has changed */
	function acPersonSearchCriteriaUpdated() {
		var criteria = $('#ac-person-search').val();
		if (criteria != acLastSearch) {
			var url = "${pageContext.request.contextPath}/api/assets/people?criteria=" + criteria;
			acPersonDS.transport.options.read.url = url;
			acPersonDS.read();
		}
		acLastSearch = criteria;
	}
	
	/** Called to swap panel when asset type dropdown value changes */
	function acAssetTypeChanged() {
		var assetType = $("#ac-asset-type").val();
		var panelName = "ac-asset-" + assetType.toLowerCase() + "-panel";
		$("#ac-asset-type-forms").children().each(function(i) {
			if (panelName == $(this).attr("id")) {
				$(this).removeClass("hide");
			} else if (!$(this).hasClass("hide")) {
				$(this).addClass("hide");
			}
		});
	}
	
	/** Called when a hardware asset is chosen from the list */
	function acHardwareAssetChosen() {
		var listView = acHardwareDS.view();
		var selected = $.map(this.select(), function(item) {
			return listView[$(item).index()];
		});

		if (selected.length > 0) {
			$('#ac-hardware-asset-id').val(selected[0].id);
		} else {
			$('#ac-hardware-asset-id').val("");
		}	
	}
	
	/** Called when a hardware asset is chosen from the list */
	function acPersonAssetChosen() {
		var listView = acPersonDS.view();
		var selected = $.map(this.select(), function(item) {
			return listView[$(item).index()];
		});

		if (selected.length > 0) {
			$('#ac-person-asset-id').val(selected[0].id);
		} else {
			$('#ac-person-asset-id').val("");
		}		
	}
	
	/** Open the dialog */
	function acOpen(e, hardwareId, callback) {
		var event = e || window.event;
		event.stopPropagation();
		
		$('#ac-general-form')[0].reset();
		$('#ac-hardware-id').val(hardwareId);
		acMetadataDS.data(new Array());
		
		// Reset list selections.
		$('#ac-hardware-asset-id').val("");
		acHardwareMatches.clearSelection();
		$('#ac-person-asset-id').val("");
		acPersonMatches.clearSelection();
		$("#ac-asset-type").val("Hardware");
		acAssetTypeChanged();
   	
		// Select first tab.
		acTabs.select(0);
		
		// Function called on submit.
		acSubmitCallback = callback;
		
		alert("Initial token " + $("#ac-site-token").val());
		
		$('#ac-dialog').modal('show');
	}
</script>