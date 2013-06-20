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

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.web.bind.annotation.ExceptionHandler;

import com.sitewhere.spi.SiteWhereSystemException;
import com.sitewhere.web.ISiteWhereWebConstants;

/**
 * Base class for common controller functionality.
 * 
 * @author Derek Adams
 */
public class SiteWhereController {

	/** Static logger instance */
	private static Logger LOGGER = Logger.getLogger(SiteWhereController.class);

	/**
	 * Handles a system exception by setting the HTML response code and response headers.
	 * 
	 * @param e
	 * @param response
	 */
	@ExceptionHandler
	protected void handleSystemException(SiteWhereSystemException e, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			String flexMode = request.getHeader("X-SiteWhere-Error-Mode");
			if (flexMode != null) {
				ObjectMapper mapper = new ObjectMapper();
				mapper.writeValue(response.getOutputStream(), e);
				response.flushBuffer();
			} else {
				String combined = e.getCode() + ":" + e.getMessage();
				response.setHeader(ISiteWhereWebConstants.HEADER_SITEWHERE_ERROR, e.getMessage());
				response.setHeader(ISiteWhereWebConstants.HEADER_SITEWHERE_ERROR_CODE,
						String.valueOf(e.getCode()));
				if (e.hasHttpResponseCode()) {
					response.sendError(e.getHttpResponseCode(), combined);
				} else {
					response.sendError(HttpServletResponse.SC_BAD_REQUEST, combined);
				}
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		}
	}

	/**
	 * Handles uncaught runtime exceptions such as null pointers.
	 * 
	 * @param e
	 * @param response
	 */
	@ExceptionHandler
	protected void handleRuntimeException(RuntimeException e, HttpServletResponse response) {
		LOGGER.error("Unhandled runtime exception.", e);
		try {
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		} catch (IOException e1) {
			e1.printStackTrace();
		}
	}
}