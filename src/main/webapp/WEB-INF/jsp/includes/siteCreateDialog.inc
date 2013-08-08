
<!-- Dialog for create/update -->
<div id="sc-dialog" class="modal hide">
	<div class="modal-header k-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3 id="sc-dialog-header">Create Site</h3>
	</div>
	<div class="modal-body">
		<div id="sc-tabs">
			<ul>
				<li class="k-state-active">Site Details</li>
				<li>Map Information</li>
				<li>Metadata</li>
			</ul>
			<div>
				<form id="general-form" class="form-horizontal" style="padding-top: 20px;">
					<div class="control-group">
						<label class="control-label" for="gen-site-name">Site Name</label>
						<div class="controls">
							<input type="text" id="gen-site-name" class="input-xlarge" title="Site name">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="gen-site-desc">Site
							Description</label>
						<div class="controls">
							<textarea id="gen-site-desc" name="siteDesc" class="input-xlarge" style="height: 120px;"></textarea>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="gen-site-image-url">Image URL</label>
						<div class="controls">
							<input type="text" id="gen-site-image-url" name="siteImageUrl" class="input-xlarge">
						</div>
					</div>
				</form>
			</div>
			<div>
				<form class="form-horizontal" style="padding-top: 15px;">
					<div class="control-group" style="border-bottom: 1px solid #eeeeee; padding-bottom: 10px;">
						<label class="control-label" for="sc-map-type">Map Type</label>
						<div class="controls">
							<input id="sc-map-type"/>
						</div>
					</div>
				</form>
				<div id="map-type-forms">
					<form id="mapquest" class="form-horizontal">
						<div class="control-group">
							<label class="control-label" for="mq-center-latitude">Center Latitude</label>
							<div class="controls">
								<input type="text" id="mq-center-latitude" class="input-large">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="mq-center-longitude">Center Longitude</label>
							<div class="controls">
								<input type="text" id="mq-center-longitude" class="input-large">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="mq-scale">Scale</label>
							<div class="controls">
								<input type="text" id="mq-scale" class="input-large">
							</div>
						</div>
					</form>
					<form id="geoserver" class="form-horizontal hide">
						<div class="control-group">
							<label class="control-label" for="gs-base-url">GeoServer Base URL</label>
							<div class="controls">
								<input type="text" id="gs-base-url" title="GeoServer base url" class="input-xlarge">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="gs-layer-name">GeoServer Layer</label>
							<div class="controls">
								<input type="text" id="gs-layer-name" title="Layer name" class="input-xlarge">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="gs-center-latitude">Center Latitude</label>
							<div class="controls">
								<input type="text" id="gs-center-latitude" class="input-large">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="gs-center-longitude">Center Longitude</label>
							<div class="controls">
								<input type="text" id="gs-center-longitude" class="input-large">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="gs-scale">Scale</label>
							<div class="controls">
								<input type="text" id="gs-scale" class="input-large">
							</div>
						</div>
					</form>
				</div>
			</div>
			<div>
				<div id="sc-metadata"></div>
            </div>
		</div>
	</div>
	<input id="site-token" type="hidden" value="" />
	<div class="modal-footer">
		<a href="javascript:void(0)" class="btn" data-dismiss="modal">Cancel</a> 
		<a id="sc-dialog-submit" href="javascript:void(0)" class="btn btn-primary">Create</a>
	</div>
</div>

<!-- Script support for site create/update dialog -->
<script>
	/** Function called when dialog is submitted */
	var scSubmitCallback;
	
	/** Pointer to tabs instance */
	var scTabs;
	
	/** Reference for sites datasource */
	var scSitesDS;
	
	/** Reference for metadata datasource */
	var scMetadataDS;
	
	/** Available map types shown in dropdown */
    var scMapTypes = [
		{ text: "MapQuest World Map", value: "mapquest" },
		{ text: "GeoServer Layer", value: "geoserver" },
	];

	$(document).ready(function() {
		
		/** Create the tab strip */
		scTabs = $("#sc-tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
		
		/** Local source for metadata entries */
		scMetadataDS = new kendo.data.DataSource({
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
        $("#sc-metadata").kendoGrid({
            dataSource: scMetadataDS,
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

    	// create DropDownList from input HTML element
    	$("#sc-map-type").kendoDropDownList({
    		dataTextField: "text",
    		dataValueField: "value",
    	    dataSource: scMapTypes,
    	    index: 0,
    	    change: scMapTypeChanged
    	});
		
        /** Handle dialog submit */
		$('#sc-dialog-submit').click(function(event) {
			event.preventDefault();
			if (!scValidate()) {
				return;
			}
			var siteToken = $('#site-token').val();
			var mapMetadata = scBuildMapMetadata();
			var siteData = {
				"name": $('#gen-site-name').val(), 
				"description": $('#gen-site-desc').val(), 
				"imageUrl": $('#gen-site-image-url').val(), 
				"metadata": scMetadataDS.data(),
				"mapType": $('#sc-map-type').val(), 
				"mapMetadata": mapMetadata,
			}
			if (siteToken == "") {
				$.postJSON("${pageContext.request.contextPath}/api/sites", 
						siteData, onSuccess, onCreateFail);
			} else {
				$.putJSON("${pageContext.request.contextPath}/api/sites/" + siteToken, 
						siteData, onSuccess, onUpdateFail);
			}
		});
        
        /** Called on successful create/update */
        function onSuccess() {
        	$('#sc-dialog').modal('hide');
			if (scSubmitCallback != null) {
				scSubmitCallback();
			}
        }
        
		/** Handle failed call to create site */
		function onCreateFail(jqXHR, textStatus, errorThrown) {
			handleError(jqXHR, "Unable to create site.");
		}
        
		/** Handle failed call to update site */
		function onUpdateFail(jqXHR, textStatus, errorThrown) {
			handleError(jqXHR, "Unable to update site.");
		}
    });
	
	/** Validate everything */
	function scValidate() {
		$.validity.setup({ outputMode:"label" });
		$.validity.start();

        /** Validate main form */
		$("#gen-site-name").require();
        
		var selectedMapType = $("#sc-map-type").val();
		
        /** Validate geoserver form */
		if (selectedMapType == "geoserver") {
			$("#gs-base-url").require();
			$("#gs-layer-name").require();
		}
      
		var result = $.validity.end();
		return result.valid;
	}

	/** Open the site create dialog */
	function scOpen(e, callback) {
		scClearDialog();
		$('#sc-dialog-header').html("Create Site");
		$('#sc-dialog-submit').html("Create");
		$('#site-token').val("");
		scMetadataDS.data(new Array());
		scTabs.select(0);
		
		// Function called on submit.
		scSubmitCallback = callback;
		
		$.validity.clear();
		$('#sc-dialog').modal('show');
	}
	
	/** Called to load the given site and open it for edit */
	function suOpen(siteToken, callback) {
		// Function called on submit.
		scSubmitCallback = callback;
		
		// Get site for edit.
		$.getJSON("${pageContext.request.contextPath}/api/sites/" + siteToken, 
				suSiteGetSuccess, suSiteGetFailed);
	}
    
    /** Called on successful site load request */
    function suSiteGetSuccess(data, status, jqXHR) {
		scClearDialog();
		$('#sc-dialog-header').html("Edit Site");
		$('#sc-dialog-submit').html("Save");
		$('#gen-site-name').val(data.name);
		$('#gen-site-desc').val(data.description);
		$('#gen-site-image-url').val(data.imageUrl);
		$('#site-token').val(data.token);
		scMetadataDS.data(data.metadata);
		scSelectMapType(data.mapType);
		scLoadMapFormFromMetadata(data);
		scTabs.select(0);
		
		$.validity.clear();
		$('#sc-dialog').modal('show');
    }
    
	/** Handle error on getting site */
	function suSiteGetFailed(jqXHR, textStatus, errorThrown) {
		handleError(jqXHR, "Unable to load site for edit.");
	}
    
    /** Based on map type, load fields into proper form */
    function scLoadMapFormFromMetadata(data) {
    	var metadata = data.mapMetadata.metadata;
    	var lookup = {};
    	for (var i = 0, len = metadata.length; i < len; i++) {
    	    lookup[metadata[i].name] = metadata[i];
    	}
    	
    	if (data.mapType == "mapquest") {
    		$('#mq-center-latitude').val(scGetMetadataValue(lookup, 'centerLatitude'));
    		$('#mq-center-longitude').val(scGetMetadataValue(lookup, 'centerLongitude'));
    		$('#mq-scale').val(scGetMetadataValue(lookup, 'scale'));
    	} else if (data.mapType == "geoserver") {
    		$('#gs-base-url').val(scGetMetadataValue(lookup, 'geoserverBaseUrl'));
    		$('#gs-layer-name').val(scGetMetadataValue(lookup, 'geoserverLayerName'));
    		$('#gs-center-latitude').val(scGetMetadataValue(lookup, 'centerLatitude'));
    		$('#gs-center-longitude').val(scGetMetadataValue(lookup, 'centerLongitude'));
    		$('#gs-scale').val(scGetMetadataValue(lookup, 'scale'));
    	}
    }
    
    /** Pull data from map form and populate metadata */
    function scBuildMapMetadata() {
    	var metadata = [];
		var mapType = $("#sc-map-type").val();
		
		if (mapType == "mapquest") {
			scAddMapMetadataEntry(metadata, 'centerLatitude', $('#mq-center-latitude').val());
			scAddMapMetadataEntry(metadata, 'centerLongitude', $('#mq-center-longitude').val());
			scAddMapMetadataEntry(metadata, 'scale', $('#mq-scale').val());
		} else if (mapType == "geoserver") {
			scAddMapMetadataEntry(metadata, 'geoserverBaseUrl', $('#gs-base-url').val());
			scAddMapMetadataEntry(metadata, 'geoserverLayerName', $('#gs-layer-name').val());
			scAddMapMetadataEntry(metadata, 'centerLatitude', $('#gs-center-latitude').val());
			scAddMapMetadataEntry(metadata, 'centerLongitude', $('#gs-center-longitude').val());
			scAddMapMetadataEntry(metadata, 'scale', $('#gs-scale').val());
		}
		return { "metadata": metadata };
    }
    
    /** Add a single entry into the map metadata */
    function scAddMapMetadataEntry(metadata, name, value) {
    	var entry = {"name": name, "value": value};
    	metadata.push(entry);
    }
    
    /** Gets the value associated with a given field name */
    function scGetMetadataValue(lookup, field) {
    	if (lookup && lookup[field]) {
    		return lookup[field].value;
    	}
    	return "";
    }
    
    /** Clear all dialog fields */
    function scClearDialog() {
    	$('#general-form')[0].reset();
    	$('#mapquest')[0].reset();
    	$('#geoserver')[0].reset();
    }
	
	/** Select the given map type and show its associated panel */
	function scSelectMapType(type) {
		var dropdownlist = $("#sc-map-type").data("kendoDropDownList");
		dropdownlist.value(type);
		scMapTypeChanged();
	}
	
	/** Called when map type dropdown value changes */
	function scMapTypeChanged() {
		var selectedMapType = $("#sc-map-type").val();
		$("#map-type-forms").children().each(function(i) {
			if (selectedMapType == $(this).attr("id")) {
				$(this).removeClass("hide");
			} else if (!$(this).hasClass("hide")) {
				$(this).addClass("hide");
			}
		});
	}
</script>