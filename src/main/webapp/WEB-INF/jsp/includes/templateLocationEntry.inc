<!-- Template for location row -->
<script type="text/x-kendo-tmpl" id="tpl-location-entry">
	<tr class="sw-list-entry gradient-bg">
		<td>
			<div>
				<span class="ellipsis" style="max-width: 180px; display: inline-block; vertical-align: middle; line-height: normal">
					#:assetName#</span>
				<i class="icon-circle-arrow-right sw-action-glyph sw-view-glyph" title="View Assignment"
					style="vertical-align: middle;" onclick="onViewAssignment(event, '#:deviceAssignmentToken#')"></i>
			</div>
		</td>
		<td>
			<div>#= kendo.toString(latitude, "\\#\\#\\#.0000") + ", " + kendo.toString(longitude, "\\#\\#\\#.0000")#</div>
		</td>
		<td>#= formattedDate(eventDate) #</td>
		<td>#= formattedDate(receivedDate) #</td>
	</tr>
</script>