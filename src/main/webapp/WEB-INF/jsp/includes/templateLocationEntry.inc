<style>

.sw-location-entry {
	font-size: 10pt;
}

.k-grid td {
	overflow: visible;
	border-style: none;
}
</style>

<!-- Template for location row -->
<script type="text/x-kendo-tmpl" id="tpl-location-entry">
	<tr class="sw-location-entry gradient-bg">
		<td>
			<div>#:assetName#</div>
		</td>
		<td>
			<div class="btn-group" style="float: right; margin-top: -2px;">
				<a class="btn btn-mini" style="padding: 1px 4px;" href="javascript:void(0)" data-toggle="dropdown">
					<i class="icon-align-justify"></i></a>
 				<button class="btn btn-mini dropdown-toggle" data-toggle="dropdown">
					<span class="caret"></span>
				</button>				
				<ul class="dropdown-menu" style="max-height: 150px; max-width: 500px; overflow: auto; padding: 15px;">
					<li><b>field.name</b>: field.value</li>
					<li><b>field.name</b>: field.value</li>
					<li><b>field.name</b>: field.value</li>
					<li><b>field.name.longer</b>: field.value.longer</li>
				</ul>
			</div>
			<div>#= kendo.toString(latitude, "\\#\\#\\#.0000") + ", " + kendo.toString(longitude, "\\#\\#\\#.0000")#</div>
		</td>
		<td>#= formattedDate(eventDate) #</td>
		<td>#= formattedDate(receivedDate) #</td>
		<td>
		</td>
	</tr>
</script>