<!-- Template for user row -->
<script type="text/x-kendo-tmpl" id="tpl-user-entry">
	<tr class="sw-list-entry gradient-bg">
		<td class="ellipsis" style="max-width: 100px; title="#:username#"">#:username#</td>
		<td class="ellipsis" style="max-width: 100px;" title="#:firstName#">#:firstName#</td>
		<td class="ellipsis" style="max-width: 100px;" title="#:lastName#">#:lastName#</td>
		<td class="ellipsis" style="max-width: 66px;" title="#:status#">#:status#</td>
		<td class="ellipsis" style="max-width: 100px;">#= formattedDate(lastLogin) #</td>
		<td class="ellipsis" style="max-width: 100px;">#= formattedDate(createdDate) #</td>
		<td class="ellipsis" style="max-width: 100px;">#= formattedDate(updatedDate) #</td>
	</tr>
</script>