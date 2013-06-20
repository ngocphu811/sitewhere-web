<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="swtitle" value="Site Assignments" />
<%@ include file="../top.inc"%>

<!-- Breadcrumb -->
<ul class="breadcrumb">
	<li><a href="../home">Home</a> <span class="divider">/</span>
	</li>
	<li><a href="#">Sites</a> <span class="divider">/</span>
	</li>
	<li class="active">Site Assignments</li>
</ul>

<div id="grid" style="height: 450px"></div>

<!-- Actions that show up below the grid -->
<div class="pull-right actions-after-grid">
	<a id="btnView" class="btn btn-primary" href="javascript:void()"><i
		class="icon-tag icon-white"></i> View Assignment</a> 
</div>

<!-- Used to redirect to the assignment view page -->
<form id="viewForm" method="get" action="${pageContext.request.contextPath}/admin/device/assignment">
	<input id="viewToken" name="token" type="hidden"/>
</form>

<script>
    $(document).ready(function() {
		/** Create AJAX datasource for sites list */
		var assignmentsDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/assignments/site/${site.token}",
					dataType : "json",
				}
			},
			schema : {
				data: "results",
				total: "numResults",
				parse:function (response) {
				    $.each(response.results, function (index, item) {
				        if (item.activeDate && typeof item.activeDate === "string") {
				        	item.activeDate = kendo.parseDate(item.activeDate, "yyyy-MM-ddTHH:mm:ss");
				        }
				        if (item.releasedDate && typeof item.releasedDate === "string") {
				        	item.releasedDate = kendo.parseDate(item.releasedDate, "yyyy-MM-ddTHH:mm:ss");
				        }
				    });
				    return response;
				}
			},
			pageSize: 10
		});
		
        $("#grid").kendoGrid({
            dataSource: assignmentsDS,
            sortable: true,
            selectable: "single",
            pageable: {
                refresh: true,
                pageSizes: true
            },
            columns: [ {
                	field: "deviceHardwareId",
                	width: 160,
                	title: "Hardware Id"
            	} , {
                    field: "assetName",
                    width: 100,
                    title: "Associated Asset"
                } , {
                    field: "assetType",
                    width: 80,
                    title: "Asset Type"
                } , {
                    field: "status",
                    width: 80,
                    title: "Status"
                } , {
                	field: "activeDate",
                    width: 100,
                    title: "Active Date",
                    format: "{0:MM/dd/yyyy HH:mm:ss}"
                }
            ]
        });
        var grid = $("#grid").data("kendoGrid");
        var selectedRows;
        
        /** Handle create dialog */
		$('#btnView').click(function(event) {
			selectedRows = grid.select();
			if (selectedRows.length > 0) {
				var dataItem = grid.dataItem(selectedRows[0]);
				$("#viewToken").val(dataItem.token);
				$("#viewForm").submit();
			}
		});
    });
</script>

<%@ include file="../bottom.inc"%>