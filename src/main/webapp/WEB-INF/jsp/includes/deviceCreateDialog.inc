<!-- Dialog for creating a device -->
<div id="dc-dialog" class="modal hide">
	<div class="modal-header k-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		<h3>Create Device</h3>
	</div>
	<div class="modal-body">
		<div id="dc-tabs">
			<ul>
				<li class="k-state-active">Device Details</li>
				<li>Hardware</li>
				<li>Metadata</li>
			</ul>
			<div>
				<form id="dc-general-form" class="form-horizontal" style="padding-top: 20px;">
					<div class="control-group">
						<label class="control-label" for="dc-hardware-id">Hardware Id</label>
						<div class="controls">
							<input type="text" id="dc-hardware-id" title="Hardware id" class="input-xlarge">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="dc-comments">Comments</label>
						<div class="controls">
							<textarea id="dc-comments" class="input-xlarge" style="height: 10em;"></textarea>
						</div>
					</div>
				</form>
			</div>
			<div>
				<form id="dc-hardware-form" class="form-horizontal form-search" style="padding-top: 20px;">
					<div class="control-group">
						<label class="control-label" for="dc-hardware-search">Choose Hardware Type</label>
						<div class="controls">
							<div class="input-append">
	    						<input class="input-xlarge" id="dc-hardware-search" type="text">
								<span class="add-on"><i class="icon-search"></i></span>
	    					</div>
	    				</div>
	    			</div>	
	    		</form>		
				<div id="dc-hardware-matches" style="height: 200px; overflow: auto;"></div>
				<input type="hidden" id="dc-chosen-asset-id" title="Asset type"/>
    		</div>
			<div>
				<div id="dc-metadata"></div>
            </div>
		</div>
	</div>
	<div class="modal-footer">
		<a href="javascript:void(0)" class="btn" data-dismiss="modal">Cancel</a> 
		<a id="dc-dialog-submit" href="javascript:void(0)" class="btn btn-primary">Create</a>
	</div>
</div>