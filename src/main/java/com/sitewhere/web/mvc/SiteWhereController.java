/*
 * Copyright (c) Reveal Technologies, LLC. All rights reserved. http://www.reveal-tech.com
 *
 * The software in this package is published under the terms of the CPAL v1.0
 * license, a copy of which has been included with this distribution in the
 * LICENSE.txt file.
 */
package com.sitewhere.web.mvc;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.sitewhere.server.SiteWhereServer;
import com.sitewhere.spi.SiteWhereException;
import com.sitewhere.spi.device.IDevice;
import com.sitewhere.spi.device.IDeviceAssignment;
import com.sitewhere.spi.device.IDeviceManagement;
import com.sitewhere.spi.device.ISite;

/**
 * Spring MVC controller for SiteWhere web application.
 * 
 * @author dadams
 */
@Controller
public class SiteWhereController {

	/** Static logger instance */
	private static Logger LOGGER = Logger.getLogger(SiteWhereController.class);

	/**
	 * Display the "list sites" page.
	 * 
	 * @return
	 */
	@RequestMapping("/sites/list")
	public ModelAndView listSites() {
		return new ModelAndView("sites/list");
	}

	/**
	 * Display the "site detail" page.
	 * 
	 * @param siteToken
	 * @return
	 */
	@RequestMapping("/sites/detail")
	public ModelAndView siteDetail(@RequestParam("siteToken") String siteToken) {
		if (siteToken != null) {
			IDeviceManagement management = SiteWhereServer.getInstance().getDeviceManagement();
			try {
				ISite site = management.getSiteByToken(siteToken);
				if (site != null) {
					Map<String, Object> data = new HashMap<String, Object>();
					data.put("site", site);
					return new ModelAndView("sites/detail", data);
				}
				return showError("Site for token '" + siteToken + "' not found.");
			} catch (SiteWhereException e) {
				LOGGER.error(e);
				return showError(e.getMessage());
			}
		}
		return showError("No site token passed.");
	}

	/**
	 * Display the "assignment detail" page.
	 * 
	 * @param token
	 * @return
	 */
	@RequestMapping("/assignments/detail")
	public ModelAndView assignmentDetail(@RequestParam("token") String token) {
		if (token != null) {
			IDeviceManagement management = SiteWhereServer.getInstance().getDeviceManagement();
			try {
				IDeviceAssignment assignment = management.getDeviceAssignmentByToken(token);
				if (assignment != null) {
					Map<String, Object> data = new HashMap<String, Object>();
					data.put("assignment", assignment);
					return new ModelAndView("assignments/detail", data);
				}
				return showError("Assignment for token '" + token + "' not found.");
			} catch (SiteWhereException e) {
				LOGGER.error(e);
				return showError(e.getMessage());
			}
		}
		return showError("No assignment token passed.");
	}

	/**
	 * Display the "assignment emulator" page.
	 * 
	 * @param token
	 * @return
	 */
	@RequestMapping("/assignments/emulator")
	public ModelAndView assignmentEmulator(@RequestParam("token") String token) {
		if (token != null) {
			IDeviceManagement management = SiteWhereServer.getInstance().getDeviceManagement();
			try {
				IDeviceAssignment assignment = management.getDeviceAssignmentByToken(token);
				if (assignment != null) {
					Map<String, Object> data = new HashMap<String, Object>();
					data.put("assignment", assignment);
					return new ModelAndView("assignments/emulator", data);
				}
				return showError("Assignment for token '" + token + "' not found.");
			} catch (SiteWhereException e) {
				LOGGER.error(e);
				return showError(e.getMessage());
			}
		}
		return showError("No assignment token passed.");
	}

	/**
	 * Display the "list devices" page.
	 * 
	 * @return
	 */
	@RequestMapping("/devices/list")
	public ModelAndView listDevices() {
		return new ModelAndView("devices/list");
	}

	/**
	 * Display the "device detail" page.
	 * 
	 * @param hardwareId
	 * @return
	 */
	@RequestMapping("/devices/detail")
	public ModelAndView deviceDetail(@RequestParam("hardwareId") String hardwareId) {
		if (hardwareId != null) {
			IDeviceManagement management = SiteWhereServer.getInstance().getDeviceManagement();
			try {
				IDevice device = management.getDeviceByHardwareId(hardwareId);
				if (device != null) {
					Map<String, Object> data = new HashMap<String, Object>();
					data.put("device", device);
					return new ModelAndView("devices/detail", data);
				}
				return showError("Device for hardware id '" + hardwareId + "' not found.");
			} catch (SiteWhereException e) {
				LOGGER.error(e);
				return showError(e.getMessage());
			}
		}
		return showError("No hardware id token passed.");
	}

	/**
	 * Returns a {@link ModelAndView} that will display an error message.
	 * 
	 * @param message
	 * @return
	 */
	protected ModelAndView showError(String message) {
		Map<String, Object> data = new HashMap<String, Object>();
		data.put("message", message);
		return new ModelAndView("error", data);
	}
}