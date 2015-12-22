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

<%@ include file="/html/portlet/xsl_content/init.jsp" %>
 
<html>
<head>
<script src='/html/portlet/xsl_content/Chart.min.js'> </script>
</head>
<body>
		
<%



// Funcionalidad adicional para definir un campo XML personalizado en el perfil de cada usuario (p.ej. visualizacion de las publicaciones)


try {
	String variablePropertyKey = StringPool.BLANK;
	String variablePropertyValue = StringPool.BLANK;

	//xmlUrl = StringUtil.replace(xmlUrl,"@portal_url@", themeDisplay.getPortalURL());
	
	try{
	
		Group currentGroup = themeDisplay.getLayout().getGroup();
		long groupClassNameId =currentGroup.getClassNameId();
		long companyId=currentGroup.getCompanyId();
		ExpandoTable groupTable = ExpandoTableLocalServiceUtil.getDefaultTable(companyId,groupClassNameId);
		ExpandoColumn groupColumn = ExpandoColumnLocalServiceUtil.getColumn(groupTable.getTableId(), xmlUrl);
		ExpandoValue xmlValue = ExpandoValueLocalServiceUtil.getValue( groupTable.getTableId(), groupColumn.getColumnId(), currentGroup.getClassPK());
		if(xmlValue != null ){
			if (groupColumn.getName().equals("IdOrcid"))
				{
					xmlUrl= "http://pub.orcid.org/v1.1/"+xmlValue.getData()+"/orcid-works";
				}
			}
		}
	catch (Exception e) {
		xmlUrl = StringUtil.replace(xmlUrl,"@portal_url@", themeDisplay.getPortalURL());
	}


	xslUrl = StringUtil.replace(xslUrl,"@portal_url@", themeDisplay.getPortalURL());

	int bracketBegin = xmlUrl.indexOf("[");
	int bracketEnd = -1;

	if (bracketBegin > -1) {
		bracketEnd = xmlUrl.indexOf("]", bracketBegin);

		if ((bracketEnd > -1) && ((bracketEnd - bracketBegin) > 0)) {
			String[] compilerTagNames = ParamUtil.getParameterValues(request, "tags");

			if (compilerTagNames.length > 0) {
				String category = null;
				String propertyName = null;

				variablePropertyKey = xmlUrl.substring(bracketBegin + 1, bracketEnd);

				category = variablePropertyKey;

				int pos = variablePropertyKey.indexOf(StringPool.PERIOD);

				if (pos != -1) {
					category = variablePropertyKey.substring(0, pos);
					propertyName = variablePropertyKey.substring(pos + 1);
				}

				for (String tagName : compilerTagNames) {
					try {
						AssetTag assetTag = AssetTagLocalServiceUtil.getTag(scopeGroupId, tagName);

						AssetTagProperty assetTagProperty = AssetTagPropertyLocalServiceUtil.getTagProperty(assetTag.getTagId(), "category");

						variablePropertyValue = assetTagProperty.getValue();

						if (category.equals(variablePropertyValue)) {
							if (pos == -1) {
								variablePropertyValue = assetTag.getName();
							}
							else {
								assetTagProperty = AssetTagPropertyLocalServiceUtil.getTagProperty(assetTag.getTagId(), propertyName);

								variablePropertyValue = assetTagProperty.getValue();
							}

							xmlUrl = StringUtil.replace(xmlUrl, "[" + variablePropertyKey + "]", StringUtil.toUpperCase(variablePropertyValue));

							break;
						}
					}
					catch (NoSuchTagException nste) {
						_log.warn(nste);
					}
					catch (NoSuchTagPropertyException nstpe) {
						_log.warn(nstpe);
					}
				}
			}
		}
	}

	String content = XSLContentUtil.transform(new URL(xmlUrl), new URL(xslUrl));
%>

	<%= content %>

<%
}
catch (Exception e) {
	_log.error(e.getMessage());
%>

	<div class="alert alert-error">
		<liferay-ui:message key="an-error-occurred-while-processing-your-xml-and-xsl" />
	</div>

<%
}
%>

<aui:script>
			/*setInterval(function(){
				window.localStorage.setItem("idPortlet",'#p_p_id<%=renderResponse.getNamespace()%>');
				Liferay.Portlet.refresh('#p_p_id<%=renderResponse.getNamespace()%>');
		
			},60000);*/
			setInterval(function(){	
				console.log("Llega a setInterval en JSP");		
				window.localStorage.setItem("idPortlet",'#p_p_id<%=renderResponse.getNamespace()%>');
				var min = new Date(); 
				min = min.getMinutes();	
				console.log("Nuevo " + min);
				/*if(window.localStorage.getItem("minutes"))
					console.log("Almacenado: " + window.localStorage.getItem("minutes"));*/
						
				if(window.localStorage.getItem("minutes")==null || window.localStorage.getItem("minutes") != min){
					console.log("ENTRA EN IF");
					Liferay.Portlet.refresh('#p_p_id<%=renderResponse.getNamespace()%>');
					window.localStorage.removeItem("minutes");
					window.localStorage.setItem("minutes",min);
				}	
				console.log("FIN setInterval en JSP");		
			},60000);
			
		</aui:script>

		
<%!
private static Log _log = LogFactoryUtil.getLog("portal-web.docroot.html.portlet.xsl_content.view_jsp");
%>

</body>
</html>
