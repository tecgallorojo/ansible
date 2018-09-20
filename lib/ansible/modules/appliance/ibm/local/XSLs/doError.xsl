<?xml version="1.0" encoding="UTF-8"?> 

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" extension-element-prefixes="dp">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" dp:escaping="minimum" />
  <xsl:import href="local:///XSLs/Commons/Utils33.xsl"/>
	<xsl:template match="/">
	  <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Entrando a doError --'"></xsl:with-param></xsl:call-template>
  <!--  <dp:set-variable name="'var://service/error-protocol-response'" value="'200'" />
    <dp:set-variable name="'var://service/error-protocol-reason-phrase'" value="'OK'" />
    <dp:remove-http-response-header name="'Connection'"/> -->

    <xsl:copy-of select="dp:variable('var://context/TCore/ErrorResult')"/>
	  <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Saliendo de doError --'"></xsl:with-param></xsl:call-template>
	</xsl:template>

</xsl:stylesheet>