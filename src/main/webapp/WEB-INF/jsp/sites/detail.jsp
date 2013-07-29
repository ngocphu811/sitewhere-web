<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="sitewhere_title" value="${site.name}" />
<c:set var="sitewhere_section" value="sites" />
<%@ include file="../includes/top.inc"%>

<style>
.sw-assignment-list {
	border: 0px;
}

.sw-assignment-list-entry {
	clear: both;
	height: 70px;
	border: 1px solid #dcdcdc;
	padding: 10px;
	margin-bottom: 15px;
	font-size: 10pt;
	text-align: left;
	display: block;
	cursor: pointer;
}
</style>

<!-- Title Bar -->
<div class="sw-title-bar content k-header">
	<h1><c:out value="${sitewhere_title}"/></h1>
	<div class="sw-title-bar-right">
		<a id="btn-edit-site" class="btn" href="javascript:void(0)">
			<i class="icon-plus"></i> Edit Site</a>
	</div>
</div>

<!-- Tab panel -->
<div id="tabs">
	<ul>
		<li class="k-state-active">Assignments</li>
		<li>Locations</li>
		<li>Measurements</li>
		<li>Alerts</li>
	</ul>
	<div>
		<div id="assignments" class="sw-assignment-list"></div>
		<div id="assignments-pager" class="k-pager-wrap"></div>
	</div>
	<div></div>
	<div></div>
	<div></div>
</div>

<!-- Template for assignment row -->
<script type="text/x-kendo-tmpl" id="assignment-entry">
	<div class="sw-assignment-list-entry gradient-bg">
		Assignment
	</div>
</script>

<script>
	var siteToken = '<c:out value="${site.token}"/>';

	/** Datasource for assignments */
	var assignmentsDS;
	
	/** Reference to tab panel */
	var tabs;
	
	$(document).ready(function() {
		
		/** Create AJAX datasource for assignments list */
		assignmentsDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/sites/" + siteToken + "/assignments",
					dataType : "json",
				}
			},
			schema : {
				data: "results",
				total: "numResults",
				parse:function (response) {
				    $.each(response.results, function (index, item) {
				        if (item.createdDate && typeof item.createdDate === "string") {
				        	item.createdDate = kendo.parseDate(item.createdDate);
				        }
				        if (item.updatedDate && typeof item.updatedDate === "string") {
				        	item.updatedDate = kendo.parseDate(item.updatedDate);
				        }
				        if (item.activeDate && typeof item.activeDate === "string") {
				        	item.activeDate = kendo.parseDate(item.activeDate);
				        }
				        if (item.releasedDate && typeof item.releasedDate === "string") {
				        	item.releasedDate = kendo.parseDate(item.releasedDate);
				        }
				    });
				    return response;
				}
			},
			pageSize: 10
		});
		
		/** Create the site list */
		$("#assignments").kendoListView({
			dataSource : assignmentsDS,
			template : kendo.template($("#assignment-entry").html())
		});
		
	    $("#assignments-pager").kendoPager({
	        dataSource: assignmentsDS
	    });
		
		/** Create the tab strip */
		tabs = $("#tabs").kendoTabStrip({
			animation: false
		}).data("kendoTabStrip");
	});
</script>

<%@ include file="../includes/bottom.inc"%>