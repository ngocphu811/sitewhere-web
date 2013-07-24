<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="swtitle" value="Manage Sites" />
<%@ include file="../top.inc"%>

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

.sw-site-list-entry img {
	float: left;
    border: 1px solid #cccccc;
    margin-right: 15px;
}

.sw-site-list-entry h1 {
	line-height: 0px;
	font-size: 16pt;
	padding-bottom: 10px;
}

.sw-site-list-entry-logo {
    width: 100px;
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
			<li class="active">Manage Sites</li>
		</ul>
	</div>
	<h1>Manage Sites</h1>
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
				<li>Metadata</li>
				<li>Map Information</li>
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
				<div id="metadataGrid"></div>
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
							<label class="control-label" for="mqCenterLatitude">Center Latitude</label>
							<div class="controls">
								<input type="text" id="mqCenterLatitude" class="input-large">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="mqCenterLongitude">Center Longitude</label>
							<div class="controls">
								<input type="text" id="mqCenterLongitude" class="input-large">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="mqScale">Scale</label>
							<div class="controls">
								<input type="text" id="mqScale" class="input-large">
							</div>
						</div>
					</form>
					<form id="geoserver" class="form-horizontal hide">
						<div class="control-group">
							<label class="control-label" for="gsBaseUrl">GeoServer Base URL</label>
							<div class="controls">
								<input type="text" id="gsBaseUrl" name="baseUrl" required class="input-xlarge">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="gsLayerName">GeoServer Layer</label>
							<div class="controls">
								<input type="text" id="gsLayerName" name="layerName" required class="input-xlarge">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="gsCenterLatitude">Center Latitude</label>
							<div class="controls">
								<input type="text" id="gsCenterLatitude" class="input-large">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="gsCenterLongitude">Center Longitude</label>
							<div class="controls">
								<input type="text" id="gsCenterLongitude" class="input-large">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="gsScale">Scale</label>
							<div class="controls">
								<input type="text" id="gsScale" class="input-large">
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<input id="site-token" type="hidden" value="" />
	<div class="modal-footer">
		<a href="javascript:void(0)" class="btn" data-dismiss="modal">Cancel</a> 
		<a id="site-submit" href="javascript:void(0)" class="btn btn-primary">Create</a>
	</div>
</div>

<div id="submitResult"></div>

<div id="sites" class="sw-site-list"></div>

<!-- Asset item template -->
<script type="text/x-kendo-tmpl" id="siteEntry">
	<div class="sw-site-list-entry gradient-bg" onclick="onOpenClicked(event, '#:token#')">
		<img class="sw-site-list-entry-logo" src="#:imageUrl#" width="100"/>
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
		$('#dialog-header').html("Edit Site");
		$('#dialog-submit').html("Save");
		$('#dialog').modal('show');
		$('#site-name').val(data.name);
		$('#site-desc').val(data.description);
		$('#site-image-url').val(data.imageUrl);
		$('#site-token').val(data.token);
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
	
	/** Initial grid data */
	var gridData = [{name:"phone.number", value:"777-555-1212"}];
	var metaDatasource;
	
	/** Available map types shown in dropdown */
    var mapTypes = [
		{ text: "MapQuest World Map", value: "mapquest" },
		{ text: "GeoServer Layer", value: "geoserver" },
	];
	
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
	        data: gridData,
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
    	$("#mapType").kendoDropDownList({
    		dataTextField: "text",
    		dataValueField: "value",
    	    dataSource: mapTypes,
    	    index: 0,
    	    change: onMapTypeChanged
    	});
        
        /** Handle create dialog */
		$('#btn-add-site').click(function(event) {
			$('#dialog-header').html("Create Site");
			$('#dialog-submit').html("Create");
			$('#dialog').modal('show');
			$('#site-name').val("");
			$('#site-desc').val("");
			$('#site-image-url').val("");
			$('#site-token').val("");
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
		$('#site-submit').click(function(event) {
			event.preventDefault();
			var mainValid = validateMainForm();
			var mapValid = validateSelectedMapForm();
			if (mainValid && mapValid) {
				var siteToken = $('#site-token').val();
				var siteData = {
					"name": $('#siteName').val(), 
					"description": $('#siteDesc').val(), 
					"imageUrl": $('#siteImgUrl').val(), 
				}
				if ($('#site-token').val() == "") {
					$.postJSON("${pageContext.request.contextPath}/api/sites", siteData, onSuccess, onCreateFail);
				} else {
					$.postJSON("${pageContext.request.contextPath}/api/sites/" + $('#site-token').val(), siteData, onSuccess, onUpdateFail);
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
			var respError = jqXHR.getResponseHeader("SiteWhere-Error");
			$('#submitResult').html(createAlertHtml("alert-error", "Create Failed", 
				"Site was not created. " + respError));
		}
        
		/** Handle failed call to update site */
		function onUpdateFail(jqXHR, textStatus, errorThrown) {
			var respError = jqXHR.getResponseHeader("SiteWhere-Error");
			$('#submitResult').html(createAlertHtml("alert-error", "Update Failed", 
				"Site was not updated. " + respError));
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

<%@ include file="../bottom.inc"%>