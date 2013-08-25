<!-- Template for location row -->
<script type="text/x-kendo-tmpl" id="tpl-alert-entry">
	<tr class="sw-list-entry gradient-bg">
		<td class="ellipsis" style="max-width: 90px;" title="#:assetName#">#:assetName#</td>
		<td class="ellipsis" style="max-width: 90px;" title="#:type#">#:type#</td>
		<td class="ellipsis" style="max-width: 250px;" title="#:message#">#:message#</td>
		<td class="ellipsis">#:source#</td>
# if (data.acknowledged) { # 
		<td><i class="icon-ok"></i></td>
# } else { #
		<td></td>
# } #
		<td>#= formattedDate(eventDate) #</td>
		<td>#= formattedDate(receivedDate) #</td>
	</tr>
</script>