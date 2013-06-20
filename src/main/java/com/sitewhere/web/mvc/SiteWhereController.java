/*
* $Id$
* --------------------------------------------------------------------------------------
* Copyright (c) Reveal Technologies, LLC. All rights reserved. http://www.reveal-tech.com
*
* The software in this package is published under the terms of the CPAL v1.0
* license, a copy of which has been included with this distribution in the
* LICENSE.txt file.
*/
package com.sitewhere.web.mvc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.sitewhere.server.SiteWhereServer;
import com.sitewhere.spi.SiteWhereException;
import com.sitewhere.spi.asset.AssetType;
import com.sitewhere.spi.asset.IAsset;
import com.sitewhere.spi.asset.IHardwareAsset;
import com.sitewhere.spi.device.IDevice;
import com.sitewhere.spi.device.IDeviceAssignment;
import com.sitewhere.spi.device.ISite;
import com.sitewhere.web.helper.DeviceAssignmentHelper;

/**
 * Spring MVC controller for SiteWhere web application.
 * 
 * @author dadams
 */
@Controller
public class SiteWhereController {

	/** Static logger instance */
	private static Logger LOGGER = Logger.getLogger(SiteWhereController.class);

	/** Used for converting Java to JSON */
	private ObjectMapper mapper = new ObjectMapper();

	/**
	 * Display the home page.
	 * 
	 * @return
	 */
	@RequestMapping("/home")
	public ModelAndView home() {
		return new ModelAndView("home");
	}

	/**
	 * Display the "create device" page.
	 * 
	 * @return
	 */
	@RequestMapping("/device/create")
	public ModelAndView createDevice() {
		return new ModelAndView("device/createDevice");
	}

	/**
	 * Display the "create assignment" page.
	 * 
	 * @return
	 */
	@RequestMapping("/device/assign")
	public ModelAndView createAssignment(@RequestParam("hardwareId") String hardwareId) {
		try {
			IDevice device = SiteWhereServer.getInstance().getDeviceManagement()
					.getDeviceByHardwareId(hardwareId);
			IHardwareAsset asset = (IHardwareAsset) SiteWhereServer.getInstance().getAssetModuleManager()
					.getAssetById(AssetType.Hardware, device.getAssetId());
			List<ISite> sites = SiteWhereServer.getInstance().getDeviceManagement().listSites();
			if (sites.size() == 0) {
				return new ModelAndView("error/noSites");
			}
			Map<String, Object> data = new HashMap<String, Object>();
			data.put("device", device);
			data.put("deviceAsset", asset);
			return new ModelAndView("device/createAssignment", data);
		} catch (SiteWhereException e) {
			LOGGER.error(e);
			return null;
		} catch (Throwable e) {
			LOGGER.error(e);
			return null;
		}
	}

	/**
	 * Display the "view assignment" page.
	 * 
	 * @return
	 */
	@RequestMapping("/device/assignment")
	public ModelAndView viewAssignment(@RequestParam("token") String token) {
		try {
			IDeviceAssignment assignment = SiteWhereServer.getInstance().getDeviceManagement()
					.getDeviceAssignmentByToken(token);
			IDevice device = SiteWhereServer.getInstance().getDeviceManagement()
					.getDeviceForAssignment(assignment);
			ISite site = SiteWhereServer.getInstance().getDeviceManagement().getSiteForAssignment(assignment);
			IHardwareAsset asset = (IHardwareAsset) SiteWhereServer.getInstance().getAssetModuleManager()
					.getAssetById(AssetType.Hardware, device.getAssetId());
			IAsset associatedAsset = null;
			String associatedAssetJson = "null";
			if (assignment.getAssetType() != AssetType.Unassociated) {
				associatedAsset = SiteWhereServer.getInstance().getAssetModuleManager()
						.getAssetById(assignment.getAssetType(), assignment.getAssetId());
				associatedAssetJson = mapper.writeValueAsString(associatedAsset);
			}
			Map<String, Object> data = new HashMap<String, Object>();
			data.put("site", site);
			data.put("device", device);
			data.put("deviceAsset", asset);
			data.put("deviceAssignment", assignment);
			data.put("deviceAssignmentAsset", associatedAsset);
			data.put("deviceAssignmentHelper", new DeviceAssignmentHelper(assignment));
			data.put("deviceAssignmentAssetJson", associatedAssetJson);
			return new ModelAndView("device/viewAssignment", data);
		} catch (SiteWhereException e) {
			LOGGER.error(e);
			return null;
		} catch (Throwable e) {
			LOGGER.error(e);
			return null;
		}
	}

	/**
	 * Display the "view assignment" page.
	 * 
	 * @return
	 */
	@RequestMapping("/site/assignments")
	public ModelAndView viewSiteAssignments(@RequestParam("siteToken") String siteToken) {
		try {
			ISite site = SiteWhereServer.getInstance().getDeviceManagement().getSiteByToken(siteToken);
			if (site == null) {
				return null;
			}
			Map<String, Object> data = new HashMap<String, Object>();
			data.put("site", site);
			return new ModelAndView("site/listAssignments", data);
		} catch (SiteWhereException e) {
			LOGGER.error(e);
			return null;
		} catch (Throwable e) {
			LOGGER.error(e);
			return null;
		}
	}

	/**
	 * Display the "list unassigned devices" page.
	 * 
	 * @return
	 */
	@RequestMapping("/device/unassigned")
	public ModelAndView unassignedDevices() {
		return new ModelAndView("device/unassignedDevices");
	}

	/**
	 * Display the "list sites" page.
	 * 
	 * @return
	 */
	@RequestMapping("/site/list")
	public ModelAndView listSites() {
		return new ModelAndView("site/listSites");
	}
}