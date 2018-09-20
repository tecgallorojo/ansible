<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:dp="http://www.datapower.com/extensions" 
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:cfdi="http://www.sat.gob.mx/cfd/3"
	extension-element-prefixes="dp" exclude-result-prefixes="dp">

	<xsl:output omit-xml-declaration="yes" method="xml" />
	<xsl:strip-space elements="*" />

	<xsl:import href="local:///XSLs/Commons/Utils33.xsl" />

	<xsl:template match="/">
	  <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Entrando en CreateSello --'"></xsl:with-param></xsl:call-template>
    <!-- Resplado del CFDi original -->
    <xsl:variable name="BAKCFdi">
      <xsl:copy-of select="/" />
    </xsl:variable>

		<!-- Algoritmos de cryptografía -->
		<!--xsl:variable name="algorithmHash">
			<xsl:call-template name="getPropertyValue">
				<xsl:with-param name="name" select="'ALGORITHMHASH'" />
			</xsl:call-template>
		</xsl:variable-->
	  <xsl:variable name="algorithmHash" select="'http://www.w3.org/2001/04/xmlenc#sha256'"/>
	

		<!--xsl:variable name="algorithmSignature">
			<xsl:call-template name="getPropertyValue">
				<xsl:with-param name="name" select="'ALGORITHMSIGNATURE'" />
			</xsl:call-template>
		</xsl:variable-->
	  <xsl:variable name="algorithmSignature" select="'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256'"/>


	  <!-- Ruta a los recursos del SAT local:///XSLs/SAT/-->
		<!--xsl:variable name="PathSAT-XSL">
			<xsl:call-template name="getPropertyValue">
				<xsl:with-param name="name" select="'PATH-SAT-XSL'" />
			</xsl:call-template>
		</xsl:variable-->
	  <xsl:variable name="PathSAT-XSL" select="'local:///XSLs/SAT/'"/>
		
		<xsl:variable name="DVersion" select="string(translate(/*[local-name()='Comprobante']/@Version, '.', '_'))" />
	  <!--local:///XSLs/SAT/cadenaoriginal_3_3.xslt-->
		<xsl:variable name="VersionXSLPath" select="concat($PathSAT-XSL,'cadenaoriginal_',$DVersion,'.xslt')" />
	  <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'VerificadoVersionXSLPATH'"></xsl:with-param></xsl:call-template>
	  <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$VersionXSLPath"></xsl:with-param></xsl:call-template>

    <!-- Creamos la cadena original -->
    <xsl:variable name="cadenaOriginal" select="dp:transform($VersionXSLPath,/*)"/>

    <!-- Crypto object para sellar por ser una PoC utiliza el mismo que el PAC -->
	  <!--xsl:variable name="cryptoClientTMP">
		  	<xsl:call-template name="getPropertyValue">
			  	<xsl:with-param name="name" select="'CREATETIMBRE-CRYPTOSAT3'" />
	  		</xsl:call-template>
	  	</xsl:variable-->
	  <xsl:variable name="cryptoClientTMP" select="'PAC'"/>
	  
	  
		<xsl:variable name="cryptoClient">
			<xsl:value-of select="concat('name:',$cryptoClientTMP)" />
		</xsl:variable>

    <!-- Hash cadena original CFDi -->
    <xsl:variable name="hashCadenaOriginal" select="dp:hash($algorithmHash,$cadenaOriginal)" />
	  <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'VerificadohashCadenaOriginalSello'"></xsl:with-param></xsl:call-template>
	  <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$hashCadenaOriginal"></xsl:with-param></xsl:call-template>
	  
	  
    <!-- Sello CFDi -->
    <xsl:variable name="selloCFDi"  select="dp:sign($algorithmSignature,$hashCadenaOriginal,$cryptoClient)" />

    <!-- Orden de los atributos LE PASAMOS TODOS LOS ATRIBUTOS-->
    <xsl:variable name="attrOrder">
      <xsl:call-template name="getPropertyValue">
        <xsl:with-param name="name" select="'CFDI-ATTR-ORDER'" />
        <xsl:with-param name="type" select="'node'" />
      </xsl:call-template>
    </xsl:variable>

    <!-- CFDi Namespace -->
    <xsl:variable name="CFDiNamespace">
      <xsl:value-of select="namespace-uri(/*[name()='cfdi:Comprobante'])" />
    </xsl:variable>
	  <!--SELECCIONAMOS ESTE URI, EL PRIMER URL XSI http://www.w3.org/2001/XMLSchema-instance -->
    <xsl:variable name="vXsi" select="document('')/*/namespace::*[name()='xsi']"/>
	  <!--SELECCIONAMOS ESTE URI, EL segundo URL http://www.sat.gob.mx/cfd/3 
	    http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd 
	    http://www.sat.gob.mx/implocal http://www.sat.gob.mx/sitio_internet/cfd/implocal/implocal.xsd -->
    <xsl:variable name="vschemaLocation" select="document('')/*/namespace::*[name()='schemaLocation']"/>

    <!-- Se recrea el CFDi con la informacion de sellado y los atributos en el orden requerido -->
    <xsl:variable name="CFDiSellado">
    <xsl:element name="cfdi:Comprobante">

    <xsl:attribute name="xmlns:xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance">
      <!--xsl:value-of select="'http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd'" /-->
	  <!--SE MODIFICA LA VERSION A 3.3-->
	     <xsl:value-of select="'http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd'" />
    </xsl:attribute>

    <xsl:for-each select="$attrOrder/attributes/*">

      <dp:set-variable name="'var://context/TCore/attrIndex'" value="normalize-space(./@nombre)" />

      <xsl:choose>
        
        <xsl:when test="dp:variable('var://context/TCore/attrIndex') = 'Sello'">
          <xsl:attribute name="Sello">
            <xsl:value-of select="$selloCFDi" />
          </xsl:attribute>
        </xsl:when>
        
        <xsl:when test="dp:variable('var://context/TCore/attrIndex') = 'Certificado'">
            <xsl:attribute name="Certificado">
              <xsl:value-of select="dp:base64-cert($cryptoClient)" />
            </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="string($BAKCFdi/*[local-name()='Comprobante']/@*[name()=dp:variable('var://context/TCore/attrIndex')]) != ''">
            <xsl:attribute name="{dp:variable('var://context/TCore/attrIndex')}">
              <xsl:value-of select="string($BAKCFdi/*[local-name()='Comprobante']/@*[name()=dp:variable('var://context/TCore/attrIndex')])" />
            </xsl:attribute>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>

      <!-- Inserto el contenido restante del CFDi -->
      <xsl:call-template name="copy-data" />
      </xsl:element>
    </xsl:variable>

    <xsl:variable name="SelloGenerationResult">
      <Detail>
        <cadenaoriginal><xsl:value-of select="$cadenaOriginal" /></cadenaoriginal>
        <hashcadenaoriginal><xsl:value-of select="$hashCadenaOriginal" /></hashcadenaoriginal>
        <cfdisellado><xsl:copy-of select="$CFDiSellado" /></cfdisellado>
      </Detail>
    </xsl:variable>
  
    <!-- almaceno los resultados -->
    <dp:set-variable name="'var://context/TCore/SelloGenerationResult'" value="$SelloGenerationResult" />
	  <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Saliendo de CreateSello --'"></xsl:with-param></xsl:call-template>
	</xsl:template>

	<xsl:template name="copy-data">
		<xsl:copy-of select="/*[name()='cfdi:Comprobante']/*" />
	</xsl:template>

</xsl:stylesheet>