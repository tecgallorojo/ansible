<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:cfdi="http://www.sat.gob.mx/cfd/3" xmlns:dp="http://www.datapower.com/extensions" 
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	version="1.0" exclude-result-prefixes="xsd dp xsl soapenv">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no" dp:escaping="minimum" />
	<xsl:import href="local:///XSLs/Commons/Utils33.xsl"/>
	<xsl:template match="/">
		<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Entrando a InsertSello --'"></xsl:with-param></xsl:call-template>
    <xsl:copy-of select="dp:variable('var://context/TCore/SelloGenerationResult')/*[local-name()='Detail']/*[local-name()='cfdisellado']/*" />
		<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Saliendo de InsertSeelo --'"></xsl:with-param></xsl:call-template>
	</xsl:template>

</xsl:stylesheet>