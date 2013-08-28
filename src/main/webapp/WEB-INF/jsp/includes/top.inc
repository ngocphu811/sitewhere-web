<!DOCTYPE html>
<html class="sw-body">
<head>
<title>SiteWhere - <c:out value="${sitewhere_title}"/></title>
<script src="${pageContext.request.contextPath}/scripts/jquery.js"></script>
<script src="${pageContext.request.contextPath}/scripts/jquery.validity.js"></script>
<script src="${pageContext.request.contextPath}/scripts/kendo.web.js"></script>
<script src="${pageContext.request.contextPath}/scripts/sitewhere.js"></script>
<link href="${pageContext.request.contextPath}/css/kendo.common.min.css" rel="stylesheet" />
<link href="${pageContext.request.contextPath}/css/kendo.bootstrap.min.css" rel="stylesheet" />
<link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet" media="screen">
<link href="${pageContext.request.contextPath}/css/font-awesome.min.css" rel="stylesheet" media="screen">
<link href="${pageContext.request.contextPath}/css/jquery.validity.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/sitewhere.css" rel="stylesheet" />
<c:if test="${use_map_includes == true}">
<script src="${pageContext.request.contextPath}/scripts/leaflet-src.js"></script>
<script src="${pageContext.request.contextPath}/scripts/leaflet.draw.js"></script>
<link href="${pageContext.request.contextPath}/css/leaflet.css" rel="stylesheet" />
<link href="${pageContext.request.contextPath}/css/leaflet.draw.css" rel="stylesheet" />
<link  href="${pageContext.request.contextPath}/css/highlight.default.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/scripts/highlight.pack.js"></script>
</c:if>
<c:if test="${use_color_picker_includes == true}">
<script src="${pageContext.request.contextPath}/scripts/spectrum.js"></script>
<link href="${pageContext.request.contextPath}/css/spectrum.css" rel="stylesheet" />
</c:if>
<c:if test="${use_mqtt == true}">
<script src="${pageContext.request.contextPath}/scripts/mqttws31.js"></script>
</c:if>
</head>
<body class="sw-body">
	<div class="sw-container">
		<div class="sw-top-bar"></div>
		<div class="k-content container sw-content">
			<div class="sw-header">
				<div class="sw-logo">
					<img src="${pageContext.request.contextPath}/img/sitewhere-small.png"/>
				</div>
				<div class="sw-main-nav">
					<ul class="nav nav-pills">
<c:choose>
	<c:when test="${sitewhere_section == 'sites'}">
						<li class="active"><a href="${pageContext.request.contextPath}/admin/sites/list.html">Sites</a></li>
	</c:when>
	<c:otherwise>
						<li><a href="${pageContext.request.contextPath}/admin/sites/list.html">Sites</a></li>
	</c:otherwise>
</c:choose>
<c:choose>
	<c:when test="${sitewhere_section == 'devices'}">
						<li class="active"><a href="${pageContext.request.contextPath}/admin/devices/list.html">Devices</a></li>
	</c:when>
	<c:otherwise>
						<li><a href="${pageContext.request.contextPath}/admin/devices/list.html">Devices</a></li>
	</c:otherwise>
</c:choose>
						<li><a href="#">Administration</a></li>
					</ul>
				</div>
				<div class="sw-user-info">
	 				<a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
						Admin User
						<span class="caret"></span>
					</a>			
				</div>
			</div>
			
			<!-- SiteWhere alert dialog -->
			<div id="alert-dialog" class="modal hide">
				<div class="modal-header k-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h3 id="alert-dialog-title">Alert Title</h3>
				</div>
				<div id="alert-dialog-body" class="modal-body">
				</div>
				<div class="modal-footer">
					<a href="javascript:void(0)" data-dismiss="modal" class="btn btn-primary">Close</a>
				</div>
			</div>
