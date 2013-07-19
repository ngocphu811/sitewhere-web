<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="swtitle" value="Manage Sites" />
<%@ include file="../top.inc"%>

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
		<a id="btnAdd" class="btn" href="#"><i
			class="icon-plus icon-white"></i> Add New Site</a>
	</div>
</div>

<!-- Dialog for create/update -->
<div id="dialog" class="modal hide">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"
			aria-hidden="true">&times;</button>
		<h3 id="dialogHeader">Create Site</h3>
	</div>
	<div class="modal-body">
		<form class="form-horizontal">
			<div class="control-group">
				<label class="control-label" for="siteName">Site Name:</label>
				<div class="controls">
					<input type="text" id="siteName" placeholder="Name"
						class="input-xlarge">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="siteDesc">Site
					Description:</label>
				<div class="controls">
					<textarea id="siteDesc" placeholder="Description"
						class="input-xlarge"></textarea>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="siteImgUrl">Image URL:</label>
				<div class="controls">
					<input type="text" id="siteImgUrl" placeholder="Image URL"
						class="input-xlarge">
				</div>
			</div>
		</form>
	</div>
	<input id="siteToken" type="hidden" value="" />
	<div class="modal-footer">
		<a href="#" class="btn" data-dismiss="modal">Cancel</a> <a
			id="dialogSubmit" href="#" class="btn btn-primary">Create</a>
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
					href="javascript:void(0)" onclick="onEditClicked(event, '#:token#');">
					<i class="icon-pencil icon-white"></i></a>
				<a class="btn btn-small btn-danger" title="Delete Site" 
					href="javascript:void(0)" onclick="onDeleteClicked(event, '#:token#')">
					<i class="icon-remove icon-white"></i></a>
				<a class="btn btn-small btn-success" title="Site Contents" 
					href="javascript:void(0)" onclick="onOpenClicked(event, '#:token#')">
					<i class="icon-chevron-right icon-white"></i></a>
			</div>
		</div>
		<div>
			<h1>#:name#</h1>
			<p>#:description#</p>
		</div>
	</div>
</script>

<script>
	/** Called when edit button is clicked */
	function onEditClicked(e, siteToken) {
		alert("Edit " + siteToken);
		var event = e || window.event;
		event.stopPropagation();
	}
	
	/** Called when edit button is clicked */
	function onDeleteClicked(e, siteToken) {
		alert("Delete " + siteToken);
		var event = e || window.event;
		event.stopPropagation();
	}
	
	/** Called when edit button is clicked */
	function onOpenClicked(e, siteToken) {
		alert("Open " + siteToken);
		var event = e || window.event;
		event.stopPropagation();
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
        
        /** Handle create dialog */
		$('#btnAdd').click(function(event) {
			$('#dialogHeader').html("Create Site");
			$('#dialogSubmit').html("Create");
			$('#dialog').modal('show');
			$('#siteName').val("");
			$('#siteDesc').val("");
			$('#siteImgUrl').val("");
			$('#siteToken').val("");
		});
        
        /** Handle edit dialog */
		$('#btnEdit').click(function(event) {
			selectedRows = grid.select();
			if (selectedRows.length > 0) {
				var dataItem = grid.dataItem(selectedRows[0]);
				$('#dialogHeader').html("Edit Site");
				$('#dialogSubmit').html("Save");
				$('#dialog').modal('show');
				$('#siteName').val(dataItem.name);
				$('#siteDesc').val(dataItem.description);
				$('#siteImgUrl').val(dataItem.imageUrl);
				$('#siteToken').val(dataItem.token);
			}
		});
        
        /** Handle dialog submit */
		$('#dialogSubmit').click(function(event) {
			event.preventDefault();
			var siteData = {
				"token": $('#siteToken').val(), 
				"name": $('#siteName').val(), 
				"description": $('#siteDesc').val(), 
				"imageUrl": $('#siteImgUrl').val(), 
			}
			if ($('#siteToken').val() == "") {
				$.postJSON("${pageContext.request.contextPath}/api/sites", siteData, onSuccess, onCreateFail);
			} else {
				$.postJSON("${pageContext.request.contextPath}/api/sites/" + $('#siteToken').val(), siteData, onSuccess, onUpdateFail);
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
    });
</script>

<%@ include file="../bottom.inc"%>