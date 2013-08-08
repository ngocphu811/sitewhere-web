<style>
.sw-location-entry {
	font-size: 10pt;
	cursor: pointer;
}
</style>

<!-- Template for location row -->
<script type="text/x-kendo-tmpl" id="tpl-location-entry">
	<tr class="sw-location-entry gradient-bg">
		<td>
			<div>#:assetName#</div>
		</td>
		<td>
			<div>#= kendo.toString(latitude, "\\#\\#\\#.0000") + ", " + kendo.toString(longitude, "\\#\\#\\#.0000")#</div>
		</td>
		<td>#= formattedDate(eventDate) #</td>
		<td>#= formattedDate(receivedDate) #</td>
	</tr>
</script>