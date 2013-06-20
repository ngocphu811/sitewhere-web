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

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sitewhere.rest.model.device.Device;
import com.sitewhere.rest.model.device.DeviceAssignment;
import com.sitewhere.rest.model.device.DeviceSearchCriteria;
import com.sitewhere.rest.model.device.MetadataProvider;
import com.sitewhere.rest.service.device.CreateDeviceRequest;
import com.sitewhere.rest.service.search.DeviceAssignmentSearchResults;
import com.sitewhere.rest.service.search.SearchResults;
import com.sitewhere.server.SiteWhereServer;
import com.sitewhere.spi.SiteWhereException;
import com.sitewhere.spi.SiteWhereSystemException;
import com.sitewhere.spi.asset.AssetType;
import com.sitewhere.spi.asset.IAsset;
import com.sitewhere.spi.device.IDevice;
import com.sitewhere.spi.device.IDeviceAssignment;
import com.sitewhere.spi.error.ErrorCode;
import com.sitewhere.spi.error.ErrorLevel;
import com.sitewhere.web.rest.model.DeviceAssignmentMarshalHelper;
import com.sitewhere.web.rest.model.DeviceMarshalHelper;
import com.wordnik.swagger.annotations.Api;
import com.wordnik.swagger.annotations.ApiOperation;

/**
 * Controller for device operations.
 * 
 * @author Derek Adams
 */
@Controller
@RequestMapping(value = "/devices")
@Api(value = "", description = "Operations related to SiteWhere devices.")
public class DevicesController extends SiteWhereController {

	/**
	 * Used by AJAX calls to find a device by hardware id.
	 * 
	 * @param hardwareId
	 * @return
	 */
	@RequestMapping(value = "/{hardwareId}", method = RequestMethod.GET)
	@ResponseBody
	@ApiOperation(value = "Get a device by unique hardware id")
	public Device getDeviceByHardwareId(@PathVariable String hardwareId) throws SiteWhereException {
		IDevice result = SiteWhereServer.getInstance().getDeviceManagement()
				.getDeviceByHardwareId(hardwareId);
		if (result == null) {
			throw new SiteWhereSystemException(ErrorCode.InvalidHardwareId, ErrorLevel.ERROR,
					HttpServletResponse.SC_NOT_FOUND);
		}
		DeviceMarshalHelper helper = new DeviceMarshalHelper();
		helper.setIncludeAsset(true);
		helper.setIncludeAssignment(true);
		return helper.convert(result, SiteWhereServer.getInstance().getAssetModuleManager());
	}

	/**
	 * Delete device identified by hardware id.
	 * 
	 * @param hardwareId
	 * @return
	 */
	@RequestMapping(value = "/{hardwareId}", method = RequestMethod.DELETE)
	@ResponseBody
	@ApiOperation(value = "Delete a device based on unique hardware id")
	public Device deleteDevice(@PathVariable String hardwareId) throws SiteWhereException {
		IDevice result = SiteWhereServer.getInstance().getDeviceManagement().deleteDevice(hardwareId);
		DeviceMarshalHelper helper = new DeviceMarshalHelper();
		helper.setIncludeAsset(true);
		helper.setIncludeAssignment(true);
		return helper.convert(result, SiteWhereServer.getInstance().getAssetModuleManager());
	}

	/**
	 * List device assignment history for a given device hardware id.
	 * 
	 * @param hardwareId
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(value = "/{hardwareId}/assignments", method = RequestMethod.GET)
	@ResponseBody
	@ApiOperation(value = "Get assignment history for a device")
	public DeviceAssignmentSearchResults listDeviceAssignmentHistory(@PathVariable String hardwareId)
			throws SiteWhereException {
		IDevice result = SiteWhereServer.getInstance().getDeviceManagement()
				.getDeviceByHardwareId(hardwareId);
		if (result == null) {
			throw new SiteWhereSystemException(ErrorCode.InvalidHardwareId, ErrorLevel.ERROR,
					HttpServletResponse.SC_NOT_FOUND);
		}
		List<IDeviceAssignment> history = SiteWhereServer.getInstance().getDeviceManagement()
				.getDeviceAssignmentHistory(hardwareId);
		DeviceAssignmentMarshalHelper helper = new DeviceAssignmentMarshalHelper();
		helper.setIncludeAsset(false);
		helper.setIncludeDevice(false);
		helper.setIncludeSite(true);
		List<DeviceAssignment> converted = new ArrayList<DeviceAssignment>();
		for (IDeviceAssignment assignment : history) {
			converted.add(helper.convert(assignment, SiteWhereServer.getInstance().getAssetModuleManager()));
		}
		return new DeviceAssignmentSearchResults(converted);
	}

	/**
	 * Create a device.
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST)
	@ResponseBody
	@ApiOperation(value = "Create a new device")
	public Device createDevice(@RequestBody CreateDeviceRequest request) throws SiteWhereException {
		IAsset asset = SiteWhereServer.getInstance().getAssetModuleManager()
				.getAssetById(AssetType.Hardware, request.getAssetId());
		if (asset == null) {
			throw new SiteWhereException("Device asset not found.");
		}
		Device created = new Device();
		created.setAssetId(request.getAssetId());
		created.setHardwareId(request.getHardwareId());
		created.setComments(request.getComments());
		IDevice result = SiteWhereServer.getInstance().getDeviceManagement().createDevice(created);
		DeviceMarshalHelper helper = new DeviceMarshalHelper();
		helper.setIncludeAsset(false);
		helper.setIncludeAssignment(false);
		return helper.convert(result, SiteWhereServer.getInstance().getAssetModuleManager());
	}

	/**
	 * Update metadata associated with a device.
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/{hardwareId}/metadata", method = RequestMethod.PUT)
	@ResponseBody
	@ApiOperation(value = "Update metadata associated with a device")
	public Device updateDeviceMetadata(@PathVariable String hardwareId, @RequestBody MetadataProvider metadata)
			throws SiteWhereException {
		IDevice result = SiteWhereServer.getInstance().getDeviceManagement()
				.updateDeviceMetadata(hardwareId, metadata);
		DeviceMarshalHelper helper = new DeviceMarshalHelper();
		helper.setIncludeAsset(true);
		helper.setIncludeAssignment(true);
		return helper.convert(result, SiteWhereServer.getInstance().getAssetModuleManager());
	}

	/**
	 * List all devices.
	 * 
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(method = RequestMethod.GET)
	@ResponseBody
	@ApiOperation(value = "List devices that match certain criteria")
	public SearchResults<Device> listDevices(@RequestParam(defaultValue = "false") boolean includeDeleted,
			@RequestParam(defaultValue = "100") int count) throws SiteWhereException {
		List<Device> devicesConv = new ArrayList<Device>();
		DeviceSearchCriteria criteria = new DeviceSearchCriteria();
		criteria.setIncludeDeleted(includeDeleted);
		List<IDevice> devices = SiteWhereServer.getInstance().getDeviceManagement().listDevices(criteria);
		DeviceMarshalHelper helper = new DeviceMarshalHelper();
		helper.setIncludeAsset(false);
		helper.setIncludeAssignment(false);
		for (IDevice device : devices) {
			devicesConv.add(helper.convert(device, SiteWhereServer.getInstance().getAssetModuleManager()));
		}
		SearchResults<Device> results = new SearchResults<Device>(devicesConv);
		return results;
	}

	/**
	 * List all unassigned devices.
	 * 
	 * @return
	 * @throws SiteWhereException
	 */
	@RequestMapping(value = "/unassigned", method = RequestMethod.GET)
	@ResponseBody
	@ApiOperation(value = "List devices that are not currently assigned")
	public SearchResults<Device> listUnassignedDevices() throws SiteWhereException {
		List<Device> devicesConv = new ArrayList<Device>();
		List<IDevice> devices = SiteWhereServer.getInstance().getDeviceManagement().listUnassignedDevices();
		DeviceMarshalHelper helper = new DeviceMarshalHelper();
		helper.setIncludeAsset(false);
		helper.setIncludeAssignment(false);
		for (IDevice device : devices) {
			devicesConv.add(helper.convert(device, SiteWhereServer.getInstance().getAssetModuleManager()));
		}
		SearchResults<Device> results = new SearchResults<Device>(devicesConv);
		return results;
	}
}