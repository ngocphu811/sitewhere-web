package com.sitewhere.web.rest.model;

import java.util.Date;
import java.util.List;

/**
 * Request for history on one or more assignments for a period of time.
 * 
 * @author Derek Adams
 */
public class AssignmentHistoryRequest {

	/** Assignment tokens to load */
	private List<String> assignmentTokens;
	
	/** Start date for search */
	private Date startDate;
	
	/** End date for search */
	private Date endDate;

	public List<String> getAssignmentTokens() {
		return assignmentTokens;
	}

	public void setAssignmentTokens(List<String> assignmentTokens) {
		this.assignmentTokens = assignmentTokens;
	}

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
}