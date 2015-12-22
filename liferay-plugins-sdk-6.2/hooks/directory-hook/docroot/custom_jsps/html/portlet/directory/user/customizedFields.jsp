<%--
/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/html/portlet/directory/init.jsp" %>

<%
User selUser = (User)request.getAttribute("user.selUser");
String externalWebsite = (String)selUser.getExpandoBridge().getAttribute("web_personal_ext");
String personalWebsite = (String)selUser.getExpandoBridge().getAttribute("web_personal");
String[] ebdPosition = (String[])selUser.getExpandoBridge().getAttribute("ebdPosition");
String[] ebdOrganization = (String[])selUser.getExpandoBridge().getAttribute("ebdOrganization");

%>		 

<c:if test="<%= Validator.isNotNull(externalWebsite) || Validator.isNotNull(personalWebsite)%>">		 
<h2><liferay-ui:message key="site-members-other-data" /></h2>
<div class="other-details">
	<dl class="property-list">
		<c:if test="<%= Validator.isNotNull(personalWebsite) %>">
			<dt>
				<liferay-ui:message key="site-members-personal-website" />
			</dt>
			<dd>
				<a href="<%= personalWebsite %>" target="_blank"><%= personalWebsite %></a>
			</dd>
		</c:if>
		<c:if test="<%= Validator.isNotNull(externalWebsite) %>">
			<dt>
				<liferay-ui:message key="site-members-ext-personal-website" />
			</dt>
			<dd>
				<a href="<%= externalWebsite %>" target="_blank"><%= externalWebsite %></a>
			</dd>
		</c:if>
	</dl>
</div>
</c:if>
<c:if test="<%= Validator.isNotNull(ebdPosition) || Validator.isNotNull(ebdOrganization)%>">		 
<h2><liferay-ui:message key="site-members-organization-data" /></h2>
<div class="custom-details">
	<liferay-ui:custom-attribute className="<%=User.class.getName()%>"
	classPK="<%=selUser != null ? selUser.getUserId() : 0%>"
	editable="<%=false%>" name="ebdOrganization" label="true" />
	<liferay-ui:custom-attribute className="<%=User.class.getName()%>"
	classPK="<%=selUser != null ? selUser.getUserId() : 0%>"
	editable="<%=false%>" name="ebdPosition" label="true" />
</div>
</c:if>