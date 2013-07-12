/*
* $Id$
* --------------------------------------------------------------------------------------
* Copyright (c) Reveal Technologies, LLC. All rights reserved. http://www.reveal-tech.com
*
* The software in this package is published under the terms of the CPAL v1.0
* license, a copy of which has been included with this distribution in the
* LICENSE.txt file.
*/
package com.sitewhere.web.rest.controllers;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sitewhere.core.device.InterpolatedHistoryBuilder;
import com.sitewhere.core.device.Utils;
import com.sitewhere.rest.model.device.DeviceAlert;
import com.sitewhere.rest.model.device.DeviceLocation;
import com.sitewhere.rest.model.device.InterpolatedAssignmentHistory;
import com.sitewhere.rest.service.search.DeviceLocationSearchResults;
import com.sitewhere.server.SiteWhereServer;
import com.sitewhere.spi.SiteWhereException;
import com.sitewhere.spi.device.IDeviceAlert;
import com.sitewhere.spi.device.IDeviceAssignment;
import com.sitewhere.spi.device.IDeviceLocation;
import com.sitewhere.web.rest.model.AssignmentHistoryRequest;
import com.wordnik.swagger.annotations.Api;
import com.wordnik.swagger.annotations.ApiOperation;

/**
 * Controller for location operations.
 * 
 * @author Derek Adams
 */
@Controller
@RequestMapping(value = "/locations")
@Api(value = "", description = "Operations related to SiteWhere assignment locations.")
public class LocationsController extends SiteWhereController {

	/**
	 * Add an alert and associate it with the given location.
	 * 
	 * @param alert
	 * @param locationId
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(value = "/{locationId}/alerts", method = RequestMethod.POST)
	@ResponseBody
	@ApiOperation(value = "Add alert for an existing location")
	public DeviceAlert addAlertForAssignmentLocation(@RequestBody DeviceAlert alert,
			@PathVariable String locationId) throws SiteWhereException {
		IDeviceAssignment assignment = SiteWhereServer.getInstance().getDeviceManagement()
				.getDeviceAssignmentByToken(alert.getDeviceAssignmentToken());
		alert.setAssetName(Utils.getAssetNameForAssignment(assignment));
		IDeviceAlert result = SiteWhereServer.getInstance().getDeviceManagement()
				.addAlertForLocation(locationId, alert);
		return DeviceAlert.copy(result);
	}

	/**
	 * Gets an interpolated history of locations derived from real locations within the search time period.
	 * 
	 * @param input
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(value = "/history/interpolated", method = RequestMethod.POST)
	@ResponseBody
	@ApiOperation(value = "Get the interpolated assignment location history based on criteria")
	public List<InterpolatedAssignmentHistory> getInterpolatedHistory(
			@RequestBody AssignmentHistoryRequest input) throws SiteWhereException {
		List<IDeviceLocation> matches = SiteWhereServer.getInstance().getDeviceManagement()
				.listDeviceLocations(input.getAssignmentTokens(), input.getStartDate(), input.getEndDate());
		InterpolatedHistoryBuilder builder = new InterpolatedHistoryBuilder();
		return builder.build(matches);
	}

	@RequestMapping(value = "/history", method = RequestMethod.POST)
	@ResponseBody
	@ApiOperation(value = "Get the location history for assignments based on criteria")
	public DeviceLocationSearchResults getDeviceAssignmentsLocationHistory(
			@RequestBody AssignmentHistoryRequest input) throws SiteWhereException {
		List<IDeviceLocation> matches = SiteWhereServer.getInstance().getDeviceManagement()
				.listDeviceLocations(input.getAssignmentTokens(), input.getStartDate(), input.getEndDate());
		List<DeviceLocation> converted = new ArrayList<DeviceLocation>();
		for (IDeviceLocation location : matches) {
			converted.add(DeviceLocation.copy(location));
		}
		return new DeviceLocationSearchResults(converted);
	}
}