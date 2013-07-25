<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="swtitle" value="Assign Device" />
<%@ include file="../top.inc"%>

<!-- Breadcrumb -->
<ul class="breadcrumb">
	<li><a href="../home">Home</a> <span class="divider">/</span>
	</li>
	<li><a href="#">Devices</a> <span class="divider">/</span>
	</li>
	<li class="active">Assign Device</li>
</ul>

<div id="wizard" class="carousel">
	<div class="carousel-inner">
		<div class="active item">

			<div class="alert alert-block alert-info">
				Choose location where the device is deployed and whether the device is associated with an asset.
			</div>
			
			<div class="asset asset-standalone input-block-level" style="margin-bottom: 20px;">
				<img src="${deviceAsset.imageUrl}" width="120"/>
				<p><b>${deviceAsset.name}</b></p>
				<p>${deviceAsset.description}</p>
				<span class="label label-info" style="margin-top: 10px;">
					&nbsp;Hardware Id:&nbsp;&nbsp;&nbsp;${device.hardwareId}&nbsp;
				</span>
			</div>
			
			<form class="form-horizontal">
				<div class="control-group">
					<label class="control-label" for="sites">Assigned Site:</label>
					<div class="controls">
						<input id="sites"/>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label" for="inputPassword">Associated Asset Type:</label>
					<div class="controls">
						<input id="associations"/>
					</div>
				</div>
				<div class="control-group">
					<div class="controls">
						<a id="createButton" class="btn btn-primary" href="javascript:void(0)"></a>
					</div>
				</div>
			</form>
 		</div>
		<div class="item">
			<div class="alert alert-block alert-info">
				Choose the person that will be associated with this device.
			</div>
	    	<div class="row">
				<div class="input-append span6">
					<input type="text" class="input-xlarge" id="txtPersonSearch" placeholder="Enter Search Criteria">
					<button id="btnPersonSearch" type="submit" class="btn">Search</button>
				</div>
				<form class="form-inline span6">
					<input id="selPersonAssetId" type="hidden"/>
					<div class="pull-right">
						<a id="pBack" class="btn btn-primary" href="javascript:void(0)">
							<i class='icon-arrow-left icon-white'></i>&nbsp;&nbsp;Back
						</a>
						<a id="pCreate" class="btn btn-primary" href="javascript:void(0)">
							<i class='icon-tag icon-white'></i>&nbsp;&nbsp;Create Assignment
						</a>
					</div>
				</form>
			</div>
			<div id="pListView"></div>
			<div id="pPager"></div>
 		</div>
		<div class="item">
			<div class="alert alert-block alert-info">
				Choose the hardware asset that will be associated with this device.
			</div>
	    	<div class="row">
				<div class="input-append span6">
					<input type="text" class="input-xlarge" id="txtHardwareSearch" placeholder="Enter Search Criteria">
					<button id="btnHardwareSearch" type="submit" class="btn">Search</button>
				</div>
				<form class="form-inline span6">
					<input id="selHardwareAssetId" type="hidden"/>
					<div class="pull-right">
						<a id="hwBack" class="btn btn-primary" href="javascript:void(0)">
							<i class='icon-arrow-left icon-white'></i>&nbsp;&nbsp;Back
						</a>
						<a id="hwCreate" class="btn btn-primary" href="javascript:void(0)">
							<i class='icon-tag icon-white'></i>&nbsp;&nbsp;Create Assignment
						</a>
					</div>
				</form>
			</div>
			<div id="hwListView"></div>
			<div id="hwPager"></div>
		</div>
	</div>
</div>

<!-- Used to redirect to the assignment view page -->
<form id="viewForm" method="get" action="assignment">
	<input id="viewToken" name="token" type="hidden"/>
</form>

<%@ include file="../includes/asset-templates.inc"%>
    
<script>
	$(document).ready(function() {
		/** Create the carousel and pause it */
        $('.carousel').carousel({
            interval: 2000
        });
        $('.carousel').carousel('pause');
        
        /*************
         * MAIN PAGE *
         *************/
         
     	/** Associated asset types */
     	var associationTypes = [
     		{ text: "None", value: "U" },
     		{ text: "Person", value: "P" },
     		{ text: "Hardware", value: "H" }
     	];

     	/** Create AJAX datasource for matched assets */
     	var sitesDS = new kendo.data.DataSource({
     		transport : {
     			read : {
     				url : "${pageContext.request.contextPath}/api/sites/simple",
     				dataType : "json",
     			}
     		},
     	});
        
        /** Create the sites dropdown */
		$("#sites").kendoDropDownList({
			dataTextField: "name",
			dataValueField: "token",
			dataSource: sitesDS,
	        index: 0
	    });
        
        /** Create the association types dropdown */
		$("#associations").kendoDropDownList({
			dataTextField: "text",
			dataValueField: "value",
			dataSource: associationTypes,
	        index: 0,
	        change: onAssociationChange
	    });
        
		$("#createButton").click(function(event) {
			event.preventDefault();
			var value = $("#associations").val();
			if (value == "U") {
				var assignData = {
					hardwareId: "${device.hardwareId}",
					siteToken: $('#sites').val(),
					assignmentType: "U",
				}
				$.postJSON("${pageContext.request.contextPath}/api/assignments", assignData, onCreateSuccess, onCreateFail);
			} else if (value == "P") {
				$('.carousel').carousel(1);
			} else if (value == "H") {
				$('.carousel').carousel(2);
			}
	    });
		onAssociationChange();
        
        /***************
         * PERSON PAGE *
         ***************/
         
         /** Clear previous selection since firefox caches it */
         $("#selPersonAssetId").val("");
 		
 		/** Create AJAX datasource for hardware assets */
 		var pAssetDS = new kendo.data.DataSource({
 			transport : {
 				read : {
 					url : "${pageContext.request.contextPath}/api/search/people/",
 					dataType : "json"
 				}
 			},
 			schema : {
 				data: "results",
 				total: "numResults"
 			},
 			pageSize : 4
 		});

		/** Create the person list */
		$("#pListView").kendoListView({
			dataSource : pAssetDS,
			selectable : "single",
			template : kendo.template($("#personAsset").html()),
			change: personSelectionChange
		});
		
		/** Create the pager */
        $("#pPager").kendoPager({
            dataSource: pAssetDS
        });
        
        /** Add handler to run person search when search button is clicked */
		$("#btnPersonSearch").click(function(event) {
			event.preventDefault();
			pAssetDS.transport.options.read.url = "${pageContext.request.contextPath}/api/search/people/" + $("#txtPersonSearch").val();
			pAssetDS.read();
			var pager = $("#pPager").data("kendoPager");
			pager.page(1);
		});
        
        /** Person back button clicked */
 		$("#pBack").click(function(event) {
			$('.carousel').carousel(0);
	    });
        
 		/** Person create button clicked */
 		$("#pCreate").click(function(event) {
 			if ($("#selPersonAssetId").val().length > 0) {
				var assignData = {
					hardwareId: "${device.hardwareId}",
					siteToken: $('#sites').val(),
					assignmentType: "P",
					assetId: $("#selPersonAssetId").val()
				}
				$.postJSON("${pageContext.request.contextPath}/api/assignments", assignData, onCreateSuccess, onCreateFail);
 			} else {
				bootbox.alert("You must select a person before creating the assignment.");
			}
	    });
		
		/** Called when the selected person changes */
        function personSelectionChange() {
            var listView = pAssetDS.view();
            var selected = $.map(this.select(), function(item) {
            	return listView[$(item).index()];
            });
            
            // Store selected id.
			if (selected.length > 0) {
				$("#selPersonAssetId").val(selected[0].id);
			} else {
				$("#selPersonAssetId").val("");
			}				
        }
       
        /*****************
         * HARDWARE PAGE *
         *****************/
         
         /** Clear previous selection since firefox caches it */
         $("#selHardwareAssetId").val("");
        
		/** Create AJAX datasource for hardware assets */
		var hwAssetDS = new kendo.data.DataSource({
			transport : {
				read : {
					url : "${pageContext.request.contextPath}/api/search/hardware/",
					dataType : "json"
				}
			},
			schema : {
				data: "results",
				total: "numResults"
			},
			pageSize : 4
		});

		/** Create the hardware list */
		$("#hwListView").kendoListView({
			dataSource : hwAssetDS,
			selectable : "single",
			template : kendo.template($("#hardwareAsset").html()),
			change: hardwareSelectionChange
		});
		
		/** Create the pager */
        $("#hwPager").kendoPager({
            dataSource: hwAssetDS
        });
              
           /** Add handler to run hardware search when search button is clicked */
		$("#btnHardwareSearch").click(function(event) {
			event.preventDefault();
			hwAssetDS.transport.options.read.url = "${pageContext.request.contextPath}/api/search/hardware/" + $("#txtHardwareSearch").val();
			hwAssetDS.read();
			var pager = $("#hwPager").data("kendoPager");
			pager.page(1);
		});
           
		$("#hwBack").click(function(event) {
			$(".carousel").carousel(0);
	    });
        
 		/** Person create button clicked */
 		$("#hwCreate").click(function(event) {
 			if ($("#selHardwareAssetId").val().length > 0) {
				var assignData = {
					hardwareId: "${device.hardwareId}",
					siteToken: $('#sites').val(),
					assignmentType: "H",
					assetId: $("#selHardwareAssetId").val()
				}
				$.postJSON("${pageContext.request.contextPath}/api/assignments", assignData, onCreateSuccess, onCreateFail);
 			} else {
				bootbox.alert("You must select a hardware asset before creating the assignment.");
			}
	    });
		
		/** Called when the selected hardware asset changes */
        function hardwareSelectionChange() {
            var listView = hwAssetDS.view();
            var selected = $.map(this.select(), function(item) {
            	return listView[$(item).index()];
            });
            
            // Store selected id.
			if (selected.length > 0) {
				$("#selHardwareAssetId").val(selected[0].id);
			} else {
				$("#selHardwareAssetId").val("");
			}				
        }
	});
	
	/** Called when association dropdown changes values */
	function onAssociationChange() {
		var value = $("#associations").val();
		if (value == "U") {
			$("#createButton").html("<i class='icon-tag icon-white'></i>&nbsp;&nbsp;Create Unassociated Assignment");
		} else if (value == "P") {
			$("#createButton").html("Choose Associated Person&nbsp;&nbsp;<i class='icon-arrow-right icon-white'></i>");
		} else if (value == "H") {
			$("#createButton").html("Choose Associated Hardware&nbsp;&nbsp;<i class='icon-arrow-right icon-white'></i>");
		}
	}
	
	/** Called after successful assignment creation */
	function onCreateSuccess(data, textStatus, jqXHR) {
		var token = data.token;
		$("#viewToken").val(token);
		$("#viewForm").submit();
	}
	
	/** Called after failed assignment creation */
	function onCreateFail() {
		bootbox.alert("Create failed.");
	}
</script>

<style>
	.asset {
		float: left;
		width: 45%;
		height: 160px;
		list-style-type: none;
		overflow: hidden;
       	padding: 10px;
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
		width: 45%;
		height: 130px;
		list-style-type: none;
		margin: 10px;
		overflow: hidden;
       	padding: 10px;
       	-moz-box-shadow: inset 0 0 30px rgba(0,0,0,0.15);
		-webkit-box-shadow: inset 0 0 30px rgba(0,0,0,0.15);
		box-shadow: inset 0 0 30px rgba(0,0,0,0.15);
       	border: 3px solid #ddd;
		background-image: none;
		cursor: pointer;
	}
	.hwasset img {
		width: 120px;
		float: left;
		border: 1px solid #eee;
		bottom: 15px;
		top: 15px;
		margin-right: 15px;
		max-height: 120px;
	}
	*.hwasset.k-state-selected {
       	background-color: #fff;
       	color: #333;
       	border: 3px solid #00f;
	}
	.k-listview:after {
       	content: ".";
		display: block;
		height: 0;
		clear: both;
		visibility: hidden;
	}
	.k-listview {
		height: 360px;
		border: 1px solid #eee;
       	padding: 0;
       	min-width: 0;
	}		
</style>

<%@ include file="../bottom.inc"%>