<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="sitewhere_title" value="Manage Users" />
<c:set var="sitewhere_section" value="users" />
<%@ include file="../includes/top.inc"%>

<style>
</style>

<!-- Title Bar -->
<div class="sw-title-bar content k-header">
	<h1 class="ellipsis"><c:out value="${sitewhere_title}"/></h1>
	<div class="sw-title-bar-right">
		<a id="btn-filter-results" class="btn" href="javascript:void(0)">
			<i class="icon-search sw-button-icon"></i> Filter Results</a>
		<a id="btn-add-user" class="btn" href="javascript:void(0)">
			<i class="icon-plus sw-button-icon"></i> Add New User</a>
	</div>
</div>
<table id="users">
	<colgroup>
		<col style="width: 15%;"/>
		<col style="width: 15%;"/>
		<col style="width: 15%;"/>
		<col style="width: 10%;"/>
		<col style="width: 15%;"/>
		<col style="width: 15%;"/>
		<col style="width: 15%;"/>
	</colgroup>
	<thead>
		<tr>
			<th>Username</th>
			<th>First Name</th>
			<th>Last Name</th>
			<th>Status</th>
			<th>Last Login</th>
			<th>Created</th>
			<th>Updated</th>
		</tr>
	</thead>
	<tbody>
		<tr><td colspan="7"></td></tr>
	</tbody>
</table>
<div id="pager" class="k-pager-wrap" style="margin-top: 10px;"></div>

<%@ include file="../includes/templateUserEntry.inc"%>	

<%@ include file="../includes/templateUserAuthorityEntry.inc"%>	

<%@ include file="../includes/userCreateDialog.inc"%>

<script>
	/** Reference for user list datasource */
	var usersDS;
	
	/** Called after a new user has been created */
	function onUserCreated() {
		usersDS.read();
	}
	
    $(document).ready(function() {
		/** Create AJAX datasource for users list */
		usersDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/users",
					dataType : "json",
				}
			},
			schema : {
				data: "results",
				total: "numResults",
				parse:function (response) {
				    $.each(response.results, function (index, item) {
				    	parseUserData(item);
				    });
				    return response;
				}
			},
			pageSize: 10
		});
		
		/** Create the location list */
        $("#users").kendoGrid({
			dataSource : usersDS,
            rowTemplate: kendo.template($("#tpl-user-entry").html()),
            scrollable: false,
        });
		
		/** Pager for device list */
        $("#pager").kendoPager({
            dataSource: usersDS
        });
		
        /** Handle create dialog */
		$('#btn-add-user').click(function(event) {
			ucOpen(onUserCreated);
		});
    });
</script>

<%@ include file="../includes/bottom.inc"%>