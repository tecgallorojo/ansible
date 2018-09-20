<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions"
   xmlns:regexp="http://exslt.org/regular-expressions"
   xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
   xmlns:fn="http://www.w3.org/2005/xpath-functions"  
   xmlns:date="http://exslt.org/dates-and-times"
   exclude-result-prefixes="dp regexp xsl"
   extension-element-prefixes="dp date">
   <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" dp:escaping="minimum" />
   <xsl:strip-space elements="*"/>
   
   <xsl:import href="local:///XSLs/Commons/Utils33.xsl"/>

   <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" dp:escaping="minimum" />
   <xsl:key name="groups" match="/*[local-name() = 'Comprobante']/*[local-name() = 'Complemento']/*[local-name() = 'INE']/*[local-name() = 'Entidad']" use="@Ambito" />
   <xsl:template match="/">

      <xsl:variable name="CFDI"><dp:serialize select="/" omit-xml-decl="yes"/></xsl:variable>
      <xsl:variable name="CFDIB64" select="dp:encode($CFDI,'base-64')"/>
      
      
      <!--Archivo Guardado dentro de WebService local:///XSLs/SAT/cadenaoriginal_3_3.xslt-->
      <xsl:variable name="VersionXSLPath" select="'local:///XSLs/SAT/cadenaoriginal_3_3.xslt'" />
      
      <!-- Se calcula la cadena original -->
      <xsl:variable name="cadenaOriginal" select="dp:transform($VersionXSLPath,/*)"/>
               
                 
      <!-- Algoritmos de cryptografía PARA LA VERISON 3.3 EN SHA256-->
      <xsl:variable name="algorithmHash">
         <xsl:call-template name="getPropertyValue">
            <xsl:with-param name="name" select="'ALGORITHMHASH'" />
         </xsl:call-template>
      </xsl:variable>
      
      
      <xsl:variable name="algorithmSignature">
         <xsl:call-template name="getPropertyValue">
            <xsl:with-param name="name" select="'ALGORITHMSIGNATURE'" />
         </xsl:call-template>
      </xsl:variable>
      
      <!-- Correccion de la cadena original -->
      <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
      <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
      <!--covierte de base-64 a hexa-->
      <xsl:variable name="hashCadenaOriginal" select="translate(substring(dp:radix-convert(concat('8AAA',dp:hash($algorithmHash,$cadenaOriginal)),64,16),7), $uppercase, $smallcase)" />                 
    
   </xsl:template>
   <!--Template para agrupar por atributo y revisar que no se repitan los valores de entidad ambito-->
   <xsl:template match="/*[local-name() = 'Comprobante']/*[local-name() = 'Complemento']/*[local-name() = 'INE']/*[local-name() = 'Entidad']">
      <!-- <Ambito><xsl:value-of select="@Ambito"/></Ambito>-->
      <EntidadAmbito>
         <xsl:for-each select="key('groups', @Ambito)">
            <!-- <Ambito><xsl:value-of select="@Ambito"/></Ambito>-->
            <Entidad>
               <xsl:value-of select="@ClaveEntidad" />
            </Entidad>
         </xsl:for-each>
      </EntidadAmbito>
   </xsl:template>
</xsl:stylesheet>