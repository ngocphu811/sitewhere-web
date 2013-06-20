package com.sitewhere.web.helper;

import java.text.SimpleDateFormat;

import com.sitewhere.spi.device.IDeviceAssignment;

/**
 * Helps with screen presentation of a device asset.
 * 
 * @author dadams
 */
public class DeviceAssignmentHelper {

	/** Wrapped device assignment */
	private IDeviceAssignment assignment;

	/** Formatter used for displaying dates */
	private SimpleDateFormat formatter = new SimpleDateFormat(SiteWhereWebDefaults.DEFAULT_DATE_FORMAT);

	public DeviceAssignmentHelper(IDeviceAssignment assignment) {
		this.assignment = assignment;
	}

	/**
	 * Get the active date as a formatted string.
	 * 
	 * @return
	 */
	public String getActiveDate() {
		if (getAssignment().getActiveDate() == null) {
			return "";
		}
		return formatter.format(getAssignment().getActiveDate().getTime());
	}

	/**
	 * Get the released date as a formatted string.
	 * 
	 * @return
	 */
	public String getReleasedDate() {
		if (getAssignment().getReleasedDate() == null) {
			return "";
		}
		return formatter.format(getAssignment().getReleasedDate().getTime());
	}

	/**
	 * Get a string representation of the assignment status.
	 * 
	 * @return
	 */
	public String getStatus() {
		return getAssignment().getStatus().toString();
	}

	/**
	 * Get a string representation of the asset type.
	 * 
	 * @return
	 */
	public String getAssetType() {
		return getAssignment().getAssetType().toString();
	}

	protected IDeviceAssignment getAssignment() {
		return assignment;
	}

	protected void setAssignment(IDeviceAssignment assignment) {
		this.assignment = assignment;
	}
}