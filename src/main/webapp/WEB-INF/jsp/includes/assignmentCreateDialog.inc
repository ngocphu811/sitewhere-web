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
						<label class="control-label" for="ac-site-dropdown">Site</label>
						<div class="controls">
							<div id="ac-site-dropdown"></div>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="ac-asset-type-dropdown">Asset Type</label>
						<div class="controls">
							<div id="ac-asset-type-dropdown"></div>
						</div>
					</div>
					<div id="ac-asset-type-forms">
						<div class="control-group" id="ac-asset-hardware-panel">
							<label class="control-label" for="ac-site-dropdown">Choose Hardware</label>
							<div class="controls">
								<div class="input-append">
		    						<input class="input-xlarge" id="ac-hardware-search" type="text">
									<span class="add-on"><i class="icon-search"></i></span>
		    					</div>
								<div id="ac-hardware-matches" class="sw-form-search-results"
									style="height: 120px;"></div>
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
							</div>
						</div>
						<div class="control-group hide" id="ac-asset-unassociated-panel"></div>
					</div>
					<input type="hidden" id="ac-chosen-asset-id" title="Asset"/>
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
	/** Provides external access to tabs */
	var acTabs;
	
	/** Metadata datasource */
	var acMetadataDS;
	
	/** Datasource for hardware assets */
	var acHardwareDS;
	
	/** Datasource for person assets */
	var acPersonDS;
	
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

		$("#ac-site-dropdown").kendoDropDownList({
			dataTextField: "name",
			dataValueField: "token",
			dataSource: acSitesDS,
        });
		
		/** Available asset types shown in dropdown */
	    var assetTypes = [
			{ text: "Hardware", value: "Hardware" },
			{ text: "Person", value: "Person" },
			{ text: "Unassociated", value: "Unassociated" },
		];

    	// create DropDownList from input HTML element
    	$("#ac-asset-type-dropdown").kendoDropDownList({
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
		$("#ac-hardware-matches").kendoListView({
			dataSource : acHardwareDS,
			selectable : "single",
			template : kendo.template($("#hardware-asset-entry").html()),
			change: null
		});
		
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
		$("#ac-person-matches").kendoListView({
			dataSource : acPersonDS,
			selectable : "single",
			template : kendo.template($("#person-asset-entry").html()),
			change: null
		});
		
		/** Update person search datasource based on entered criteria */
		$("#ac-person-search").bind("change paste keyup", function() {
		    window.clearTimeout(acTimeout);
		    acTimeout = window.setTimeout(acPersonSearchCriteriaUpdated, 300); 
		});
		
		/** Create tab strip for the update dialog */
		acTabs = $("#ac-tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
    });
	
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
		var assetType = $("#ac-asset-type-dropdown").val();
		var panelName = "ac-asset-" + assetType.toLowerCase() + "-panel";
		$("#ac-asset-type-forms").children().each(function(i) {
			if (panelName == $(this).attr("id")) {
				$(this).removeClass("hide");
			} else if (!$(this).hasClass("hide")) {
				$(this).addClass("hide");
			}
		});
	}
	
	/** Open the dialog */
	function acOpen(e, hardwareId) {
		var event = e || window.event;
		event.stopPropagation();
		$('#ac-general-form')[0].reset();
		$('#ac-hardware-id').val(hardwareId);
		$('#ac-dialog').modal('show');
		acMetadataDS.data(new Array());
   	
		// Select first tab.
		acTabs.select(0);
	}
</script>