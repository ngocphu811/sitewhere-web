<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="swtitle" value="Create Devices"/>
<%@ include file="../top.inc" %>

<!-- Breadcrumb -->
<ul class="breadcrumb">
	<li><a href="../home">Home</a> <span class="divider">/</span></li>
	<li><a href="#">Devices</a> <span class="divider">/</span></li>
	<li class="active">Create Devices</li>
</ul>

<!--  Use the carousel as a wizard container -->
<div id="wizard" class="carousel" style="line-height: 20px;">
	<div class="carousel-inner">
		<div class="active item">
		    <div class="alert alert-info">
				Choose the type of device hardware then click continue.
		    </div>		
	    	<div class="row">
				<div class="input-append span6">
					<input type="text" class="input-xlarge" id="txtHardwareSearch" placeholder="Enter Search Criteria">
					<button id="btnHardwareSearch" type="submit" class="btn">Search</button>
				</div>
				<form class="form-inline span6">
					<input id="selectedAssetId" type="hidden"/>
					<div class="pull-right">
						<a id="btnContinue" class="btn btn-primary" href="javascript:void(0)">
							Continue&nbsp;&nbsp;<i class='icon-arrow-right icon-white'></i>
						</a>
					</div>
				</form>
			</div>
			<div id="listView"></div>
			<div id="pager"></div>
		</div>
		<div class="item">
		    <div id="submitResult"></div>
		    <div class="alert alert-info">
				Enter a list of hardware ids for the devices to create.
		    </div>
	    	<div class="row">
	    		<div class="span6">
					<div class="input-append">
						<input type="text" id="txtHardwareId" class="input-xlarge" placeholder="Enter Unique Hardware Id">
						<button id="btnAddHardwareId" type="submit" class="btn">Add</button>
					</div>
	    		</div>
				<div class="span6"></div>
			</div>
			<div class="row">
	    		<div class="span6">
					<div id="hwIdList"></div>
	    		</div>
				<div class="span6">
					<div id="selectedAssetBlock">
			        	<div id="selDeviceAsset"></div>
						<button class="btn btn-info input-block-level" id="btnBack">Change Hardware Choice</button>
					</div>
					<textarea id="txtComment" placeholder="Add Comment for All Devices in this Batch"></textarea>
				</div>
			</div>
			<div class="pull-right">
				<button id="btnCreateDevices" class="btn btn-primary">Create Devices</button>
			</div>
		</div>
	</div>
</div>

<!-- Asset item template -->
<script type="text/x-kendo-tmpl" id="assetInList">
	<div class="asset">
		<img src="#:imageUrl#" width="120"/>
		<p><b>#:name#</b></p>
		<p>#:description#</p>
	</div>
</script>

<!-- Selected asset template -->
<script type="text/x-kendo-tmpl" id="assetStandalone">
	<div class="asset asset-standalone input-block-level">
		<img src="#:imageUrl#" width="120"/>
		<p><b>#:name#</b></p>
		<p>#:description#</p>
	</div>
</script>

<!-- Hardware id template -->
<script type="text/x-kendo-tmpl" id="hardwareIdInList">
	<div class="hardwareId">
		#:hardwareId#
	</div>
</script>

<script>
	$(document).ready(function() {
		
		/***************
		 * ASSETS CODE *
		 ***************/
		
		 /** Clear select asset since firefox caches it */
		$('#selectedAssetId').val("");
		
		/** Create AJAX datasource for matched assets */
		var assetsDS = new kendo.data.DataSource({
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
		$("#listView").kendoListView({
			dataSource : assetsDS,
			selectable : "single",
			template : kendo.template($("#assetInList").html()),
			change: listSelectionChange
		});
		
		/** Create the pager */
           $("#pager").kendoPager({
               dataSource: assetsDS
           });
              
           /** Add handler to run asset search when search button is clicked */
		$('#btnHardwareSearch').click(function(event) {
			event.preventDefault();
			assetsDS.transport.options.read.url = "${pageContext.request.contextPath}/api/search/hardware/" + $('#txtHardwareSearch').val();
			assetsDS.read();
			var pager = $("#pager").data("kendoPager");
			pager.page(1);
		});
		
		/** Called when an asset is selected in the list */
		function listSelectionChange() {
			var listView = assetsDS.view();
			var selected = $.map(this.select(), function(item) {
				return listView[$(item).index()];
			});

			if (selected.length > 0) {
				$('#selectedAssetId').val(selected[0].id);

				// Set the selected asset info on the second page.
				var template = kendo.template($("#assetStandalone").html());
				$("#selDeviceAsset").html(template(selected[0]));
			} else {
				$('#selectedAssetId').val("");
			}				
		}
		
		/** Continue button moves carousel to next */
		$('#btnContinue').click(function(event) {
 			if ($("#selectedAssetId").val().length > 0) {
 				$('.carousel').carousel(1);
 			} else {
				bootbox.alert("Select the device hardware type first.");
			}
		});
		
		/*********************
		 * HARDWARE IDS CODE *
		 *********************/
		
		/** Hardware ids list */
		var hardwareIds = new Array();
		
		/** DataSource for hardware ids */
		var hardwareIdsDS = new kendo.data.DataSource({
			data: hardwareIds
		});

		/** Create the hardware id list */
		$("#hwIdList").kendoListView({
			dataSource : hardwareIdsDS,
			selectable : "single",
			template : kendo.template($("#hardwareIdInList").html())
		});
		
		/** Create the carousel and pause it */
        $('.carousel').carousel({
            interval: 2000
        });
        $('.carousel').carousel('pause');
           
           /** Add handler to copy entered hardware id into the id list */
		$('#btnAddHardwareId').click(function(event) {
			if ($('#txtHardwareId').val().length > 0) {
				var idToAdd = {hardwareId: $('#txtHardwareId').val()};
				hardwareIdsDS.add(idToAdd);
			}
		});
		
		/** Back button moves carousel to first */
		$('#btnBack').click(function(event) {
			$('.carousel').carousel(0);
		});
		
		/** Button clicked to submit data and create devices */
		$('#btnCreateDevices').click(function(event) {
			var deviceData = {
				deviceAssetId: $('#selectedAssetId').val(),
				comment: $('#txtComment').val(),
				details: hardwareIdsDS.data()
			}
			$.postJSON("${pageContext.request.contextPath}/api/devices", deviceData, onCreateSuccess, onCreateFail);
		});
		
		/** Clear form items */
		function clearForm() {
			$('#txtHardwareId').val("");
			$('#txtComment').val("");
			hardwareIdsDS.data(new Array());
		}
		
		/** Handle successful call to create devices */
		function onCreateSuccess(e) {
			$('#submitResult').html(createAlertHtml("alert-success", 
				"Devices were created successfully. They can be found in the unassigned devices list." +
				"<div class='alert-buttons'>" +
				"<a class='btn btn-success' href='unassigned'><i class='icon-list icon-white'></i> View Unassigned</a>" +
				"</div>"));
			clearForm();
		}
		
		/** Handle failed call to create devices */
		function onCreateFail(jqXHR, textStatus, errorThrown) {
			var respError = jqXHR.getResponseHeader("SiteWhere-Error");
			var respErrorCode = jqXHR.getResponseHeader("SiteWhere-Error-Code");
			if (respErrorCode == "DuplicateHardwareId") {
				$('#submitResult').html(createAlertHtml("alert-error", 
					"Devices were not created. One or more of the hardware ids are already in use."));
			} else {
				$('#submitResult').html(createAlertHtml("alert-error", 
					"Devices were not created. " + respError));
			}
		}
		
		/** Creates a div with an alert */
		function createAlertHtml(type, message) {
			var result = "<div class=\"alert alert-block " + type + "\">" + message + "</div>";
			return result;
		}
		
		/** Clear any cached data */
		clearForm();
	});
</script>
<style scoped>
	#listView {
		height: 360px;
	}
	#hwIdList {
		height: 350px;
		width: 100%;
		border: 1px solid #ccc;
		overflow: auto;
		padding: 3px;
	}
	#selectedAssetBlock {
		height: 170px;
	}
	#txtComment {
		min-height: 179px;
		width: 97%;
	}
	.asset {
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
	.asset img {
		float: left;
		border: 1px solid #eee;
		bottom: 15px;
		top: 15px;
		margin-right: 15px;
		max-height: 120px;
	}
	.asset.asset-standalone {
		margin: 0px;
		width: 100%;
		cursor: auto;
	}
	*.asset.k-state-selected {
       	background-color: #fff;
       	color: #333;
       	border: 3px solid #00f;
	}
	.hardwareId {
		float: left;
		width: 98%;
		padding: 4px;
		font-size: 12pt;
		cursor: pointer;
	}
	.k-listview:after {
       	content: ".";
		display: block;
		height: 0;
		clear: both;
		visibility: hidden;
	}
	.k-listview {
		border: 1px solid #eee;
       	padding: 0;
       	min-width: 0;
	}		
</style>
<%@ include file="../bottom.inc" %>