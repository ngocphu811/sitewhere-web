<!-- Hardware asset template -->
<script type="text/x-kendo-tmpl" id="hardware-asset-entry">
	<div class="hardware-asset gradient-bg">
		<div class="asset-entry-logowrapper">
			<img class="asset-entry-logo" src="#:imageUrl#"/>
		</div>
		<div class="ellipsis"><b>#:name#</b></div>
		<div class="ellipsis">#:description#</div>
	</div>
</script>

<!-- Person asset template -->
<script type="text/x-kendo-tmpl" id="person-asset-entry">
	<div class="person-asset gradient-bg">
		<img src="#:photoUrl#"/>
		<div><b>#:name#</b></div>
		<div><i>#:emailAddress#</i></div>
	</div>
</script>

<style>
	.hardware-asset {
		padding: 5px;
		border-bottom: 1px solid #ddd;
		cursor: pointer;
	}
	
	.hardware-asset.k-state-selected {
		padding: 5px;
		border: 2px solid #dc0000;
		color: #1a1a1a;
	}

	.hardware-asset img {
		float: left;
	}

	.asset-entry-logowrapper {
		float: left;
		margin-right: 15px;	
		width: 35px;
		height: 35px;
		background-color: #f0f0f0;
		border: 1px solid #dddddd;
		position: relative;
	}
	
	.asset-entry-logo {
		display: block;
		margin-left: auto;
		margin-right: auto;
	    max-width: 35px;
	    max-height: 35px;
	}
</style>