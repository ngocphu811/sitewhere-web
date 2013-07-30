<!-- Dialog for creating a device -->
<div id="ac-dialog" class="modal hide">
	<div class="modal-header k-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3 id="dialog-header">Assign Device</h3>
	</div>
	<div class="modal-body">
		<div id="create-tabs">
			<ul>
				<li class="k-state-active">Assignment Details</li>
				<li>Metadata</li>
			</ul>
			<div>
				<form id="ac-general-form" class="form-horizontal" style="padding-top: 20px;">
					<div class="control-group">
						<label class="control-label" for="device-hardware-id">Hardware Id</label>
						<div class="controls">
							<input type="text" id="device-hardware-id" title="Hardware id" class="input-xlarge">
						</div>
					</div>
				</form>
			</div>
			<div>
				<div id="ac-metadata"></div>
            </div>
		</div>
	</div>
	<div class="modal-footer">
		<a href="javascript:void(0)" class="btn" data-dismiss="modal">Cancel</a> 
		<a id="ac-submit" href="javascript:void(0)" class="btn btn-primary">Assign</a>
	</div>
</div>