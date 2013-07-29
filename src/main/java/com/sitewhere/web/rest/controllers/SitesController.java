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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sitewhere.rest.model.device.DeviceAlert;
import com.sitewhere.rest.model.device.DeviceAssignment;
import com.sitewhere.rest.model.device.DeviceLocation;
import com.sitewhere.rest.model.device.DeviceMeasurements;
import com.sitewhere.rest.model.device.Site;
import com.sitewhere.rest.model.device.Zone;
import com.sitewhere.rest.model.device.request.SiteCreateRequest;
import com.sitewhere.rest.model.device.request.ZoneCreateRequest;
import com.sitewhere.rest.service.search.DeviceAlertSearchResults;
import com.sitewhere.rest.service.search.DeviceAssignmentSearchResults;
import com.sitewhere.rest.service.search.DeviceLocationSearchResults;
import com.sitewhere.rest.service.search.DeviceMeasurementsSearchResults;
import com.sitewhere.rest.service.search.SearchResults;
import com.sitewhere.rest.service.search.ZoneSearchResults;
import com.sitewhere.server.SiteWhereServer;
import com.sitewhere.spi.SiteWhereException;
import com.sitewhere.spi.SiteWhereSystemException;
import com.sitewhere.spi.device.IDeviceAlert;
import com.sitewhere.spi.device.IDeviceAssignment;
import com.sitewhere.spi.device.IDeviceLocation;
import com.sitewhere.spi.device.IDeviceMeasurements;
import com.sitewhere.spi.device.ISite;
import com.sitewhere.spi.device.IZone;
import com.sitewhere.spi.error.ErrorCode;
import com.sitewhere.spi.error.ErrorLevel;
import com.sitewhere.web.rest.model.DeviceAssignmentMarshalHelper;
import com.wordnik.swagger.annotations.Api;
import com.wordnik.swagger.annotations.ApiOperation;
import com.wordnik.swagger.annotations.ApiParam;

/**
 * Controller for site operations.
 * 
 * @author Derek Adams
 */
@Controller
@RequestMapping(value = "/sites")
@Api(value = "", description = "Operations related to SiteWhere sites.")
public class SitesController extends SiteWhereController {

	/**
	 * Create a new site.
	 * 
	 * @param input
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(method = RequestMethod.POST)
	@ResponseBody
	@ApiOperation(value = "Create a new site")
	public Site createSite(@RequestBody SiteCreateRequest input) throws SiteWhereException {
		ISite site = SiteWhereServer.getInstance().getDeviceManagement().createSite(input);
		return Site.copy(site);
	}

	/**
	 * Get information for a given site based on site token.
	 * 
	 * @param siteToken
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(value = "/{siteToken}", method = RequestMethod.GET)
	@ResponseBody
	@ApiOperation(value = "Get a site by unique token")
	public Site getSiteByToken(
			@ApiParam(value = "Unique token that identifies site", required = true) @PathVariable String siteToken)
			throws SiteWhereException {
		ISite site = SiteWhereServer.getInstance().getDeviceManagement().getSiteByToken(siteToken);
		return Site.copy(site);
	}

	/**
	 * Update information for a site.
	 * 
	 * @param input
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(value = "/{siteToken}", method = RequestMethod.PUT)
	@ResponseBody
	@ApiOperation(value = "Update an existing site")
	public Site updateSite(
			@ApiParam(value = "Unique token that identifies site", required = true) @PathVariable String siteToken,
			@RequestBody SiteCreateRequest request) throws SiteWhereException {
		ISite site = SiteWhereServer.getInstance().getDeviceManagement().updateSite(siteToken, request);
		return Site.copy(site);
	}

	/**
	 * Delete information for a given site based on site token.
	 * 
	 * @param siteToken
	 * @param force
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(value = "/{siteToken}", method = RequestMethod.DELETE)
	@ResponseBody
	@ApiOperation(value = "Delete a site by unique token")
	public Site deleteSiteByToken(
			@ApiParam(value = "Unique token that identifies site", required = true) @PathVariable String siteToken,
			@ApiParam(value = "Delete permanently", required = false) @RequestParam(defaultValue = "false") boolean force)
			throws SiteWhereException {
		ISite site = SiteWhereServer.getInstance().getDeviceManagement().deleteSite(siteToken, force);
		return Site.copy(site);
	}

	/**
	 * List all sites and wrap as search results.
	 * 
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(method = RequestMethod.GET)
	@ResponseBody
	@ApiOperation(value = "List all sites")
	public SearchResults<Site> listSites() throws SiteWhereException {
		List<Site> sitesConv = new ArrayList<Site>();
		List<ISite> sites = SiteWhereServer.getInstance().getDeviceManagement().listSites();
		for (ISite site : sites) {
			sitesConv.add(Site.copy(site));
		}
		SearchResults<Site> results = new SearchResults<Site>(sitesConv);
		return results;
	}

	/**
	 * Get device measurements for a given site.
	 * 
	 * @param siteToken
	 * @param count
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(value = "/{siteToken}/measurements", method = RequestMethod.GET)
	@ResponseBody
	@ApiOperation(value = "List measurements associated with a site")
	public DeviceMeasurementsSearchResults listDeviceMeasurementsForSite(
			@ApiParam(value = "Unique token that identifies site", required = true) @PathVariable String siteToken,
			@ApiParam(value = "Maximum number of matches to return", required = false, defaultValue = "100") @RequestParam(defaultValue = "100") int count)
			throws SiteWhereException {
		List<IDeviceMeasurements> matches = SiteWhereServer.getInstance().getDeviceManagement()
				.listDeviceMeasurementsForSite(siteToken, count);
		List<DeviceMeasurements> converted = new ArrayList<DeviceMeasurements>();
		for (IDeviceMeasurements measurement : matches) {
			converted.add(DeviceMeasurements.copy(measurement));
		}
		return new DeviceMeasurementsSearchResults(converted);
	}

	/**
	 * Get device locations for a given site.
	 * 
	 * @param siteToken
	 * @param count
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(value = "/{siteToken}/locations", method = RequestMethod.GET)
	@ResponseBody
	@ApiOperation(value = "List locations associated with a site")
	public DeviceLocationSearchResults listDeviceLocationsForSite(
			@ApiParam(value = "Unique token that identifies site", required = true) @PathVariable String siteToken,
			@ApiParam(value = "Maximum number of matches to return", required = false, defaultValue = "100") @RequestParam(defaultValue = "100") int count)
			throws SiteWhereException {
		List<IDeviceLocation> matches = SiteWhereServer.getInstance().getDeviceManagement()
				.listDeviceLocationsForSite(siteToken, count);
		List<DeviceLocation> converted = new ArrayList<DeviceLocation>();
		for (IDeviceLocation location : matches) {
			converted.add(DeviceLocation.copy(location));
		}
		return new DeviceLocationSearchResults(converted);
	}

	/**
	 * Get device alerts for a given site.
	 * 
	 * @param siteToken
	 * @param count
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(value = "/{siteToken}/alerts", method = RequestMethod.GET)
	@ResponseBody
	@ApiOperation(value = "List alerts associated with a site")
	public DeviceAlertSearchResults listDeviceAlertsForSite(
			@ApiParam(value = "Unique token that identifies site", required = true) @PathVariable String siteToken,
			@ApiParam(value = "Maximum number of matches to return", required = false, defaultValue = "100") @RequestParam(defaultValue = "100") int count)
			throws SiteWhereException {
		List<IDeviceAlert> matches = SiteWhereServer.getInstance().getDeviceManagement()
				.listDeviceAlertsForSite(siteToken, count);
		List<DeviceAlert> converted = new ArrayList<DeviceAlert>();
		for (IDeviceAlert alert : matches) {
			converted.add(DeviceAlert.copy(alert));
		}
		return new DeviceAlertSearchResults(converted);
	}

	/**
	 * Find device assignments associated with a site.
	 * 
	 * @param siteToken
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(value = "/{siteToken}/assignments", method = RequestMethod.GET)
	@ResponseBody
	@ApiOperation(value = "List device assignments associated with a site")
	public DeviceAssignmentSearchResults findAssignmentsForSite(
			@ApiParam(value = "Unique token that identifies site", required = true) @PathVariable String siteToken,
			@ApiParam(value = "Include detailed device information", required = false) @RequestParam(defaultValue = "false") boolean includeDevice,
			@ApiParam(value = "Max records to return", required = false) @RequestParam(defaultValue = "100") int count)
			throws SiteWhereException {
		List<IDeviceAssignment> matches = SiteWhereServer.getInstance().getDeviceManagement()
				.getDeviceAssignmentsForSite(siteToken);
		DeviceAssignmentMarshalHelper helper = new DeviceAssignmentMarshalHelper();
		helper.setIncludeAsset(false);
		helper.setIncludeDevice(includeDevice);
		helper.setIncludeSite(false);
		List<DeviceAssignment> converted = new ArrayList<DeviceAssignment>();
		for (IDeviceAssignment assignment : matches) {
			converted.add(helper.convert(assignment, SiteWhereServer.getInstance().getAssetModuleManager()));
		}
		return new DeviceAssignmentSearchResults(converted);
	}

	/**
	 * Create a new zone for a site.
	 * 
	 * @param input
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(value = "/{siteToken}/zones", method = RequestMethod.POST)
	@ResponseBody
	@ApiOperation(value = "Create a new zone associated with a site")
	public Zone createZone(
			@ApiParam(value = "Unique site token", required = true) @PathVariable String siteToken,
			@RequestBody ZoneCreateRequest request) throws SiteWhereException {
		ISite site = SiteWhereServer.getInstance().getDeviceManagement().getSiteByToken(siteToken);
		if (site == null) {
			throw new SiteWhereSystemException(ErrorCode.InvalidSiteToken, ErrorLevel.ERROR);
		}
		IZone zone = SiteWhereServer.getInstance().getDeviceManagement().createZone(site, request);
		return Zone.copy(zone);
	}

	/**
	 * List all zones for a site.
	 * 
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(value = "/{siteToken}/zones", method = RequestMethod.GET)
	@ResponseBody
	@ApiOperation(value = "List zones associated with a site")
	public ZoneSearchResults listZonesForSite(
			@ApiParam(value = "Unique token that identifies site", required = true) @PathVariable String siteToken)
			throws SiteWhereException {
		List<Zone> conv = new ArrayList<Zone>();
		List<IZone> zones = SiteWhereServer.getInstance().getDeviceManagement().listZones(siteToken);
		for (IZone zone : zones) {
			conv.add(Zone.copy(zone));
		}
		ZoneSearchResults results = new ZoneSearchResults(conv);
		return results;
	}
}