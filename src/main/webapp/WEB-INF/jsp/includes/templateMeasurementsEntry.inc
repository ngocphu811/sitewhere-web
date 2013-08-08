<style>
.sw-measurements-entry {
	font-size: 10pt;
	cursor: pointer;
}
</style>

<!-- Template for location row -->
<script type="text/x-kendo-tmpl" id="tpl-measurements-entry">
	<tr class="sw-measurements-entry gradient-bg">
		<td>
			<div>#:assetName#</div>
		</td>
		<td>
			<div>#= formattedMetadata(measurements) #</div>
		</td>
		<td>#= formattedDate(eventDate) #</td>
		<td>#= formattedDate(receivedDate) #</td>
	</tr>
</script>