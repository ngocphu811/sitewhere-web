<!-- Dialog for device update -->
<div id="du-dialog" class="modal hide">
	<div class="modal-header k-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>Update Device</h3>
	</div>
	<div class="modal-body">
		<div id="du-tabs">
			<ul>
				<li class="k-state-active">Device Details</li>
				<li>Metadata</li>
			</ul>
			<div>
				<div style="padding-top: 20px;">
					<div id="du-static-header"></div>
				</div>
				<form id="du-general-form" class="form-horizontal" style="padding-top: 10px;">
					<div class="control-group">
						<label class="control-label" for="du-comments">Comments</label>
						<div class="controls">
							<textarea id="du-comments" class="input-xlarge" style="height: 10em;"></textarea>
						</div>
					</div>
					<input type="hidden" id="du-hardware-id"/>
					<input type="hidden" id="du-asset-id"/>
				</form>
			</div>
			<div>
				<div id="du-metadata"></div>
            </div>
		</div>
	</div>
	<div class="modal-footer">
		<a href="javascript:void(0)" class="btn" data-dismiss="modal">Cancel</a> 
		<a id="du-dialog-submit" href="javascript:void(0)" class="btn btn-primary">Save</a>
	</div>
</div>