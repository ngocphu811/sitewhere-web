<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="swtitle" value="Manage Sites" />
<%@ include file="top.inc"%>

<div class="row">
	<div class="span4">
		<h4>Sites</h4>
		<p>
			Manage the list of sites where devices are deployed.
		</p>
		<a href="site/list" class="btn btn-primary">Manage Sites</a>
	</div>
	<div class="span4">
		<h4>Devices</h4>
		<p>
			Create new devices and associate them with assets.
		</p>
		<a href="device/unassigned" class="btn btn-primary">Manage Devices</a>
	</div>
	<div class="span4">
		<h4>Administration</h4>
		<p>
			Administer the server.
		</p>
		<a href="admin" class="btn btn-primary">Administration</a>
	</div>
</div>

<%@ include file="bottom.inc"%>