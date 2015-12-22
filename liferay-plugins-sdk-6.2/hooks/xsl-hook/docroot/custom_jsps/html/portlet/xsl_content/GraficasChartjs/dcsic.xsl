<?xml version="1.0" encoding="iso-8859-1"?>

<html xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
	<div style="background-color: #EEEEEE; font-family: Arial; font-size: 12pt;">
		<xsl:for-each select="digital-csic/item">
			<div style="background-color: teal; color: white; padding: 4px;">
				<span style="font-weight: bold;">
					<xsl:value-of select="fecha" />
				</span>

				- <xsl:value-of select="titulo" />
			</div>

			<div style="font-size: 10pt; margin-bottom: 1em; margin-left: 20px;">
				<xsl:value-of select="abstract" />

				<br />

				<span style="font-style: italic;">
					Citation: <xsl:value-of select="citacion" /> 
				</span>
				<br />

				<span style="font-style: italic;">
				
					<xsl:element name="a">
    						<xsl:attribute name="href">
        						<xsl:value-of select="enlace"/>
    						</xsl:attribute>
    						Enlace en Digital CSIC: <xsl:value-of select="enlace"/>
					</xsl:element>
					 
				</span>				
			</div>
		</xsl:for-each>
	</div>
</html>
