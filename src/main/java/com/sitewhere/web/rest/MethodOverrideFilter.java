package com.sitewhere.web.rest;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.filter.OncePerRequestFilter;

/**
 * Allows HTTP method to be override based on a header.
 * 
 * @author Derek Adams
 */
public class MethodOverrideFilter extends OncePerRequestFilter {

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.springframework.web.filter.OncePerRequestFilter#doFilterInternal(
	 * javax.servlet.http.HttpServletRequest,
	 * javax.servlet.http.HttpServletResponse, javax.servlet.FilterChain)
	 */
	protected void doFilterInternal(HttpServletRequest request,
			HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {
		String method = request.getHeader("X-HTTP-Method-Override");
		if (method != null) {
			HttpServletRequest wrapper = new HttpMethodRequestWrapper(request,
					method);
			filterChain.doFilter(wrapper, response);
		} else {
			filterChain.doFilter(request, response);
		}
	}

	/**
	 * Allows http method to be overriden.
	 * 
	 * @author Derek Adams
	 */
	private static class HttpMethodRequestWrapper extends
			HttpServletRequestWrapper {

		private final String method;

		public HttpMethodRequestWrapper(HttpServletRequest request,
				String method) {
			super(request);
			this.method = method;
		}

		/*
		 * (non-Javadoc)
		 * 
		 * @see javax.servlet.http.HttpServletRequestWrapper#getMethod()
		 */
		public String getMethod() {
			return this.method;
		}
	}
}