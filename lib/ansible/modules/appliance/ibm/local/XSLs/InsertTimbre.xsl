<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:cfdi="http://www.sat.gob.mx/cfd/3" xmlns:dp="http://www.datapower.com/extensions" xmlns:regexp="http://exslt.org/regular-expressions"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fn="http://www.w3.org/2005/xpath-functions"   xmlns:xsd="http://www.w3.org/2001/XMLSchema" version="1.0" 
	exclude-result-prefixes="xsd dp xsl soapenv" extension-element-prefixes="dp">
		
		<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" dp:escaping="minimum" />
		<xsl:strip-space elements="*"/>

	<xsl:import href="local:///XSLs/Commons/Utils33.xsl"/>
	<xsl:template match="/">
		<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Entrando a InsertTimbre --'"></xsl:with-param></xsl:call-template>
		
                <xsl:variable name="vXsi" select="document('')/*/namespace::*[name()='xsi']"/>

			<xsl:choose>
				<xsl:when test="/*[name()='cfdi:Comprobante']/*[local-name()='Complemento']/*">
					<xsl:apply-templates />
	
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="cfdi:Comprobante">
						<xsl:copy-of select="$vXsi"/>
	
						<xsl:for-each select="/*[local-name()='Comprobante']/@*">
							<xsl:variable name="attr-name" select="name()" />
							<xsl:attribute name="{$attr-name}">
								<xsl:value-of select="." />
							</xsl:attribute>
						</xsl:for-each>
						
						<xsl:apply-templates select="/*[local-name()='Comprobante']/*[local-name()='CfdiRelacionados']" />
						<xsl:apply-templates select="/*[local-name()='Comprobante']/*[local-name()='Emisor']" />
						<xsl:apply-templates select="/*[local-name()='Comprobante']/*[local-name()='Receptor']" />
						<xsl:apply-templates select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']" />
						<xsl:apply-templates select="/*[local-name()='Comprobante']/*[local-name()='Impuestos']" />
	
						
						<xsl:element name="cfdi:Complemento">
							<xsl:copy-of select="dp:variable('var://context/TCore/TimbreGenerationResult')/*[local-name()='Detail']/*[local-name()='Timbre']/*" />							
						</xsl:element>
					</xsl:element>
					
				</xsl:otherwise>
			</xsl:choose>
		
		
		<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Saliendo de InsertTimbre --'"></xsl:with-param></xsl:call-template>
	</xsl:template>

	
	<xsl:template match="*">
		<xsl:element name="{name()}" namespace="{namespace-uri()}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	
	<xsl:template match="/*[local-name()='Comprobante']/*[local-name()='Complemento']">
		
			<cfdi:Complemento>
				<xsl:copy-of select="dp:variable('var://context/TCore/TimbreGenerationResult')/*[local-name()='Detail']/*[local-name()='Timbre']/*" />
				<xsl:call-template name="copy-children" />				
			</cfdi:Complemento>
			
	</xsl:template>

	<xsl:template name="copy-children">
		<xsl:copy-of select="./*" />		
	</xsl:template>
       
      
</xsl:stylesheet>