<style>
.sw-location-entry {
	font-size: 10pt;
}
</style>

<!-- Template for location row -->
<script type="text/x-kendo-tmpl" id="tpl-zone-entry">
	<tr class="sw-location-entry gradient-bg">
		<td class="ellipsis" style="max-width: 200px;">#:name#</td>
		<td>#:token#</td>
		<td>
			<div style="width: 100%; height: 100% margin: 3px; border: 2px solid #= borderColor #">
				<div style="width: 100%; height: 15px; background-color: #= fillColor #; opacity: #= opacity #"></div>
			</div>
		</td>
		<td>#= formattedDate(createdDate) #</td>
		<td>#= formattedDate(updatedDate) #</td>
	</tr>
</script>