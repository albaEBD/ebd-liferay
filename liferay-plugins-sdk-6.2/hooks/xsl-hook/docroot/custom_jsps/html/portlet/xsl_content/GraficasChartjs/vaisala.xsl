<?xml version="1.0" encoding="iso-8859-1"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="utf-8" indent="yes"/>	

	<xsl:strip-space elements="*"/>
	<xsl:template match="root">
		<html>
			<body>
				<xsl:apply-templates select="environment"></xsl:apply-templates>
			<div id="datos" style="position:realtive; max-width: 33%;" >
				<div id="campos" style="float:left;">
					<xsl:apply-templates select="fields"></xsl:apply-templates>
				</div>
				<div id="valores" style="float: right;">
					<xsl:apply-templates select="data"></xsl:apply-templates>
				</div>
			</div>
		</body>
		</html>	
	</xsl:template>	
	
	<xsl:template match="environment">
	
	<div>
	<span style="font-weight: bold;">
		Estacion: <xsl:value-of select="station-name"/><br/>
	</span>
	<span style="font-weight: bold;">
		Tabla: <xsl:value-of select="table-name"/><br/>
	</span>
	<span style="font-weight: bold;">
		Modelo: <xsl:value-of select="model"/><br/>
	</span>
	<span style="font-weight: bold;">
		No serie: <xsl:value-of select="serial-no"/><br/>
	</span>
	<span style="font-weight: bold;">
		Version OS: <xsl:value-of select="os-version"/><br/>
	</span>
	<span style="font-weight: bold;">
		Dld: <xsl:value-of select="dld-name"/><br/>
	</span>
</div>

<br/><br/>

	</xsl:template>
	<xsl:template match="fields">
			<div style="color: black; padding: 4px; float: left;">
			<xsl:for-each select="field">
				<xsl:value-of select="@name"/>  (<xsl:value-of select="@units"/>):<br/>
			</xsl:for-each>
			</div>			
	</xsl:template>
	<xsl:template match="data">
		<xsl:for-each select="r[last()]">
			<div style="color: black; padding: 4px; float: left;">
				<xsl:for-each select="node()">
					<xsl:value-of select="node()" /> <br/>
				</xsl:for-each>			
			</div>
			<br/><br/>
			<div style="background-color: #eae8db; color: black; padding: 4px; float:left;">
			Fecha y hora: <xsl:value-of select="@time" /> <br/> 
			No Registro: <xsl:value-of select="@no" /> <br/>
			</div>		
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>