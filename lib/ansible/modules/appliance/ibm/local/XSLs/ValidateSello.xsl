<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions"
	xmlns:regexp="http://exslt.org/regular-expressions"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	exclude-result-prefixes="dp regexp"
	extension-element-prefixes="dp">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" dp:escaping="minimum" />
	<xsl:strip-space elements="*"/>

	<xsl:import href="local:///XSLs/Commons/Utils33.xsl"/>

	<xsl:template match="/">
		<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Entrando a ValidateSello33 --'"></xsl:with-param></xsl:call-template>
		
		<!--Archivo Guardado dentro de WebService local:///XSLs/SAT/cadenaoriginal_3_3.xslt-->
		<xsl:variable name="VersionXSLPath" select="'local:///XSLs/SAT/cadenaoriginal_3_3.xslt'" />
		
		<!-- Se calcula la cadena original -->
		<xsl:variable name="cadenaOriginal" select="dp:transform($VersionXSLPath,/*)"/>
		
		<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'IMPRIMECADENAORIGINALLLLLLLLLL'"></xsl:with-param></xsl:call-template>
		<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$cadenaOriginal"></xsl:with-param></xsl:call-template>      						
		
		
		<!--xsl:variable name="algorithmHash" select="'http://www.w3.org/2000/09/xmldsig#sha1'"/-->
		<xsl:variable name="algorithmHash" select="'http://www.w3.org/2001/04/xmlenc#sha256'"/>
		
		<!--xsl:variable name="algorithmSignature" select="'http://www.w3.org/2000/09/xmldsig#rsa-sha1'"/-->
		<xsl:variable name="algorithmSignature" select="'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256'"/>
		
		
		<!-- Se calcula el hash de la cadena original -->
		<xsl:variable name="hashCadenaOriginal" select="dp:hash($algorithmHash,$cadenaOriginal)" />
		<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'IMPRIMECADENAHASHHHHH'"></xsl:with-param></xsl:call-template>
		<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$hashCadenaOriginal"></xsl:with-param></xsl:call-template>
		
		<!-- Sello del Emisor -->
		<xsl:variable name="sello" select="/*[local-name()='Comprobante']/@Sello" />
		
		<!-- Certificado del Emisor -->
		<xsl:variable name="certB64" select="/*[local-name()='Comprobante']/@Certificado" />
		
		<!-- Se realiza la operacion de verificacion para el Emisor-->
		<xsl:variable name="verifySignEmisor" select="dp:verify($algorithmSignature,$hashCadenaOriginal,$sello,concat('cert:',$certB64))" />
		<!--xsl:variable name="verifySignEmisor" select="'EliminarEsteComentario'" /-->
		
		<!-- <dp:set-variable name="'var://context/TCore/Debug-Sello'" value="normalize-space($cadenaOriginal)" /> -->
		<xsl:variable name="SignValidation">
			<Detail>
				
				<xsl:choose>
					<xsl:when test="string($verifySignEmisor) = ''" > <!-- Se valida el resultado de la verificacion, si empty todo bien  -->
						<COValid><xsl:value-of select="'true'"/></COValid>
						<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'IMPRIMEBUENOOOOOOOOOOOO'"></xsl:with-param></xsl:call-template>
						<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$verifySignEmisor"></xsl:with-param></xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<!--COValid><xsl:value-of select="'true'"/></COValid-->
						<COValid><xsl:value-of select="'false'"/></COValid>
						<COValid-result><xsl:value-of select="$verifySignEmisor"/></COValid-result>
						<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
						
					</xsl:otherwise>
				</xsl:choose>
				
			</Detail>
		</xsl:variable>

		<!-- Debug -->
		<dp:set-variable name="'var://context/TCore/1algorithmSignature'" value="normalize-space($algorithmSignature)" /> 
		<dp:set-variable name="'var://context/TCore/1algorithmHash'" value="normalize-space($algorithmHash)" />
		<dp:set-variable name="'var://context/TCore/1cadenaoriginal'" value="string(normalize-space($cadenaOriginal))" />
		<dp:set-variable name="'var://context/TCore/1algorithmHash'" value="normalize-space($hashCadenaOriginal)" />
		<dp:set-variable name="'var://context/TCore/1sello'" value="normalize-space($sello)" />
		<dp:set-variable name="'var://context/TCore/1certB64'" value="normalize-space($certB64)" />
		

		<!-- almacenamos el resultado de la validacion -->
		<dp:set-variable name="'var://context/TCore/SignValidationResult'" value="$SignValidation"/>
		<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Saliendo ValidateSello33 --'"></xsl:with-param></xsl:call-template>
	</xsl:template>

</xsl:stylesheet>