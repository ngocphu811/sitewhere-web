<!DOCTYPE html>
<html>
<head>
<title>SiteWhere - <c:out value="${swtitle}"/></title>
<script src="${pageContext.request.contextPath}/scripts/jquery.js"></script>
<script src="${pageContext.request.contextPath}/scripts/kendo.web.min.js"></script>
<script src="${pageContext.request.contextPath}/scripts/sitewhere.js"></script>
<link href="${pageContext.request.contextPath}/css/kendo.common.min.css" rel="stylesheet" />
<link href="${pageContext.request.contextPath}/css/kendo.bootstrap.min.css" rel="stylesheet" />
<link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet" media="screen">
<link href="${pageContext.request.contextPath}/css/sitewhere.css" rel="stylesheet" />
</head>
<body>
	<div class="sw-top-bar"></div>
	<div class="k-content container">
		<div class="sw-header">
			<div class="sw-logo">
				<img src="${pageContext.request.contextPath}/img/sitewhere-small.png" style="width: 200px;"/>
			</div>
			<div class="sw-main-nav">
				<ul class="nav nav-pills">
					<li class="active"><a href="#">Sites</a></li>
					<li><a href="#">Devices</a></li>
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
