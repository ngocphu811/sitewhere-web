package com.sitewhere.web.rest.controllers;

import com.sitewhere.rest.model.asset.HardwareAsset;
import com.sitewhere.rest.model.asset.PersonAsset;
import com.sitewhere.server.SiteWhereServer;
import com.sitewhere.spi.SiteWhereException;
import com.sitewhere.spi.asset.IAsset;
import com.sitewhere.spi.device.IDeviceAssignment;

/**
 * Utility methods.
 * 
 * @author Derek Adams
 */
public class Utils {

	/**
	 * Get asset name for a device assignment.
	 * 
	 * @param assignment
	 * @return
	 * @throws SiteWhereException
	 */
	public static String getAssetnameForAssignment(IDeviceAssignment assignment) throws SiteWhereException {
		IAsset asset = SiteWhereServer.getInstance().getAssetModuleManager()
				.getAssetById(assignment.getAssetType(), assignment.getAssetId());
		if (asset instanceof PersonAsset) {
			return ((PersonAsset) asset).getName();
		} else if (asset instanceof HardwareAsset) {
			return ((HardwareAsset) asset).getName();
		}
		return null;
	}
}