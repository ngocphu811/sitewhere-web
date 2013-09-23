<!-- Template for measurements row -->
<script type="text/x-kendo-tmpl" id="tpl-measurements-entry">
	<tr class="sw-list-entry gradient-bg">
		<td>
			<span class="ellipsis" style="max-width: 180px; display: inline-block; vertical-align: middle; line-height: normal">
				#:assetName#</span>
			<i class="icon-circle-arrow-right sw-action-glyph sw-view-glyph" title="View Assignment"
				style="vertical-align: middle;" onclick="onViewAssignment(event, '#:deviceAssignmentToken#')"></i>
		</td>
		<td>
			<div>#= formattedMetadata(measurements) #</div>
		</td>
		<td>#= formattedDate(eventDate) #</td>
		<td>#= formattedDate(receivedDate) #</td>
	</tr>
</script>