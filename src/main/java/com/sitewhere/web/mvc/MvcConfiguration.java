package com.sitewhere.web.mvc;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.view.JstlView;
import org.springframework.web.servlet.view.UrlBasedViewResolver;

/**
 * Configuration for Spring MVC web application.
 * 
 * @author dadams
 */
@Configuration
@ComponentScan(basePackages = "com.sitewhere.web.mvc")
public class MvcConfiguration {

	/**
	 * Set up the JSP view resolver.
	 * 
	 * @return
	 */
	@Bean
	public UrlBasedViewResolver viewResolver() {
		UrlBasedViewResolver resolver = new UrlBasedViewResolver();
		resolver.setViewClass(JstlView.class);
		resolver.setPrefix("/WEB-INF/jsp/");
		resolver.setSuffix(".jsp");
		return resolver;
	}
}