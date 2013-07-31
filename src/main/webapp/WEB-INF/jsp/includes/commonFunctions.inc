<script>
	/** Common callback function for async functions */
	var swSuccessCallback;

	/** Delete a device based on its hardware id */
	function swDeviceDelete(hardwareId, successCallback) {
		swSuccessCallback = successCallback;
		bootbox.confirm("Delete device?", function(result) {
			if (result) {
				$.deleteJSON("${pageContext.request.contextPath}/api/devices/"
						+ hardwareId + "?force=true", swDeleteSuccess,
						swDeleteFail);
			}
		});
	}

	/** Handle successful device delete */
	function swDeleteSuccess() {
		if (swSuccessCallback != null) {
			swSuccessCallback();
		}
	}

	/** Handle failed device delete */
	function swDeleteFail(jqXHR, textStatus, errorThrown) {
		handleError(jqXHR, "Unable to delete device.");
	}

	/** Release an assignment based on its unique token */
	function swReleaseAssignment(token, successCallback) {
		swSuccessCallback = successCallback;
		bootbox.confirm("Release device assignment?", function(result) {
			if (result) {
				$.postJSON("${pageContext.request.contextPath}/api/assignments/"
					+ token + "/end", null, swDeleteSuccess, swDeleteFail);
			}
		});
	}

	/** Handle successful assignment release */
	function swReleaseSuccess() {
		if (swSuccessCallback != null) {
			swSuccessCallback();
		}
	}

	/** Handle failed assignment release */
	function swReleaseFail(jqXHR, textStatus, errorThrown) {
		handleError(jqXHR, "Unable to release assignment.");
	}

	/** Report assignment missing based on its unique token */
	function swAssignmentMissing(token, successCallback) {
		swSuccessCallback = successCallback;
		bootbox.confirm("Report assignment missing?", function(result) {
			if (result) {
				$.postJSON("${pageContext.request.contextPath}/api/assignments/"
					+ token + "/missing", null, swAssignmentMissingSuccess, swAssignmentMissingFail);
			}
		});
	}

	/** Handle successful missing report */
	function swAssignmentMissingSuccess() {
		if (swSuccessCallback != null) {
			swSuccessCallback();
		}
	}

	/** Handle failed missing report */
	function swAssignmentMissingFail(jqXHR, textStatus, errorThrown) {
		handleError(jqXHR, "Unable to mark assignment as missing.");
	}
</script>