<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="sitewhere_title" value="Manage Sites" />
<c:set var="sitewhere_section" value="sites" />
<%@ include file="../includes/top.inc"%>

<style>
.sw-site-list {
	border: 0px;
}

.sw-site-list-entry {
	clear: both;
	height: 100px;
	border: 1px solid #dcdcdc;
	padding: 10px;
	margin-bottom: 15px;
	font-size: 10pt;
	text-align: left;
	display: block;
	cursor: pointer;
}

.sw-site-list-entry h1 {
	line-height: 0px;
	font-size: 16pt;
	padding-bottom: 10px;
}

.sw-site-list-entry-logowrapper {
	float: left;
	margin-right: 15px;	
	width: 100px;
	height: 100px;
	background-color: #f0f0f0;
	border: 1px solid #dddddd;
}

.sw-site-list-entry-logo {
	display: block;
	margin-left: auto;
	margin-right: auto;
    max-width: 100px;
    max-height: 100px;
}

.sw-site-list-entry-buttons {
	float: right;
	width: 150px;
	height: 100%;
	padding-left: 10px;
	margin-left: 10px;
	border-left: solid 1px #eeeeee;
	text-align: right;
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
<div class="sw-title-bar content">
	<div class="sw-title-bar-left">
		<ul class="breadcrumb sw-breadcrumb">
			<li><a href="../home">Home</a> <span class="divider">/</span>
			</li>
			<li><a href="#">Sites</a> <span class="divider">/</span>
			</li>
			<li class="active"><c:out value="${sitewhere_title}"/></li>
		</ul>
	</div>
	<h1><c:out value="${sitewhere_title}"/></h1>
	<div class="sw-title-bar-right">
		<a id="btn-add-site" class="btn" href="javascript:void(0)">
			<i class="icon-plus icon-white"></i> Add New Site</a>
	</div>
</div>

<!-- Dialog for create/update -->
<div id="dialog" class="modal hide">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3 id="dialog-header">Create Site</h3>
	</div>
	<div class="modal-body">
		<div id="tabs">
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
							<input type="text" id="gen-site-name" name="siteName" required class="input-xlarge">
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
						<label class="control-label" for="map-type">Map Type</label>
						<div class="controls">
							<input id="map-type"/>
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
								<input type="text" id="gs-base-url" name="baseUrl" required class="input-xlarge">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="gs-layer-name">GeoServer Layer</label>
							<div class="controls">
								<input type="text" id="gs-layer-name" name="layerName" required class="input-xlarge">
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
				<div id="metadataGrid"></div>
            </div>
		</div>
	</div>
	<input id="site-token" type="hidden" value="" />
	<div class="modal-footer">
		<a href="javascript:void(0)" class="btn" data-dismiss="modal">Cancel</a> 
		<a id="dialog-submit" href="javascript:void(0)" class="btn btn-primary">Create</a>
	</div>
</div>

<div id="sites" class="sw-site-list"></div>

<!-- Asset item template -->
<script type="text/x-kendo-tmpl" id="siteEntry">
	<div class="sw-site-list-entry gradient-bg" onclick="onSiteOpenClicked(event, '#:token#')">
		<div class="sw-site-list-entry-logowrapper">
			<img class="sw-site-list-entry-logo" src="#:imageUrl#" width="100"/>
		</div>
		<div class="sw-site-list-entry-buttons">
			<div class="btn-group">
				<a class="btn btn-small btn-primary" title="Edit Site" 
					href="javascript:void(0)" onclick="onSiteEditClicked(event, '#:token#');">
					<i class="icon-pencil icon-white"></i></a>
				<a class="btn btn-small btn-danger" title="Delete Site" 
					href="javascript:void(0)" onclick="onSiteDeleteClicked(event, '#:token#')">
					<i class="icon-remove icon-white"></i></a>
				<a class="btn btn-small btn-success" title="Site Contents" 
					href="javascript:void(0)" onclick="onSiteOpenClicked(event, '#:token#')">
					<i class="icon-chevron-right icon-white"></i></a>
			</div>
		</div>
		<div>
			<h1>#:name#</h1>
			<p>#:description#</p>
		</div>
	</div>
</script>

<!-- Template for each row in metadata table -->
<script id="rowTemplate" type="text/x-kendo-tmpl">
	<tr data-uid="#:data.uid#">
		<td role="gridcell">
			#:data.name#
		</td>
		<td role="gridcell">
			#:data.value#
		</td>
		<td>
			<div class="btn-group">
				<a class="btn btn-small btn-primary" title="Edit Entry" 
					href="javascript:void(0)" onclick="onMetadataEditClicked(this);">
					<i class="icon-pencil icon-white"></i></a>
				<a class="btn btn-small btn-danger" title="Delete Entry" 
					href="javascript:void(0)" onclick="onMetadataEditClicked(this);">
					<i class="icon-remove icon-white"></i></a>
			</div>
		</td>
	</tr>
</script>

<script>
	/** Called when edit button is clicked */
	function onSiteEditClicked(e, siteToken) {
		var event = e || window.event;
		event.stopPropagation();
		$.getJSON("${pageContext.request.contextPath}/api/sites/" + siteToken, 
			onSiteGetSuccess, onSiteGetFailed);
	}
    
    /** Called on successful site load request */
    function onSiteGetSuccess(data, status, jqXHR) {
		clearDialog();
		$('#dialog-header').html("Edit Site");
		$('#dialog-submit').html("Save");
		$('#dialog').modal('show');
		$('#gen-site-name').val(data.name);
		$('#gen-site-desc').val(data.description);
		$('#gen-site-image-url').val(data.imageUrl);
		$('#site-token').val(data.token);
		metaDatasource.data(data.metadata);
		selectMapType(data.mapType);
		loadMapFormFromMetadata(data);
		validateMainForm();
		validateSelectedMapForm();
    }
    
    /** Based on map type, load fields into proper form */
    function loadMapFormFromMetadata(data) {
    	var metadata = data.mapMetadata.metadata;
    	var lookup = {};
    	for (var i = 0, len = metadata.length; i < len; i++) {
    	    lookup[metadata[i].name] = metadata[i];
    	}
    	
    	if (data.mapType == "mapquest") {
    		$('#mq-center-latitude').val(getMetadataValue(lookup, 'centerLatitude'));
    		$('#mq-center-longitude').val(getMetadataValue(lookup, 'centerLongitude'));
    		$('#mq-scale').val(getMetadataValue(lookup, 'scale'));
    	} else if (data.mapType == "geoserver") {
    		$('#gs-base-url').val(getMetadataValue(lookup, 'geoserverBaseUrl'));
    		$('#gs-layer-name').val(getMetadataValue(lookup, 'geoserverLayerName'));
    		$('#gs-center-latitude').val(getMetadataValue(lookup, 'centerLatitude'));
    		$('#gs-center-longitude').val(getMetadataValue(lookup, 'centerLongitude'));
    		$('#gs-scale').val(getMetadataValue(lookup, 'scale'));
    	}
    }
    
    /** Pull data from map form and populate metadata */
    function buildMapMetadata() {
    	var metadata = [];
		var mapType = $("#map-type").val();
		
		if (mapType == "mapquest") {
			addMapMetadataEntry(metadata, 'centerLatitude', $('#mq-center-latitude').val());
			addMapMetadataEntry(metadata, 'centerLongitude', $('#mq-center-longitude').val());
			addMapMetadataEntry(metadata, 'scale', $('#mq-scale').val());
		} else if (mapType == "geoserver") {
			addMapMetadataEntry(metadata, 'geoserverBaseUrl', $('#gs-base-url').val());
			addMapMetadataEntry(metadata, 'geoserverLayerName', $('#gs-layer-name').val());
			addMapMetadataEntry(metadata, 'centerLatitude', $('#gs-center-latitude').val());
			addMapMetadataEntry(metadata, 'centerLongitude', $('#gs-center-longitude').val());
			addMapMetadataEntry(metadata, 'scale', $('#gs-scale').val());
		}
		return { "metadata": metadata };
    }
    
    /** Add a single entry into the map metadata */
    function addMapMetadataEntry(metadata, name, value) {
    	var entry = {"name": name, "value": value};
    	metadata.push(entry);
    }
    
    /** Gets the value associated with a given field name */
    function getMetadataValue(lookup, field) {
    	if (lookup && lookup[field]) {
    		return lookup[field].value;
    	}
    	return "";
    }
    
    /** Clear all dialog fields */
    function clearDialog() {
    	$('#general-form')[0].reset();
    	$('#mapquest')[0].reset();
    	$('#geoserver')[0].reset();
    }
    
	/** Handle error on getting site */
	function onSiteGetFailed(jqXHR, textStatus, errorThrown) {
		var respError = jqXHR.getResponseHeader("X-SiteWhere-Error");
		$('#submitResult').html(createAlertHtml("alert-error", "Edit Failed", 
			"Unable to load site for edit. " + respError));
	}
	
	/** Called when edit button is clicked */
	function onSiteDeleteClicked(e, siteToken) {
		alert("Delete " + siteToken);
		var event = e || window.event;
		event.stopPropagation();
	}
	
	/** Called when edit button is clicked */
	function onSiteOpenClicked(e, siteToken) {
		alert("Open " + siteToken);
		var event = e || window.event;
		event.stopPropagation();
	}
	
	/** Reference for metadata datasource */
	var metaDatasource;
	
	/** Available map types shown in dropdown */
    var mapTypes = [
		{ text: "MapQuest World Map", value: "mapquest" },
		{ text: "GeoServer Layer", value: "geoserver" },
	];
	
	/** Select the given map type and show its associated panel */
	function selectMapType(type) {
		var dropdownlist = $("#map-type").data("kendoDropDownList");
		dropdownlist.value(type);
		onMapTypeChanged();
	}
	
	/** Called when map type dropdown value changes */
	function onMapTypeChanged() {
		var selectedMapType = $("#map-type").val();
		$("#map-type-forms").children().each(function(i) {
			if (selectedMapType == $(this).attr("id")) {
				$(this).removeClass("hide");
			} else if (!$(this).hasClass("hide")) {
				$(this).addClass("hide");
			}
		});
	}
	
	/** Validate the main form */
	function validateMainForm() {
		return $('#general-form').valid();
	}
	
	/** Validate form for the currently selected map type */
	function validateSelectedMapForm() {
		var valid = false;
		var selectedMapType = $("#map-type").val();
		$("#map-type-forms").children().each(function(i) {
			var form = $(this);
			if (selectedMapType == form.attr("id")) {
				valid = valid || form.valid();
			}
		});
		return valid;
	}
	
    $(document).ready(function() {
		/** Create AJAX datasource for sites list */
		var sitesDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/sites",
					dataType : "json",
				}
			},
			schema : {
				data: "results",
				total: "numResults",
				parse:function (response) {
				    $.each(response.results, function (index, item) {
				        if (item.createdDate && typeof item.createdDate === "string") {
				        	item.createdDate = kendo.parseDate(item.createdDate, "yyyy-MM-ddTHH:mm:ss");
				        }
				    });
				    return response;
				}
			},
			pageSize: 10
		});
		

		/** Create the hardware list */
		$("#sites").kendoListView({
			dataSource : sitesDS,
			template : kendo.template($("#siteEntry").html())
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
        $("#metadataGrid").kendoGrid({
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

    	// create DropDownList from input HTML element
    	$("#map-type").kendoDropDownList({
    		dataTextField: "text",
    		dataValueField: "value",
    	    dataSource: mapTypes,
    	    index: 0,
    	    change: onMapTypeChanged
    	});
        
        /** Handle create dialog */
		$('#btn-add-site').click(function(event) {
			clearDialog();
			$('#dialog-header').html("Create Site");
			$('#dialog-submit').html("Create");
			$('#dialog').modal('show');
			$('#site-token').val("");
			metaDatasource.data(new Array());
		});
        
        /** Validation for main form */
		$('#general-form').validate({
			rules: {
				siteName: { required: true },
			},
			highlight: doHighlight,
			success: doSuccess
		});
        
        /** Validation for GeoServer form */
		$('#geoserver').validate({
			rules: {
				baseUrl: { required: true },
				layerName: { required: true },
			},
			highlight: doHighlight,
			success: doSuccess
		});
		
        /** Handle dialog submit */
		$('#dialog-submit').click(function(event) {
			event.preventDefault();
			var mainValid = validateMainForm();
			var mapValid = validateSelectedMapForm();
			if (mainValid && mapValid) {
				var siteToken = $('#site-token').val();
				var mapMetadata = buildMapMetadata();
				var siteData = {
					"name": $('#gen-site-name').val(), 
					"description": $('#gen-site-desc').val(), 
					"imageUrl": $('#gen-site-image-url').val(), 
					"metadata": metaDatasource.data(),
					"mapType": $('#map-type').val(), 
					"mapMetadata": mapMetadata,
				}
				if (siteToken == "") {
					$.postJSON("${pageContext.request.contextPath}/api/sites", 
							siteData, onSuccess, onCreateFail);
				} else {
					$.putJSON("${pageContext.request.contextPath}/api/sites/" + siteToken, 
							siteData, onSuccess, onUpdateFail);
				}
			}
		});
        
        /** Called on successful create/update */
        function onSuccess() {
        	$('#dialog').modal('hide');
        	sitesDS.read();
        }
        
		/** Handle failed call to create site */
		function onCreateFail(jqXHR, textStatus, errorThrown) {
			var respError = jqXHR.getResponseHeader("X-SiteWhere-Error");
			$('#submitResult').html(createAlertHtml("alert-error", "Create Failed", 
				"Site was not created. " + respError));
		}
        
		/** Handle failed call to update site */
		function onUpdateFail(jqXHR, textStatus, errorThrown) {
			var respError = jqXHR.getResponseHeader("X-SiteWhere-Error");
			$('#submitResult').html(createAlertHtml("alert-error", "Update Failed", 
				"Site was not updated. " + respError));
		}
		
		/** Handle highlighting errors */
		function doHighlight(element) {
			$(element).closest('.control-group').removeClass('success').addClass('error');
		}
		
		/** Handle showing successful validation */
		function doSuccess(element) {
			element.addClass('valid').closest('.control-group').removeClass('error').addClass('success');
		}
    });
</script>

<%@ include file="../includes/bottom.inc"%>