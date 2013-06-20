package com.sitewhere.web.rest.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sitewhere.rest.model.device.Zone;
import com.sitewhere.server.SiteWhereServer;
import com.sitewhere.spi.SiteWhereException;
import com.sitewhere.spi.device.IZone;
import com.wordnik.swagger.annotations.ApiOperation;
import com.wordnik.swagger.annotations.ApiParam;

/**
 * Controller for site operations.
 * 
 * @author Derek Adams
 */
@Controller
@RequestMapping(value = "/zones")
public class ZonesController extends SiteWhereController {

	/**
	 * Create a new zone.
	 * 
	 * @param input
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(method = RequestMethod.POST)
	@ResponseBody
	@ApiOperation(value = "Create a new zone")
	public Zone createZone(@RequestBody Zone input) throws SiteWhereException {
		IZone zone = SiteWhereServer.getInstance().getDeviceManagement().createZone(input);
		return Zone.copy(zone);
	}

	@RequestMapping(value = "/{zoneToken}", method = RequestMethod.GET)
	@ResponseBody
	@ApiOperation(value = "Get zone by unique token")
	public Zone getZone(
			@ApiParam(value = "Unique token that identifies zone", required = true) @PathVariable String zoneToken)
			throws SiteWhereException {
		IZone found = SiteWhereServer.getInstance().getDeviceManagement().getZone(zoneToken);
		return Zone.copy(found);
	}

	/**
	 * Delete an existing zone.
	 * 
	 * @param zoneToken
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(value = "/{zoneToken}", method = RequestMethod.DELETE)
	@ResponseBody
	@ApiOperation(value = "Delete zone based on unique token")
	public Zone deleteZone(
			@ApiParam(value = "Unique token that identifies zone", required = true) @PathVariable String zoneToken)
			throws SiteWhereException {
		IZone deleted = SiteWhereServer.getInstance().getDeviceManagement().deleteZone(zoneToken);
		return Zone.copy(deleted);
	}
}