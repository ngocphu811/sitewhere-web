<style>
.sw-device-list-entry {
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

.sw-device-list-entry-heading {
	font-size: 12pt;
	font-weight: bold;
	line-height: 1;
}

.sw-device-list-entry-label {
	font-size: 10pt;
	font-weight: bold;
	display: inline-block;
}

.sw-device-list-entry-logowrapper {
	float: left;
	margin-right: 15px;	
	width: 70px;
	height: 70px;
	position: relative;
}

.sw-device-list-entry-logo-tag {
	position: absolute;
	top: -2px;
	left: -4px;
}

.sw-device-list-entry-logo {
	display: block;
	margin-left: auto;
	margin-right: auto;
    max-width: 70px;
    max-height: 70px;
    border: 1px solid rgb(221, 221, 221);
}

.sw-device-list-entry-assignment {
	float: right;
	width: 320px;
	height: 100%;
	padding-left: 10px;
	margin-left: 10px;
	border-left: solid 1px #e0e0e0;
}

.sw-device-list-entry-no-assignment {
	float: right;
	width: 320px;
	height: 100%;
	padding-left: 10px;
	margin-left: 10px;
	border-left: solid 1px #e0e0e0;
	text-align: center;
}

.sw-device-list-entry-actions {
	float: right;
	width: 260px;
	height: 100%;
	padding-left: 10px;
	margin-left: 10px;
	border-left: solid 1px #e0e0e0;
	position: relative;
}
</style>

<!-- Device list item template -->
<script type="text/x-kendo-tmpl" id="tpl-device-entry">
	<div class="sw-device-list-entry gradient-bg">
		<div class="sw-device-list-entry-logowrapper">
			<img class="sw-device-list-entry-logo" src="#:assetImageUrl#" width="100"/>
			<span class="label label-info sw-device-list-entry-logo-tag">Device</span>
		</div>
		<div class="sw-device-list-entry-actions">
			<p class="ellipsis"><span class="sw-device-list-entry-label sw-min-70">Created:</span> #= formattedDate(createdDate) #</p>
			<p class="ellipsis"><span class="sw-device-list-entry-label sw-min-70">Updated:</span> #= formattedDate(updatedDate) #</p>
			<div class="btn-group btn-group-vertical" style="position: absolute; right: 0px; top: -2px;">
				<a class="btn btn-small btn-primary" title="Edit Device" 
					href="javascript:void(0)" onclick="onDeviceEditClicked(event, '#:hardwareId#');">
					<i class="icon-pencil icon-white"></i></a>
				<a class="btn btn-small btn-danger" title="Delete Device" 
					href="javascript:void(0)" onclick="onDeviceDeleteClicked(event, '#:hardwareId#')">
					<i class="icon-remove icon-white"></i></a>
				<a class="btn btn-small btn-success" title="View Device" 
					href="javascript:void(0)" onclick="onDeviceOpenClicked(event, '#:hardwareId#')">
					<i class="icon-chevron-right icon-white"></i></a>
			</div>
		</div>
# if (data.assignment) { #
		<div class="sw-device-list-entry-assignment">
# if (assignment.assetType != 'Unassociated') { #
			<div class="sw-device-list-entry-logowrapper">
				<img class="sw-device-list-entry-logo" src="#:assignment.assetImageUrl#"/>
				<span class="label label-info sw-device-list-entry-logo-tag">Asset</span>
			</div>
			<p class="sw-device-list-entry-heading ellipsis">#:assignment.assetName#</p>
# } else { #
			<div class="sw-device-list-entry-logowrapper">
				<img class="sw-device-list-entry-logo" src="#:assetImageUrl#"/>
				<span class="label label-info sw-device-list-entry-logo-tag">Unassociated</span>
			</div>
			<p class="sw-device-list-entry-heading ellipsis">Unassociated Device</p>
# } #
			<p class="ellipsis"><span class="sw-device-list-entry-label sw-min-70">Assigned:</span> #= formattedDate(assignment.activeDate) #</p>
# if (assignment.status == 'Active') { #
			<span class="sw-device-list-entry-label sw-min-70">Status:</span> 
			<div class="btn-group" style="margin-top: -6px;">
				<a class="btn btn-small dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
					Active
					<span class="caret"></span>
				</a>
				<ul class="dropdown-menu">
					<li><a tabindex="-1" href="javascript:void(0)" title="Release Assignment"
						onclick="onReleaseAssignment(event, '#:assignment.token#')">Release Assignment</a></li>
					<li><a tabindex="-1" href="javascript:void(0)" title="Report Device/Asset Missing"
						onclick="onMissingAssignment(event, '#:assignment.token#')">Report Missing</a></li>
				</ul>
			</div>
# } else if (assignment.status == 'Missing') { #
			<span class="sw-device-list-entry-label sw-min-70">Status:</span> 
			<div class="btn-group" style="margin-top: -6px;">
				<a class="btn btn-small dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
					Missing
					<span class="caret"></span>
				</a>
				<ul class="dropdown-menu">
					<li><a tabindex="-1" href="javascript:void(0)" title="Release Assignment"
						onclick="onReleaseAssignment(event, '#:assignment.token#')">Release Assignment</a></li>
				</ul>
			</div>
# } else { #
			<p class="ellipsis"><span class="sw-device-list-entry-label sw-min-70">Status:</span> #:assignment.status#</p>
# } #
		</div>
# } else { #
		<div class="sw-device-list-entry-no-assignment">
    		<div class="alert alert-info">
    			<p>Device is not currently assigned.</p>
				<a class="btn" title="Assign Device" href="javascript:void(0)" 
					onclick="acOpen(event, '#:hardwareId#', onAssignmentAdded)" style="margin-top: -4px;">Assign Device</a>
			</div>
		</div>
# } #
		<div>
			<p class="sw-device-list-entry-heading ellipsis">#:assetName#</p>
			<p class="ellipsis"><span class="sw-device-list-entry-label sw-min-40">Id:</span> #:hardwareId#</p>
			<p class="ellipsis"><span class="sw-device-list-entry-label sw-min-40">Info:</span> #:comments#</p>
		</div>
	</div>
</script>