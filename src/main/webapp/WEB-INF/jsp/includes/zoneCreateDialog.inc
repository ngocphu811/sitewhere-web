<style>
.sw-map {
	height: 270px;
	width: 500px;
	border: 1px solid #dddddd;
}

.sw-name-label {
	display: inline-block;
	padding-right: 5px;
}
</style>

<!-- Dialog for creating a device -->
<div id="zc-dialog" class="modal hide">
	<div class="modal-header k-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>Create Zone</h3>
	</div>
	<div class="modal-body">
		<div id="zc-tabs" style="clear: both;">
			<ul>
				<li class="k-state-active">Zone Settings</li>
				<li>Metadata</li>
			</ul>
			<div>
				<div id="zc-map" class="sw-map"></div>
				<div style="padding-top: 3px; width: 500px;">
					<label for="zc-zone-name" class="sw-name-label">Zone Name:</label>
					<input id="zc-zone-name" type="text" style="padding: 0px 5px; margin: 0; width: 227px;"/>
					<label for="zc-border-picker" class="sw-name-label" style="margin-left: 10px;">Border:</label>
					<input type="text" id="zc-border-picker"/>
					<label for="zc-fill-picker" class="sw-name-label" style="margin-left: 10px;">Fill:</label>
					<input type="text" id="zc-fill-picker"/>
				</div>
			</div>
			<div>
				<div id="zc-metadata"></div>
            </div>
		</div>
	</div>
	<div class="modal-footer">
		<a href="javascript:void(0)" class="btn" data-dismiss="modal">Cancel</a> 
		<a id="zc-dialog-submit" href="javascript:void(0)" class="btn btn-primary">Create</a>
	</div>
</div>

<!-- Script support for zone create dialog -->
<script>
	/** Site that provides map metadata */
	var zcSite;
	
	/** Function called when dialog is submitted */
	var zcSubmitCallback;

	/** Provides external access to tabs */
	var zcTabs;
	
	/** Metadata datasource */
	var zcMetadataDS;
	
	/** Map reference */
	var zcMap;
	
	/** Leaflet.draw control */
	var zcDrawControl;
	
	/** Layer for existing zones */
	var zcZonesLayer;
	
	/** Layer for new zone */
	var zcNewZoneLayer;

	$(document).ready(function() {
		
		/** Create tab strip */
		zcTabs = $("#zc-tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
		
		/** Local source for metadata entries */
		zcMetadataDS = new kendo.data.DataSource({
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
        $("#zc-metadata").kendoGrid({
            dataSource: zcMetadataDS,
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
		
        $("#zc-border-picker").spectrum({
            color: "#000",
            showButtons: false,
            change: function(color) {
            	zcUpdateDrawControls();
            }
        });
        $("#zc-fill-picker").spectrum({
            color: "#f00",
            showAlpha: true,
            showButtons: false,
            change: function(color) {
            	zcUpdateDrawControls();
            }
        });
		
        /** Handle create dialog submit */
		$('#zc-dialog-submit').click(function(event) {
			event.preventDefault();
			var name = $("#zc-zone-name").val();
			if (!(name && name.length > 0)) {
				bootbox.alert("Zone name must be specified.");
				return;
			}
			if (!zcNewZoneLayer) {
				bootbox.alert("No zone has been defined. Use the map tools to choose the zone coordinates.");
				return;
			}
			var latLongs = zcNewZoneLayer.getLatLngs();
			var coords = [];
			for (var index = 0; index < latLongs.length; index++) {
				coords.push({"latitude": latLongs[index].lat, "longitude": latLongs[index].lng, "elevation": 0})
			}
			var zoneData = {
				"borderColor": $("#zc-border-picker").spectrum("get").toHexString(), 
				"fillColor": $("#zc-fill-picker").spectrum("get").toHexString(), 
				"opacity": $("#zc-fill-picker").spectrum("get").alpha,
				"name": $("#zc-zone-name").val(),
				"coordinates": coords,
				"metadata": zcMetadataDS.data(),
			}
			$.postJSON("${pageContext.request.contextPath}/api/sites/" + zcSite.token + "/zones", 
					zoneData, onCreateSuccess, onCreateFail);
		});
        
        /** Called on successful create */
        function onCreateSuccess() {
        	$('#zc-dialog').modal('hide');
			if (zcSubmitCallback != null) {
				zcSubmitCallback();
			}
        }
        
		/** Handle failed call to create device */
		function onCreateFail(jqXHR, textStatus, errorThrown) {
			handleError(jqXHR, "Unable to create zone.");
		}
    });
	
	/** Validate everything */
	function zcValidate() {
		$.validity.setup({ outputMode:"label" });
		$.validity.start();
      
		var result = $.validity.end();
		return result.valid;
	}
	
	/** Updates draw colors from color pickers */
	function zcUpdateDrawControls() {
		if (zcDrawControl) {
			zcDrawControl.removeFrom(zcMap);
		}
		zcDrawControl = null;
		var borderColor = $("#zc-border-picker").spectrum("get").toHexString();
		var fillColor = $("#zc-fill-picker").spectrum("get").toHexString();
		var fillAlpha = $("#zc-fill-picker").spectrum("get").alpha;
		zcDrawControl = swEnableMapDrawing(zcMap, borderColor, fillColor, fillAlpha);
		
		if (zcNewZoneLayer) {
			zcNewZoneLayer.setStyle({color: borderColor, opacity: 1, fillColor: fillColor, fillOpacity: fillAlpha});
		}
	}
	
	/** Open the dialog */
	function zcOpen(site, callback) {
		// Store site info.
		zcSite = site;
		zcNewZoneLayer = null;
		zcDrawControl = null;
		
		// Creates map if not already created, then inits from site settings.
		if (zcMap) {
			zcMap.remove();
		}
		zcMap = L.map('zc-map');
		zcUpdateDrawControls();
		zcMap.on('draw:drawstart', function (e) {
			if (zcNewZoneLayer) {
				zcMap.removeLayer(zcNewZoneLayer);
			}
		});		
		zcMap.on('draw:created', function (e) {
			zcNewZoneLayer = e.layer;
			zcMap.addLayer(zcNewZoneLayer);
		});		
		swInitMapForSite(zcMap, zcSite);
		
		// Reset form and metadata.
		$('#zc-zone-name').val("");
		zcMetadataDS.data(new Array());
    	
    	// Select first tab.
		zcTabs.select(0);
		
		// Function called on submit.
		zcSubmitCallback = callback;
		
		// Clear old validation errors and show dialog.
		$.validity.clear();
		$('#zc-dialog').modal('show');
		zcMap.invalidateSize();
	}
</script>