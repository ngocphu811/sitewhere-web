<style>
.sw-zone-entry {
	font-size: 10pt;
}

.sw-action-glyph {
	opacity: 0.2;
	min-width: 16px;
	text-align: center;
	font-size: 14px;
	display: inline-block;
	cursor: pointer;
}

.sw-zone-entry:hover .sw-action-glyph {
	opacity: 0.5;
}

.sw-action-glyph:hover.sw-delete-glyph {
	color: #c00;
	font-size: 16px;
	opacity: 1;
}

.sw-action-glyph:hover.sw-edit-glyph {
	color: #00f;
	font-size: 16px;
	opacity: 1;
}
</style>

<!-- Template for location row -->
<script type="text/x-kendo-tmpl" id="tpl-zone-entry">
	<tr class="sw-zone-entry gradient-bg">
		<td>
			<div style="width: 15px; height: 100% margin: 3px; border: 2px solid #= borderColor #">
				<div style="width: 100%; height: 15px; background-color: #= fillColor #; opacity: #= opacity #"></div>
			</div>
		</td>
		<td class="ellipsis" style="max-width: 200px;">#:name#</td>
		<td>#:token#</td>
		<td>#= formattedDate(createdDate) #</td>
		<td>#= formattedDate(updatedDate) #</td>
		<td>
			<i class="icon-pencil sw-action-glyph sw-edit-glyph" title="Edit Zone"></i>
			<i class="icon-remove sw-action-glyph sw-delete-glyph" title="Delete Zone"></i>
		</td>
	</tr>
</script>