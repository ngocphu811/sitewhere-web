/*
 * Copyright (c) Reveal Technologies, LLC. All rights reserved. http://www.reveal-tech.com
 *
 * The software in this package is published under the terms of the CPAL v1.0
 * license, a copy of which has been included with this distribution in the
 * LICENSE.txt file.
 */
package com.sitewhere.web.mvc;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * Spring MVC controller for SiteWhere web application.
 * 
 * @author dadams
 */
@Controller
public class SiteWhereController {

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
	 * Display the "list devices" page.
	 * 
	 * @return
	 */
	@RequestMapping("/devices/list")
	public ModelAndView listDevices() {
		return new ModelAndView("devices/list");
	}
}