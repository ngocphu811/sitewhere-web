<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="swtitle" value="Manage Sites" />
<%@ include file="../top.inc"%>

<!-- Breadcrumb -->
<ul class="breadcrumb">
	<li><a href="../home">Home</a> <span class="divider">/</span>
	</li>
	<li><a href="#">Sites</a> <span class="divider">/</span>
	</li>
	<li class="active">Manage Sites</li>
</ul>

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

<!-- Actions that show up above the grid -->
<div class="actions-before-grid">
	<a id="btnAdd" class="btn btn-primary" href="#"><i
		class="icon-plus icon-white"></i> Add New Site</a>
</div>

<div id="grid" style="height: 450px"></div>

<!-- Actions that show up below the grid -->
<div class="pull-right actions-after-grid">
	<a id="btnEdit" class="btn btn-primary" href="#dialog"><i
		class="icon-pencil icon-white"></i> Edit</a> 
	<a id="btnDelete"
		class="btn btn-primary" href="#dialog"><i
		class="icon-remove icon-white"></i> Delete</a>
	<a id="btnAssignments"
		class="btn btn-primary" href="#dialog"><i
		class="icon-tag icon-white"></i> View Assignments</a>
</div>

<!-- Used to redirect to the assignment view page -->
<form id="viewForm" method="get" action="assignments">
	<input id="viewToken" name="siteToken" type="hidden"/>
</form>

<script>
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
		
        $("#grid").kendoGrid({
            dataSource: sitesDS,
            sortable: true,
            selectable: "single",
            pageable: {
                refresh: true,
                pageSizes: true
            },
            columns: [ {
                    field: "name",
                    width: 80,
                    title: "Site Name"
                } , {
                    field: "description",
                    width: 150,
                    title: "Description"
                } , {
                	field: "imageUrl",
                    width: 80,
                    title: "Image URL"
                } , {
                	field: "createdDate",
                    width: 80,
                    title: "Created Date",
                    format: "{0:MM/dd/yyyy HH:mm:ss}"
                }
            ]
        });
        var grid = $("#grid").data("kendoGrid");
        var selectedRows;
        
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
        
        /** Handle view assignment */
		$('#btnAssignments').click(function(event) {
			selectedRows = grid.select();
			if (selectedRows.length > 0) {
				var dataItem = grid.dataItem(selectedRows[0]);
				$("#viewToken").val(dataItem.token);
				$("#viewForm").submit();
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