<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:or="http://www.orcid.org/ns/orcid">
	
	<xsl:output omit-xml-declaration="yes" indent="yes"/>
	<xsl:strip-space elements="*"/>

	<xsl:template match="/" name="root">
		
		<html>
			<head><title>Listado de publicaciones</title></head>
			<body>
				<div style="background-color: Moccasin ; font-family: Arial; font-size: 12pt;">
					<xsl:apply-templates select="/or:orcid-message/or:orcid-profile/or:orcid-activities/or:orcid-works/or:orcid-work"></xsl:apply-templates>
				</div>			
			</body>
		</html>
	</xsl:template>
	

	<xsl:template match="/or:orcid-message/or:orcid-profile/or:orcid-activities/or:orcid-works/or:orcid-work">
		<xsl:apply-templates select="or:year"></xsl:apply-templates>
		<div style="background-color: FireBrick; color: white; padding: 4px;">
			- Titulo: <xsl:value-of select="or:work-title/or:title" />
			. <xsl:value-of select="or:work-title/or:subtitle" />
		</div>
		
		<div style="font-size: 10pt; margin-bottom: 1em; margin-left: 20px;">
			<xsl:for-each select="or:work-external-identifiers/or:work-external-identifier">
				id Type: <xsl:value-of select="or:work-external-identifier-type" />:
				id externo: <xsl:value-of select="or:work-external-identifier-id" />
				<br />
			</xsl:for-each>
			<br />
			<xsl:for-each select="or:work-contributors/or:contributor">
				<xsl:value-of select="or:credit-name" />:				
				<br />
			</xsl:for-each>			
			<span style="font-style: italic;">
				Source: <xsl:value-of select="or:work-source" /> 
			</span>
			<br />
			<span style="font-style: italic;">
				Citation: <xsl:value-of select="or:work-citation" /> 
			</span>
			<br />			
		</div>
		
	</xsl:template>
	
	<xsl:template match="or:year">
		<span style="font-weight: bold;">
			Fecha: <xsl:value-of select="." />
		</span>	
	</xsl:template>
	
</xsl:stylesheet>



