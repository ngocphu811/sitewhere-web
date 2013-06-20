<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="swtitle" value="View Assignment" />
<%@ include file="../top.inc"%>

<!-- Breadcrumb -->
<ul class="breadcrumb">
	<li><a href="../home">Home</a> <span class="divider">/</span>
	</li>
	<li><a href="#">Devices</a> <span class="divider">/</span>
	</li>
	<li class="active">View Assignment</li>
</ul>

<c:choose>
	<c:when test="${deviceAssignment.status.statusCode == 'A'}">
		<div class="alert alert-block alert-success">
			Device is currently assigned.
			<div class="alert-buttons">
				<a id="btnEnd" class="btn btn-success" href="javascript:void(0)"><i class="icon-ok icon-white"></i> End Assignment</a>
				<a id="btnMissing" class="btn btn-danger" href="javascript:void(0)"><i class="icon-exclamation-sign icon-white"></i> Report Missing</a>
			</div>
		</div>
		<form id="reloadPage" method="get" action="assignment">
			<input name="token" type="hidden" value="${deviceAssignment.token}"/>
		</form>
		<script>
			$(document).ready(function() {
				$('#btnEnd').click(function(event) {
					$.postJSON("${pageContext.request.contextPath}/api/assignments/${deviceAssignment.token}/end", 
							null, onSuccess, onEndFail);
				});
				
				$('#btnMissing').click(function(event) {
					$.postJSON("${pageContext.request.contextPath}/api/assignments/${deviceAssignment.token}/missing", 
							null, onSuccess, onMissingFail);
				});
				
				/** Reload page on successful update */
				function onSuccess() {
					$('#reloadPage').submit();
				}
				
				/** Show alert if unable to end assignment */
				function onEndFail() {
					bootbox.alert("Unable to end device assignment.");
				}
				
				/** Show alert if unable to mark as missing */
				function onMissingFail() {
					bootbox.alert("Unable to mark assignment as missing.");
				}
			});
		</script>
	</c:when>
	<c:when test="${deviceAssignment.status.statusCode == 'M'}">
		<div class="alert alert-block alert-error">
			Device has been reported missing.
			<div class="alert-buttons">
				<a id="btnEnd" class="btn btn-danger" href="javascript:void(0)"><i class="icon-ok icon-white"></i> End Assignment</a>
			</div>
		</div>
		<form id="reloadPage" method="get" action="assignment">
			<input name="token" type="hidden" value="${deviceAssignment.token}"/>
		</form>
		<script>
			$(document).ready(function() {
				$('#btnEnd').click(function(event) {
					$.postJSON("${pageContext.request.contextPath}/api/assignments/${deviceAssignment.token}/end", 
							null, onSuccess, onEndFail);
				});
				
				/** Reload page on successful update */
				function onSuccess() {
					$('#reloadPage').submit();
				}
				
				/** Show alert if unable to end assignment */
				function onEndFail() {
					bootbox.alert("Unable to end device assignment.");
				}
			});
		</script>
	</c:when>
	<c:when test="${deviceAssignment.status.statusCode == 'R'}">
		<div class="alert alert-block alert-info">
			This device assignment has ended.
		</div>
	</c:when>
	<c:otherwise>
		<div class="alert alert-block alert-error">
			Unknown device assignment status. 
		</div>
	</c:otherwise>
</c:choose>

<div class="asset asset-standalone input-block-level" style="margin-bottom: 20px;">
	<img src="${deviceAsset.imageUrl}" width="120"/>
	<p><b>${deviceAsset.name}</b></p>
	<p>${deviceAsset.description}</p>
	<span class="label label-info" style="margin-top: 10px;">
		&nbsp;Hardware Id:&nbsp;&nbsp;&nbsp;${device.hardwareId}&nbsp;
	</span>
</div>

<!-- Tabs -->
<div id="tabstrip">
	<ul>
		<li class="k-state-active">Assignment</li>
		<li>Measurements</li>
		<li>Locations</li>
		<li>Alerts</li>
		<li>Asset Association</li>
	</ul>
				
	<!-- Assignment tab -->		
	<div class="row">
		<form class="form-horizontal span5">
			<div class="control-group">
				<label class="control-label" for="site">Assigned Site:</label>
				<div class="controls">
					<input type="text" class="input-large" value="${site.name}" disabled>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="site">Assignment Status:</label>
				<div class="controls">
					<input type="text" class="input-large" value="${deviceAssignmentHelper.status}" disabled>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="site">Assignment Date:</label>
				<div class="controls">
					<input type="text" class="input-large" value="${deviceAssignmentHelper.activeDate}" disabled>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label" for="site">Released Date:</label>
				<div class="controls">
					<input type="text" class="input-large" value="${deviceAssignmentHelper.releasedDate}" disabled>
				</div>
			</div>
		</form>
		
		<!-- Person asset assigned -->
		<c:choose>
			<c:when test="${deviceAssignment.assetType.code == 'P'}">
				<form class="form-horizontal span5" style="padding-left: 50px;">
					<div class="control-group">
						<label class="control-label" for="site">Associated Asset Type:</label>
						<div class="controls">
							<input type="text" class="input-large" value="${deviceAssignmentHelper.assetType}" disabled>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="site">Assignee Name:</label>
						<div class="controls">
							<input type="text" class="input-large" value="${deviceAssignmentAsset.name}" disabled>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="site">Email Address:</label>
						<div class="controls">
							<input type="text" class="input-large" value="${deviceAssignmentAsset.emailAddress}" disabled>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="site">Username:</label>
						<div class="controls">
							<input type="text" class="input-large" value="${deviceAssignmentAsset.userName}" disabled>
						</div>
					</div>
				</form>
			</c:when>
			<c:when test="${deviceAssignment.assetType.code == 'H'}">
				<form class="form-horizontal span5" style="padding-left: 50px;">
					<div class="control-group">
						<label class="control-label" for="site">Associated Asset Type:</label>
						<div class="controls">
							<input type="text" class="input-large" value="${deviceAssignmentHelper.assetType}" disabled>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="site">Asset:</label>
						<div class="controls">
							<input type="text" class="input-large" value="${deviceAssignmentAsset.name}" disabled>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="site">SKU:</label>
						<div class="controls">
							<input type="text" class="input-large" value="${deviceAssignmentAsset.sku}" disabled>
						</div>
					</div>
				</form>
			</c:when>
		</c:choose>
	</div>
	
	<!-- Measurements tab -->
	<div>
		<div id="measurementsGrid"></div>
	</div>
	
	<!-- Locations tab -->
	<div>
		<div id="locationsGrid"></div>
	</div>
	
	<!-- Alerts tab -->
	<div>
		<div id="alertsGrid"></div>
	</div>
	
	<!-- Asset tab -->
	<div>
		<div id="associatedAsset"></div>
	</div>
	
</div>

<%@ include file="../includes/asset-templates.inc"%>
    
<script>
	$(document).ready(function() {
		/** Create AJAX datasource for measurements */
		var measurementsDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/assignments/${deviceAssignment.token}/measurements",
					dataType : "json",
				}
			},
			schema : {
				data: "results",
				total: "numResults",
				parse:function (response) {
				    $.each(response.results, function (index, item) {
				        if (item.eventDate && typeof item.eventDate === "string") {
				        	item.eventDate = kendo.parseDate(item.eventDate, "yyyy-MM-ddTHH:mm:ss");
				        }
				        if (item.receivedDate && typeof item.receivedDate === "string") {
				        	item.receivedDate = kendo.parseDate(item.receivedDate, "yyyy-MM-ddTHH:mm:ss");
				        }
				    });
				    return response;
				}
			},
			pageSize: 10
		});
        $("#measurementsGrid").kendoGrid({
            dataSource: measurementsDS,
            height: 250,
            sortable: true,
            selectable: "single",
            pageable: {
                refresh: true,
                pageSizes: true
            },
			columns: [ {
					field: "eventDate",
					width: 100,
					title: "Measurement Date",
					format: "{0:MM/dd/yyyy HH:mm:ss}"
                } , {
					field: "receivedDate",
					width: 100,
					title: "Received Date",
					format: "{0:MM/dd/yyyy HH:mm:ss}"
                } , {
					field: "propertiesSummary",
					width: 350,
					title: "Measurements"
				}
           ]
        });
        var measurementsGrid = $("#measurementsGrid").data("kendoGrid");
        
		/** Create AJAX datasource for locations */
		var locationsDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/assignments/${deviceAssignment.token}/locations",
					dataType : "json",
				}
			},
			schema : {
				data: "results",
				total: "numResults",
				parse:function (response) {
				    $.each(response.results, function (index, item) {
				        if (item.eventDate && typeof item.eventDate === "string") {
				        	item.eventDate = kendo.parseDate(item.eventDate, "yyyy-MM-ddTHH:mm:ss");
				        }
				        if (item.receivedDate && typeof item.receivedDate === "string") {
				        	item.receivedDate = kendo.parseDate(item.receivedDate, "yyyy-MM-ddTHH:mm:ss");
				        }
				    });
				    return response;
				}
			},
			pageSize: 10
		});
        $("#locationsGrid").kendoGrid({
            dataSource: locationsDS,
            height: 250,
            sortable: true,
            selectable: "single",
            pageable: {
                refresh: true,
                pageSizes: true
            },
			columns: [ {
					field: "eventDate",
					width: 150,
					title: "Measurement Date",
					format: "{0:MM/dd/yyyy HH:mm:ss}"
            	}, {
					field: "receivedDate",
					width: 150,
					title: "Received Date",
					format: "{0:MM/dd/yyyy HH:mm:ss}"
                } , {
					field: "latitude",
					width: 150,
					title: "Latitude"
                } , {
					field: "longitude",
					width: 150,
					title: "Longitude"
				}
           ]
        });
        var locationsGrid = $("#locationsGrid").data("kendoGrid");

		/** Create AJAX datasource for alerts */
		var alertsDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/assignments/${deviceAssignment.token}/alerts",
					dataType : "json",
				}
			},
			schema : {
				data: "results",
				total: "numResults",
				parse:function (response) {
				    $.each(response.results, function (index, item) {
				        if (item.eventDate && typeof item.eventDate === "string") {
				        	item.eventDate = kendo.parseDate(item.eventDate, "yyyy-MM-ddTHH:mm:ss");
				        }
				        if (item.receivedDate && typeof item.receivedDate === "string") {
				        	item.receivedDate = kendo.parseDate(item.receivedDate, "yyyy-MM-ddTHH:mm:ss");
				        }
				    });
				    return response;
				}
			},
			pageSize: 10
		});
        $("#alertsGrid").kendoGrid({
            dataSource: alertsDS,
            height: 250,
            sortable: true,
            selectable: "single",
            pageable: {
                refresh: true,
                pageSizes: true
            },
			columns: [ {
					field: "eventDate",
					width: 100,
					title: "Measurement Date",
					format: "{0:MM/dd/yyyy HH:mm:ss}"
        		}, {
					field: "receivedDate",
					width: 100,
					title: "Received Date",
					format: "{0:MM/dd/yyyy HH:mm:ss}"
            	} , {
					field: "message",
					width: 200,
					title: "Message"
            	} , {
					field: "acknowledged",
					width: 70,
					title: "Acknowledged"
				}
       		]
        });
        var alertsGrid = $("#alertsGrid").data("kendoGrid");

		var asset = ${deviceAssignmentAssetJson};
		
		if (asset) {
			if (asset.type == "Hardware") {
				var template = kendo.template($("#hardwareAsset").html());
				$("#associatedAsset").html(template(asset));
			} else if (asset.type == "Person") {
				var template = kendo.template($("#personAsset").html());
				$("#associatedAsset").html(template(asset));
			}
		}
		$("#tabstrip").kendoTabStrip({
			activate: onTabActive,
			animation: {
				open: {
					effects: ""
				}
			}	
		});
		var tabstrip = $("#tabstrip").data("kendoTabStrip");
		
		/** Hack to redraw grid */
		var firstTab1 = true;
		var firstTab2 = true;
		var firstTab3 = true;
		function onTabActive(e) {
			var selectedIndex = tabstrip.select().index(); 
			if (selectedIndex == 1) {
				if (firstTab1) {
					measurementsGrid.refresh();
					firstTab1 = false;
				}
			}
			if (selectedIndex == 2) {
				if (firstTab2) {
					locationsGrid.refresh();
					firstTab2 = false;
				}
			}
			if (selectedIndex == 3) {
				if (firstTab3) {
					alertsGrid.refresh();
					firstTab3 = false;
				}
			}
		}
	});
</script>

<style>
	.asset {
		float: left;
		width: 45%;
		height: 160px;
		list-style-type: none;
		overflow: hidden;
       	padding: 10px;
       	margin-left: 0px;
       	-moz-box-shadow: inset 0 0 30px rgba(0,0,0,0.15);
		-webkit-box-shadow: inset 0 0 30px rgba(0,0,0,0.15);
		box-shadow: inset 0 0 30px rgba(0,0,0,0.15);
       	border: 3px solid #ddd;
		background-image: none;
	}
	.asset img {
		float: left;
		border: 1px solid #eee;
		bottom: 15px;
		top: 15px;
		margin-right: 15px;
		max-height: 130px;
	}
	.asset.asset-standalone {
		width: 100%;
	}
	.hwasset {
		float: left;
		width: 430px;
		height: 110px;
		list-style-type: none;
		overflow: hidden;
       	padding: 7px;
       	margin-left: 10px;
       	-moz-box-shadow: inset 0 0 30px rgba(0,0,0,0.15);
		-webkit-box-shadow: inset 0 0 30px rgba(0,0,0,0.15);
		box-shadow: inset 0 0 30px rgba(0,0,0,0.15);
       	border: 3px solid #ddd;
		background-image: none;
		font-size: 10pt;
	}
	.hwasset img {
		width: 100px;
		float: left;
		border: 1px solid #eee;
		bottom: 5px;
		top: 5px;
		margin-right: 15px;
		max-height: 100px;
	}
	.k-tabstrip {
		margin-top: 20px;
	}
	.k-tabstrip a:hover {
		text-decoration: none;
	}
	.k-tabstrip .k-content {
		padding-top: 20px;
		padding-bottom: 10px;
		min-height: 250px;
	}
</style>
<%@ include file="../bottom.inc"%>