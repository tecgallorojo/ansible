<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" extension-element-prefixes="dp" >
	<xsl:output omit-xml-declaration="yes" />

	<xsl:template match="/">	
		<!-- Reset variable cache -->
			<xsl:choose>
				<xsl:when test="normalize-space(/Request/text()) = 'clear'">
					<dp:set-variable name="'var://system/TCore/properties33'" value="null" />
					<Response>Clear Propertys</Response>
				</xsl:when>
				<xsl:otherwise>
					<Response>Error wrong request</Response>
				</xsl:otherwise>
			</xsl:choose>

	</xsl:template>

</xsl:stylesheet>