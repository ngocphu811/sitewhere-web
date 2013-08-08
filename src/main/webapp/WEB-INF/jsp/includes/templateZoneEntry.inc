<style>
.sw-location-entry {
	font-size: 10pt;
	cursor: pointer;
}
</style>

<!-- Template for location row -->
<script type="text/x-kendo-tmpl" id="tpl-zone-entry">
	<tr class="sw-location-entry gradient-bg">
		<td>#:name#</td>
		<td>appearance</td>
		<td>#= formattedDate(createdDate) #</td>
		<td>#= formattedDate(updatedDate) #</td>
	</tr>
</script>