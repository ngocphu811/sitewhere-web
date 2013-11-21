<!-- Template for measurements row -->
<script type="text/x-kendo-tmpl" id="tpl-measurements-entry">
	<tr class="sw-list-entry row-gradient">
		<td>
			<div>#= formattedMetadata(measurements) #</div>
		</td>
		<td>#= formattedDate(eventDate) #</td>
		<td>#= formattedDate(receivedDate) #</td>
	</tr>
</script>