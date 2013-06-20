package com.sitewhere.web;

/**
 * Interface for constants used in web operations.
 * 
 * @author dadams
 */
public interface ISiteWhereWebConstants {

	/** Header that holds sitewhere error string on error response */
	public static final String HEADER_SITEWHERE_ERROR = "X-SiteWhere-Error";

	/** Header that holds sitewhere error code on error response */
	public static final String HEADER_SITEWHERE_ERROR_CODE = "X-SiteWhere-Error-Code";
}