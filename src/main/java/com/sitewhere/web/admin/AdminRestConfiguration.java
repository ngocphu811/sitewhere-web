package com.sitewhere.web.admin;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

/**
 * Configures the Spring context for service admin REST services.
 * 
 * @author dadams
 */
@EnableWebMvc
@Configuration
@ComponentScan(basePackages = "com.sitewhere.web.rest")
public class AdminRestConfiguration {
}