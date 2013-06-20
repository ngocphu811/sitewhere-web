<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="swtitle" value="Unassigned Devices" />
<%@ include file="../top.inc"%>

<!-- Breadcrumb -->
<ul class="breadcrumb">
	<li><a href="../home">Home</a> <span class="divider">/</span>
	</li>
	<li><a href="#">Devices</a> <span class="divider">/</span>
	</li>
	<li class="active">Unassigned Devices</li>
</ul>

<!-- Actions that show up above the grid -->
<div class="actions-before-grid">
	<a id="btnAdd" class="btn btn-primary" href="create"><i
		class="icon-plus icon-white"></i> Create Devices</a>
</div>

<div id="grid" style="height: 380px"></div>

<!-- Actions that show up below the grid -->
<div class="pull-right actions-after-grid">
	<form id="assignForm" method="get" action="assign">
		<input id="formHardwareId" name="hardwareId" type="hidden"/>
		<a id="btnAssign" class="btn btn-primary" href="javascript:void(0);"><i class="icon-tag icon-white"></i> Assign Device</a> 
	</form>
</div>

<script>
    $(document).ready(function() {
		/** Create AJAX datasource for matched assets */
		var devicesDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/devices/unassigned",
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
            dataSource: devicesDS,
            sortable: true,
            selectable: "single",
            pageable: {
                refresh: true,
                pageSizes: true
            },
            columns: [ {
                    field: "assetName",
                    width: 80,
                    title: "Type"
            	} , {
                	field: "hardwareId",
                	width: 100,
                	title: "Hardware Id"
                } , {
                    field: "comments",
                    width: 150,
                    title: "Comments"
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
        
        /** Handle edit dialog */
		$('#btnAssign').click(function(event) {
			selectedRows = grid.select();
			if (selectedRows.length > 0) {
				var dataItem = grid.dataItem(selectedRows[0]);
				$('#formHardwareId').val(dataItem.hardwareId);
				$('#assignForm').submit();
			}
		});
    });
</script>

<%@ include file="../bottom.inc"%>