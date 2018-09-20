<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:date="http://exslt.org/dates-and-times" xmlns:dp="http://www.datapower.com/extensions" 
   xmlns:func="http://exslt.org/functions" xmlns:regexp="http://exslt.org/regular-expressions"
   xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fn="http://www.w3.org/2005/xpath-functions"  
   extension-element-prefixes="dp func date" exclude-result-prefixes="regexp dp func date xsl" version="1.0">
      
      <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" dp:escaping="minimum" />
      <xsl:strip-space elements="*"/>

  <!-- <xsl:output omit-xml-declaration="yes" method="xml" />-->
   <xsl:import href="local:///XSLs/Commons/Utils33.xsl" />

   <xsl:template match="/">
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Entrando a CreateTimbre --'"></xsl:with-param></xsl:call-template>
      <!-- Constantes llamado hacia: http://www.sat.gob.mx/TimbreFiscalDigital-->
      
      <xsl:variable name="xmlns" select="'http://www.sat.gob.mx/TimbreFiscalDigital'"/>
      
      <!--xsl:variable name="xmlns">
         <xsl:call-template name="getPropertyValue">
            <xsl:with-param name="name" select="'CREATETIMBRE-XMLNS'" />
         </xsl:call-template>
      </xsl:variable-->
      
      
      <!--Llamada a http://www.sat.gob.mx/TimbreFiscalDigital http://www.sat.gob.mx/TimbreFiscalDigital/TimbreFiscalDigital.xsd-->
      <!--http://www.sat.gob.mx/TimbreFiscalDigital http://www.sat.gob.mx/sitio_internet/cfd/timbrefiscaldigital/TimbreFiscalDigitalv11.xsd-->
      <!--xsl:variable name="schemaLocation">
         <xsl:call-template name="getPropertyValue">
            <xsl:with-param name="name" select="'CREATETIMBRE-SCHEMALOCATION'" />
         </xsl:call-template>
      </xsl:variable-->
      <xsl:variable name="schemaLocation" select="'http://www.sat.gob.mx/TimbreFiscalDigital http://www.sat.gob.mx/sitio_internet/cfd/timbrefiscaldigital/TimbreFiscalDigitalv11.xsd'"/>
      
      <!--Trae: 1.1-->
      <!--xsl:variable name="version">
         <xsl:call-template name="getPropertyValue">
            <xsl:with-param name="name" select="'CREATETIMBRE-VERSION'" />
         </xsl:call-template>
      </xsl:variable-->
      <xsl:variable name="Version" select="'1.1'"/>
      
      <!--Hace el llamado http://www.w3.org/2001/XMLSchema-instance-->
      <!--xsl:variable name="xmlns-xsi">
         <xsl:call-template name="getPropertyValue">
            <xsl:with-param name="name" select="'DOPROCESS-XMLNS-XSI'" />
         </xsl:call-template>
      </xsl:variable-->
      
      <xsl:variable name="xmlns-xsi" select="'http://www.w3.org/2001/XMLSchema-instance'"/>
      
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

      <!--Cambia a Sello para la V3.3 en Mayúscula-->
      <xsl:variable name="SelloCFD">
         <xsl:value-of select="/*[local-name()='Comprobante']/@Sello" />
      </xsl:variable>
      <!--xsl:variable name="selloCFD" select="dp:variable('var://system/TCore/sello')"/-->
      
      <!--StartVerificaRfcProvCertif-->         
         <xsl:variable name="RfcProvCertif" select="'DAL050601L35'" />        
      <!--EndVerificaRfcProvCertif-->
      
      <!--StartLeyendaTFD-->         
      <xsl:variable name="Leyenda" select="'Timbre de Prueba'" />        
      <!--EndLeyendaTFD-->
      
      <!--Trae: PAC-->
      <xsl:variable name="cryptoPAC">
         <xsl:call-template name="getPropertyValue">
            <xsl:with-param name="name" select="'CREATETIMBRE-CRYPTOSAT'" />
         </xsl:call-template>
      </xsl:variable>
            

      <xsl:variable name="cryptoPACName">
         <xsl:value-of select="concat('name:',$cryptoPAC)" />
      </xsl:variable>
      
         
      
      <xsl:variable name="NoCertificatePAC">
         <xsl:value-of select="regexp:replace(dp:radix-convert(dp:get-cert-serial($cryptoPACName),10,16),'3([0-9])','g','$1')" />
         <!--xsl:value-of select="dp:get-cert-details($cryptoPACName)"/-->
      </xsl:variable>
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- imprimiendo noCertificado --'"></xsl:with-param></xsl:call-template>
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$NoCertificatePAC"></xsl:with-param></xsl:call-template>
      
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- imprimiendo cryptoPACName --'"></xsl:with-param></xsl:call-template>
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="dp:get-cert-serial($cryptoPACName)"></xsl:with-param></xsl:call-template>

      
      
   
      <!-- Identificado unico -->
      <xsl:variable name="UUID" select="normalize-space(translate(dp:generate-uuid(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))" />
      
      <!--<xsl:variable name="UUID" select="dp:variable('var://system/TCore/UUIDSAT')"/>-->
      
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'ImprimiendoUUIDSAT'"></xsl:with-param></xsl:call-template>
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="concat('SAT-UUID',$UUID)"></xsl:with-param></xsl:call-template>

      
      <!-- Date timbre -->
      <xsl:variable name="Now">
         <xsl:call-template name="createDateTime" />
      </xsl:variable>           
      
    <!--  <!-\-Error 518-\->
      <xsl:if test="$Version != '1.1'">
         <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'518,')"/>
         
         <xsl:call-template name="SetError">
            <xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"/>
         </xsl:call-template>
      </xsl:if>-->
      
      <!-- Cadena original timbre -->
      <xsl:variable name="cadenaOriginalTimbre">||<xsl:value-of select="normalize-space($Version)" />|<xsl:value-of select="$UUID" />|<xsl:value-of select="$Now" />|<xsl:value-of select="$RfcProvCertif" />|<xsl:value-of select="normalize-space($SelloCFD)" />|<xsl:value-of select="$NoCertificatePAC" />||</xsl:variable>
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- imprimiendo CadenaOriginalTimbre --'"></xsl:with-param></xsl:call-template>
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$cadenaOriginalTimbre"></xsl:with-param></xsl:call-template>            
      
     
      
      <!-- Hash cadena original timbre -->
      <xsl:variable name="hashTimbre" select="dp:hash($algorithmHash,$cadenaOriginalTimbre)" />
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- imprimiendo HashCadenaOriginalTimbre --'"></xsl:with-param></xsl:call-template>
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$hashTimbre"></xsl:with-param></xsl:call-template>
      
      <!-- Sello timbre -->
      <xsl:variable name="SelloPAC">
         <xsl:value-of select="dp:sign($algorithmSignature,$hashTimbre,$cryptoPACName)" />
      </xsl:variable>
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- imprimiendo SelloTimbre --'"></xsl:with-param></xsl:call-template>
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$SelloPAC"></xsl:with-param></xsl:call-template>

      <!-- StartNewCode -->      
      <xsl:variable name="timbreGlobal">
         <xsl:value-of select="'FechaTimbrado='" />
         <xsl:value-of select="''''" />
         <xsl:value-of select="$Now" />
         <xsl:value-of select="''''" />
         <xsl:value-of select="' '" />
         <xsl:value-of select="'UUID='" />
         <xsl:value-of select="''''" />
         <xsl:value-of select="$UUID" />
         <xsl:value-of select="''''" />
         <xsl:value-of select="' '" />        
         <xsl:value-of select="'NoCertificadoSAT='" />
         <xsl:value-of select="''''" />
         <xsl:value-of select="$NoCertificatePAC" />
         <xsl:value-of select="''''" />
         <xsl:value-of select="' '" />        
         <xsl:value-of select="'SelloCFD='" />
         <xsl:value-of select="''''" />
         <xsl:value-of select="normalize-space($SelloCFD)" />
         <xsl:value-of select="''''" />
         <xsl:value-of select="' '" />         
         <xsl:value-of select="'SelloSAT='" />
         <xsl:value-of select="''''" />
         <xsl:value-of select="normalize-space($SelloPAC)" />
         <xsl:value-of select="''''" />
         <xsl:value-of select="' '" />         
         <xsl:value-of select="'Version='" />
         <xsl:value-of select="''''" />
         <xsl:value-of select="normalize-space($Version)" />
         <xsl:value-of select="''''" />
         <xsl:value-of select="' '" />         
         <xsl:value-of select="'RfcProvCertif='" />
         <xsl:value-of select="''''" />
         <xsl:value-of select="$RfcProvCertif" />
         <xsl:value-of select="''''" />
         <!--<xsl:value-of select="' '" />        
         <xsl:value-of select="'Leyenda='" />
         <xsl:value-of select="''''" />
         <xsl:value-of select="$Leyenda" /> 
         <xsl:value-of select="''''" />-->
      </xsl:variable>
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'--CadenaTimbre33--'"></xsl:with-param></xsl:call-template>
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$timbreGlobal"></xsl:with-param></xsl:call-template>            
      <!-- EndNewCode -->
      
      <!-- Nodo complemento timbre -->
      <xsl:variable name="complementoTimbre">
         <xsl:element name="tfd:TimbreFiscalDigital" namespace="{$xmlns}">
             <xsl:attribute name="FechaTimbrado">
               <xsl:value-of select="$Now" />
            </xsl:attribute>
            <xsl:attribute name="UUID">
               <xsl:value-of select="$UUID" />
            </xsl:attribute>
            <xsl:attribute name="NoCertificadoSAT">
               <xsl:value-of select="normalize-space($NoCertificatePAC)" />
            </xsl:attribute>
            <xsl:attribute name="SelloCFD">
               <xsl:value-of select="$SelloCFD" />
            </xsl:attribute>
            <xsl:attribute name="SelloSAT">
               <xsl:value-of select="normalize-space($SelloPAC)" />
            </xsl:attribute>            
            <xsl:attribute name="Version">
               <xsl:value-of select="normalize-space($Version)" />
            </xsl:attribute>
            <xsl:attribute name="RfcProvCertif">
               <xsl:value-of select="normalize-space($RfcProvCertif)" />
            </xsl:attribute>
            <!--<xsl:attribute name="Leyenda">
               <xsl:value-of select="normalize-space($Leyenda)" />
            </xsl:attribute> -->           
            <xsl:attribute name="xmlns:xsi:schemaLocation" namespace="{$xmlns-xsi}">
               <xsl:value-of select="$schemaLocation" />
            </xsl:attribute>
         </xsl:element>
      </xsl:variable>

      <xsl:variable name="TimbreGeneration">
         <Detail>
             <CadenaOriginal><xsl:value-of select="$cadenaOriginalTimbre" /></CadenaOriginal>
             <Hash><xsl:value-of select="$hashTimbre" /></Hash>
             <Timbre><xsl:copy-of select="$complementoTimbre" /></Timbre>
         </Detail>
    </xsl:variable>

      <dp:set-variable name="'var://context/TCore/TimbreGenerationResult'" value="$TimbreGeneration" />
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Saliendo de CreateTimbre --'"></xsl:with-param></xsl:call-template>
      
      <!-- StartNewCodigo -->
      <!-- <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-\- Entrando a ComponenValidationBackup -\-'"></xsl:with-param></xsl:call-template>-->
      <xsl:variable name="CFDI"><dp:serialize select="/" omit-xml-decl="yes"/></xsl:variable>
             
      <xsl:variable name="CFDIB64" select="dp:encode($CFDI,'base-64')"/>
        
      
      
      <!--Archivo Guardado dentro de WebService local:///XSLs/SAT/cadenaoriginal_3_3.xslt-->
      <xsl:variable name="VersionXSLPath" select="'local:///XSLs/SAT/cadenaoriginal_3_3.xslt'" />
      
      <!-- Se calcula la cadena original -->
      <xsl:variable name="cadenaOriginal" select="dp:transform($VersionXSLPath,/*)"/>
      
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'IMPRIMECADENAORIGINALLLLLLLLLLCVB'"></xsl:with-param></xsl:call-template>
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$cadenaOriginal"></xsl:with-param></xsl:call-template>      
                 
      <!-- Algoritmos de cryptografía PARA LA VERISON 3.3 EN SHA256-->
      <!--<xsl:variable name="algorithmHash">
         <xsl:call-template name="getPropertyValue">
            <xsl:with-param name="name" select="'ALGORITHMHASH'" />
         </xsl:call-template>
      </xsl:variable>-->
      
      
      <!--<xsl:variable name="algorithmSignature">
         <xsl:call-template name="getPropertyValue">
            <xsl:with-param name="name" select="'ALGORITHMSIGNATURE'" />
         </xsl:call-template>
      </xsl:variable>-->
      
      <!-- Correccion de la cadena original -->
      <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
      <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
      <!--covierte de base-64 a hexa-->
      <xsl:variable name="hashCadenaOriginal" select="translate(substring(dp:radix-convert(concat('8AAA',dp:hash($algorithmHash,$cadenaOriginal)),64,16),7), $uppercase, $smallcase)" />
      
      <!-- Imprime hash de la cadena original -->
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Hash Cadena original --'"></xsl:with-param></xsl:call-template>
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$hashCadenaOriginal"></xsl:with-param></xsl:call-template>
          
      
      <!--**************************************Start New codigo*********************************************************-->
          
      <!-- Serie --> 
      <xsl:variable name="serie1">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/@Serie) != ''">
               <serie1>
                  <xsl:value-of select="/*[local-name()='Comprobante']/@Serie"/>
               </serie1>
            </xsl:when>
            <xsl:otherwise>
               <serie1>
                  <xsl:value-of select="'null'"/>
               </serie1>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable> 
     
      
      
      <!-- Sello -->
      <xsl:variable name="sello">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/@Sello) != ''">
               <sello>
                  <xsl:value-of select="/*[local-name()='Comprobante']/@Sello"/>
               </sello>
            </xsl:when>
            <xsl:otherwise>
               <sello>
                  <xsl:value-of select="'null'"/>
               </sello>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>    
      
      
      
      <!-- Folio -->
      <xsl:variable name="folio1">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/@Folio) != ''">
               <folio1>
                  <xsl:value-of select="/*[local-name()='Comprobante']/@Folio"/>
               </folio1>
            </xsl:when>
            <xsl:otherwise>
               <folio1>
                  <xsl:value-of select="'null'"/>
               </folio1>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>    
      
      
      
      <!-- FormaPago -->
      <xsl:variable name="FormaPago">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/@FormaPago) != ''">
               <FormaPago>
                  <xsl:value-of select="/*[local-name()='Comprobante']/@FormaPago"/>
               </FormaPago>
            </xsl:when>
            <xsl:otherwise>
               <FormaPago>
                  <xsl:value-of select="'null'"/>
               </FormaPago>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>    
      
            
      
      <!--Fecha-->
      
      <!-- CFDiDate -->
      <xsl:variable name="CFDiDate">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/@Fecha) != ''">
               <CFDiDate>
                  <xsl:value-of select="/*[local-name()='Comprobante']/@Fecha"/>
               </CFDiDate>
            </xsl:when>
            <xsl:otherwise>
               <CFDiDate>
                  <xsl:value-of select="'null'"/>
               </CFDiDate>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable> 
      
      
      <!-- Certificado -->
      <xsl:variable name="certB64">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/@Certificado) != ''">
               <certB64>
                  <xsl:value-of select="/*[local-name()='Comprobante']/@Certificado"/>
               </certB64>
            </xsl:when>
            <xsl:otherwise>
               <certB64>
                  <xsl:value-of select="'null'"/>
               </certB64>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable> 
      
      
      <!-- NoCertificado -->
      <xsl:variable name="nocertificado1">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/@NoCertificado) != ''">
               <nocertificado1>
                  <xsl:value-of select="/*[local-name()='Comprobante']/@NoCertificado"/>
               </nocertificado1>
            </xsl:when>
            <xsl:otherwise>
               <nocertificado1>
                  <xsl:value-of select="'null'"/>
               </nocertificado1>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable> 
     
      
    
   
      
      <!-- Moneda -->
      <xsl:variable name="Moneda">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/@Moneda) != ''">
               <Moneda>
                  <xsl:value-of select="/*[local-name()='Comprobante']/@Moneda"/>
               </Moneda>
            </xsl:when>
            <xsl:otherwise>
               <Moneda>
                  <xsl:value-of select="'null'"/>
               </Moneda>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
  
      
      <!-- TipoCambio -->
      <xsl:variable name="TipoCambio">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/@TipoCambio) != ''">
               <TipoCambio>
                  <xsl:value-of select="/*[local-name()='Comprobante']/@TipoCambio"/>
               </TipoCambio>
            </xsl:when>
            <xsl:otherwise>
               <TipoCambio>
                  <xsl:value-of select="'null'"/>
               </TipoCambio>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
  
      
      <!-- Total -->
      <xsl:variable name="Total1">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/@Total) != ''">
               <Total1>
                  <xsl:value-of select="/*[local-name()='Comprobante']/@Total"/>
               </Total1>
            </xsl:when>
            <xsl:otherwise>
               <Total1>
                  <xsl:value-of select="'null'"/>
               </Total1>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>   
      
      
      <!-- TipoDeComprobante -->
      <xsl:variable name="TipoDeComprobante">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/@TipoDeComprobante) != ''">
               <TipoDeComprobante>
                  <xsl:value-of select="/*[local-name()='Comprobante']/@TipoDeComprobante"/>
               </TipoDeComprobante>
            </xsl:when>
            <xsl:otherwise>
               <TipoDeComprobante>
                  <xsl:value-of select="'null'"/>
               </TipoDeComprobante>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      
      <!-- MetodoPago -->
      <xsl:variable name="MetodoPago">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/@MetodoPago) != ''">
               <MetodoPago>
                  <xsl:value-of select="/*[local-name()='Comprobante']/@MetodoPago"/>
               </MetodoPago>
            </xsl:when>
            <xsl:otherwise>
               <MetodoPago>
                  <xsl:value-of select="'null'"/>
               </MetodoPago>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>  
      
              
      
      <!-- LugarExpedicion -->
      <xsl:variable name="LugarExpedicion">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/@LugarExpedicion) != ''">
               <LugarExpedicion>
                  <xsl:value-of select="/*[local-name()='Comprobante']/@LugarExpedicion"/>
               </LugarExpedicion>
            </xsl:when>
            <xsl:otherwise>
               <LugarExpedicion>
                  <xsl:value-of select="'null'"/>
               </LugarExpedicion>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      
      <!-- RfcEmisor -->
      <xsl:variable name="RfcEmisor">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Emisor']/@Rfc) != ''">
               <RfcEmisor>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Emisor']/@Rfc"/>
               </RfcEmisor>
            </xsl:when>
            <xsl:otherwise>
               <RfcEmisor>
                  <xsl:value-of select="'null'"/>
               </RfcEmisor>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      
      <!-- NombreEmisor -->
      <xsl:variable name="NombreEmisor">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Emisor']/@Nombre) != ''">
               <NombreEmisor>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Emisor']/@Nombre"/>
               </NombreEmisor>
            </xsl:when>
            <xsl:otherwise>
               <NombreEmisor>
                  <xsl:value-of select="'null'"/>
               </NombreEmisor>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      
      <!-- RegimenFiscalEmisor -->
      <xsl:variable name="RegimenFiscalEmisor">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Emisor']/@RegimenFiscal) != ''">
               <RegimenFiscalEmisor>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Emisor']/@RegimenFiscal"/>
               </RegimenFiscalEmisor>
            </xsl:when>
            <xsl:otherwise>
               <RegimenFiscalEmisor>
                  <xsl:value-of select="'null'"/>
               </RegimenFiscalEmisor>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      
      <!-- RfcReceptor -->
      <xsl:variable name="RfcReceptor">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Receptor']/@Rfc) != ''">
               <RfcReceptor>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Receptor']/@Rfc"/>
               </RfcReceptor>
            </xsl:when>
            <xsl:otherwise>
               <RfcReceptor>
                  <xsl:value-of select="'null'"/>
               </RfcReceptor>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      

      <!-- NombreReceptor -->
      <xsl:variable name="NombreReceptor">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Receptor']/@Nombre) != ''">
               <NombreReceptor>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Receptor']/@Nombre"/>
               </NombreReceptor>
            </xsl:when>
            <xsl:otherwise>
               <NombreReceptor>
                  <xsl:value-of select="'null'"/>
               </NombreReceptor>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      
      <!-- UsoCFDIReceptor -->
      <xsl:variable name="UsoCFDIReceptor">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Receptor']/@UsoCFDI) != ''">
               <UsoCFDIReceptor>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Receptor']/@UsoCFDI"/>
               </UsoCFDIReceptor>
            </xsl:when>
            <xsl:otherwise>
               <UsoCFDIReceptor>
                  <xsl:value-of select="'null'"/>
               </UsoCFDIReceptor>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      
      
      
      <!-- ClaveProdServ -->
      <xsl:variable name="ClaveProdServ">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@ClaveProdServ) != ''">
               <ClaveProdServ>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@ClaveProdServ"/>
               </ClaveProdServ>
            </xsl:when>
            <xsl:otherwise>
               <ClaveProdServ>
                  <xsl:value-of select="'null'"/>
               </ClaveProdServ>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      
      
      <!-- NoIdentificacion -->
      <xsl:variable name="NoIdentificacion">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@NoIdentificacion) != ''">
               <NoIdentificacion>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@NoIdentificacion"/>
               </NoIdentificacion>
            </xsl:when>
            <xsl:otherwise>
               <NoIdentificacion>
                  <xsl:value-of select="'null'"/>
               </NoIdentificacion>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- Cantidad -->
      <xsl:variable name="Cantidad">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Cantidad) != ''">
               <Cantidad>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Cantidad"/>
               </Cantidad>
            </xsl:when>
            <xsl:otherwise>
               <Cantidad>
                  <xsl:value-of select="'null'"/>
               </Cantidad>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- ClaveUnidad -->
      <xsl:variable name="ClaveUnidad">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@ClaveUnidad) != ''">
               <ClaveUnidad>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@ClaveUnidad"/>
               </ClaveUnidad>
            </xsl:when>
            <xsl:otherwise>
               <ClaveUnidad>
                  <xsl:value-of select="'null'"/>
               </ClaveUnidad>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      
      <!-- Unidad -->
      <xsl:variable name="Unidad">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Unidad) != ''">
               <Unidad>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Unidad"/>
               </Unidad>
            </xsl:when>
            <xsl:otherwise>
               <Unidad>
                  <xsl:value-of select="'null'"/>
               </Unidad>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- Descripcion -->    
      <xsl:variable name="Descripcion">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descripcion) != ''">
               <Descripcion>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descripcion"/>
               </Descripcion>
            </xsl:when>
            <xsl:otherwise>
               <Descripcion>
                  <xsl:value-of select="'null'"/>
               </Descripcion>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- ValorUnitario -->
      <xsl:variable name="ValorUnitario">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@ValorUnitario) != ''">
               <ValorUnitario>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@ValorUnitario"/>
               </ValorUnitario>
            </xsl:when>
            <xsl:otherwise>
               <ValorUnitario>
                  <xsl:value-of select="'null'"/>
               </ValorUnitario>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- Importe -->
      <xsl:variable name="Importe">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Importe) != ''">
               <Importe>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Importe"/>
               </Importe>
            </xsl:when>
            <xsl:otherwise>
               <Importe>
                  <xsl:value-of select="'null'"/>
               </Importe>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      
      <!-- Descuento -->
      <xsl:variable name="Descuento">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento) != ''">
               <Descuento>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento"/>
               </Descuento>
            </xsl:when>
            <xsl:otherwise>
               <Descuento>
                  <xsl:value-of select="'null'"/>
               </Descuento>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- Base -->
      <xsl:variable name="Base">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@Base) != ''">
               <Base>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@Base"/>
               </Base>
            </xsl:when>
            <xsl:otherwise>
               <Base>
                  <xsl:value-of select="'null'"/>
               </Base>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      
      <!-- Impuesto -->    
      <xsl:variable name="Impuesto">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@Impuesto) != ''">
               <Impuesto>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@Impuesto"/>
               </Impuesto>
            </xsl:when>
            <xsl:otherwise>
               <Impuesto>
                  <xsl:value-of select="'null'"/>
               </Impuesto>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      
          
      <!-- TipoFactor -->
      <xsl:variable name="TipoFactor">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@TipoFactor) != ''">
               <TipoFactor>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@TipoFactor"/>
               </TipoFactor>
            </xsl:when>
            <xsl:otherwise>
               <TipoFactor>
                  <xsl:value-of select="'null'"/>
               </TipoFactor>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      
      <!-- TasaOCuota -->
      <xsl:variable name="TasaOCuota">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@TasaOCuota) != ''">
               <TasaOCuota>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@TasaOCuota"/>
               </TasaOCuota>
            </xsl:when>
            <xsl:otherwise>
               <TasaOCuota>
                  <xsl:value-of select="'null'"/>
               </TasaOCuota>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      
      <!-- ImporteCon -->
      <xsl:variable name="ImporteCon">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@Importe) != ''">
               <ImporteCon>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@Importe"/>
               </ImporteCon>
            </xsl:when>
            <xsl:otherwise>
               <ImporteCon>
                  <xsl:value-of select="'null'"/>
               </ImporteCon>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- BaseR -->
      <xsl:variable name="BaseR">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencione']/@Base) != ''">
               <BaseR>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencione']/@Base"/>
               </BaseR>
            </xsl:when>
            <xsl:otherwise>
               <BaseR>
                  <xsl:value-of select="'null'"/>
               </BaseR>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- TasaOCuota -->    
            <xsl:variable name="TasaOCuota">
               <xsl:choose>
                  <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@TasaOCuota) != ''">
                     <TasaOCuota>
                        <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@TasaOCuota"/>
                     </TasaOCuota>
                  </xsl:when>
                  <xsl:otherwise>
                     <TasaOCuota>
                        <xsl:value-of select="'null'"/>
                     </TasaOCuota>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
      
      <!-- ImporteCon -->    
       <xsl:variable name="ImporteCon">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@Importe) != ''">
               <ImporteCon>
                   <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@Importe"/>
               </ImporteCon>
            </xsl:when>
            <xsl:otherwise>
              <ImporteCon>
                 <xsl:value-of select="'null'"/>
              </ImporteCon>
             </xsl:otherwise>
         </xsl:choose>
       </xsl:variable>
      
      <!-- BaseR -->
        
      <xsl:variable name="BaseR">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencione']/@Base) != ''">
               <BaseR>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencione']/@Base"/>
               </BaseR>
            </xsl:when>
            <xsl:otherwise>
               <BaseR>
                  <xsl:value-of select="'null'"/>
               </BaseR>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- ImpuestoR -->    
          
      <xsl:variable name="ImpuestoR">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencione']/@Impuesto) != ''">
               <ImpuestoR>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencione']/@Impuesto"/>
               </ImpuestoR>
            </xsl:when>
            <xsl:otherwise>
               <ImpuestoR>
                  <xsl:value-of select="'null'"/>
               </ImpuestoR>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- TipoFactorR -->
      <xsl:variable name="TipoFactorR" select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencione']/@TipoFactor" />    
      
      
      
      <!-- TasaOCuotaR -->
      <xsl:variable name="TasaOCuotaR" select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencione']/@TasaOCuota" />    
      
      
      <!-- ImporteR -->
      <xsl:variable name="ImporteR">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencione']/@Importe) != ''">
               <ImporteR>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencione']/@Importe"/>
               </ImporteR>
            </xsl:when>
            <xsl:otherwise>
               <ImporteR>
                  <xsl:value-of select="'null'"/>
               </ImporteR>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- TotalImpuestosRetenidos --> 
      <xsl:variable name="TotalImpuestosRetenidos">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosRetenidos) != ''">
               <TotalImpuestosRetenidos>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosRetenidos"/>
               </TotalImpuestosRetenidos>
            </xsl:when>
            <xsl:otherwise>
               <TotalImpuestosRetenidos>
                  <xsl:value-of select="'null'"/>
               </TotalImpuestosRetenidos>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- TotalImpuestosTrasladados -->
      <xsl:variable name="TotalImpuestosTrasladados">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosTrasladados) != ''">
               <TotalImpuestosTrasladados>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosTrasladados"/>
               </TotalImpuestosTrasladados>
            </xsl:when>
            <xsl:otherwise>
               <TotalImpuestosTrasladados>
                  <xsl:value-of select="'null'"/>
               </TotalImpuestosTrasladados>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      
     
      
          
      <!-- ImporteIR -->
      <xsl:variable name="ImporteIR">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion']/@Importe) != ''">
               <ImporteIR>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Comprobante']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion']/@Importe"/>
               </ImporteIR>
            </xsl:when>
            <xsl:otherwise>
               <ImporteIR>
                  <xsl:value-of select="'null'"/>
               </ImporteIR>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- ImpuestoIT -->    
      <xsl:variable name="ImpuestoIT">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@Impuesto) != ''">
               <ImpuestoIT>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@Impuesto"/>
               </ImpuestoIT>
            </xsl:when>
            <xsl:otherwise>
               <ImpuestoIT>
                  <xsl:value-of select="'null'"/>
               </ImpuestoIT>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
        
      <!-- TipoFactorIT -->
      <xsl:variable name="TipoFactorIT">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@TipoFactor) != ''">
               <TipoFactorIT>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@TipoFactor"/>
               </TipoFactorIT>
            </xsl:when>
            <xsl:otherwise>
               <TipoFactorIT>
                  <xsl:value-of select="'null'"/>
               </TipoFactorIT>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- TasaOCuotaIT -->    
      <xsl:variable name="TasaOCuotaIT">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@TasaOCuota) != ''">
               <TasaOCuotaIT>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@TasaOCuota"/>
               </TasaOCuotaIT>
            </xsl:when>
            <xsl:otherwise>
               <TasaOCuotaIT>
                  <xsl:value-of select="'null'"/>
               </TasaOCuotaIT>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable> 
      
      <!-- ImporteIT -->    
      <xsl:variable name="ImporteIT">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@Importe) != ''">
               <ImporteIT>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@Importe"/>
               </ImporteIT>
            </xsl:when>
            <xsl:otherwise>
               <ImporteIT>
                  <xsl:value-of select="'null'"/>
               </ImporteIT>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable> 
      
      <!-- NumeroPedimento -->
      <xsl:variable name="NumeroPedimento">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='InformacionAduanera']/@NumeroPedimento) != ''">
               <NumeroPedimento>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='InformacionAduanera']/@NumeroPedimento"/>
               </NumeroPedimento>
            </xsl:when>
            <xsl:otherwise>
               <NumeroPedimento>
                  <xsl:value-of select="'null'"/>
               </NumeroPedimento>
            
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable> 
      
      <!-- NumeroPedimentoparte -->    
      <xsl:variable name="NumeroPedimentoparte">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Parte']/*[local-name()='InformacionAduanera']/@NumeroPedimento) != ''">
               <NumeroPedimentoparte>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Parte']/*[local-name()='InformacionAduanera']/@NumeroPedimento"/>
               </NumeroPedimentoparte>
            </xsl:when>
            <xsl:otherwise>
               <NumeroPedimentoparte>
                  <xsl:value-of select="'null'"/>
               </NumeroPedimentoparte>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>                        
      
   
      
      
      <!-- UnidadConcepto --> 
      <xsl:variable name="ClaveUnidad">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@ClaveUnidad) != ''">
               <UnidadConcepto>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@ClaveUnidad"/>
               </UnidadConcepto>
            </xsl:when>
            <xsl:otherwise>
               <UnidadConcepto>
                  <xsl:value-of select="'null'"/>
               </UnidadConcepto>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable> 
      
      
      
      <!-- UnidadParte -->    
      <xsl:variable name="UnidadParte">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Parte']/@Unidad) != ''">
               <UnidadParte>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Parte']/@Unidad"/>
               </UnidadParte>
            </xsl:when>
            <xsl:otherwise>
               <UnidadParte>
                  <xsl:value-of select="'null'"/>
               </UnidadParte>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable> 
      
      <!-- CodigoPostal -->
      <xsl:variable name="CodigoPostal">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conplemento']/*[local-name()='notariospublicos:NotariosPublicos']/*[local-name()='notariospublicos:DescInmuebles']/*[local-name()='notariospublicos:DescInmueble']/@CodigoPostal) != ''">
               <CodigoPostal>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conplemento']/*[local-name()='notariospublicos:NotariosPublicos']/*[local-name()='notariospublicos:DescInmuebles']/*[local-name()='notariospublicos:DescInmueble']/@CodigoPostal"/>
               </CodigoPostal>
            </xsl:when>
            <xsl:otherwise>
               <CodigoPostal>
                  <xsl:value-of select="'null'"/>
               </CodigoPostal>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable> 
      
    
      <!-- ClaveProdServParte -->
      <xsl:variable name="ClaveProdServParte">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Parte']/@ClaveProdServ) != ''">
               <ClaveProdServParte>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Parte']/@ClaveProdServ"/>
               </ClaveProdServParte>
            </xsl:when>
            <xsl:otherwise>
               <ClaveProdServParte>
                  <xsl:value-of select="'null'"/>
               </ClaveProdServParte>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable> 
      
    
      <!-- Pais -->
      <xsl:variable name="Pais">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conplemento']/*[local-name()='notariospublicos:NotariosPublicos']/*[local-name()='notariospublicos:DescInmuebles']/*[local-name()='notariospublicos:DescInmueble']/@Pais) != ''">
               <Pais>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conplemento']/*[local-name()='notariospublicos:NotariosPublicos']/*[local-name()='notariospublicos:DescInmuebles']/*[local-name()='notariospublicos:DescInmueble']/@Pais"/>
               </Pais>
            </xsl:when>
            <xsl:otherwise>
               <Pais>
                  <xsl:value-of select="'null'"/>
               </Pais>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable> 
      
      
      <!-- NumRegIdTrib -->
      <xsl:variable name="NumRegIdTrib">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Receptor']/@NumRegIdTrib) != ''">
               <NumRegIdTrib>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Receptor']/@NumRegIdTrib"/>
               </NumRegIdTrib>
            </xsl:when>
            <xsl:otherwise>
               <NumRegIdTrib>
                  <xsl:value-of select="'null'"/>
               </NumRegIdTrib>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable> 
      
      
      <!-- TipoFactorTraslado -->
      
      <xsl:variable name="TipoFactorTraslado">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@TipoFactor) != ''">
               <TipoFactorTraslado>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@TipoFactor"/>
               </TipoFactorTraslado>
            </xsl:when>
            <xsl:otherwise>
               <TipoFactorTraslado>
                  <xsl:value-of select="'null'"/>
               </TipoFactorTraslado>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable> 
      
      
      <!-- TipoFactorRetencion -->    
      <xsl:variable name="TipoFactorRetencion">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion']/@TipoFactor) != ''">
               <TipoFactorRetencion>
                  <xsl:value-of select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion']/@TipoFactor"/>
               </TipoFactorRetencion>
            </xsl:when>
            <xsl:otherwise>
               <TipoFactorRetencion>
                  <xsl:value-of select="'null'"/>
               </TipoFactorRetencion>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable> 
      
      <!--Confirmacion-->
      <xsl:variable name="confirmacion1">
         <xsl:choose>
            <xsl:when test="normalize-space(/*[local-name()='Comprobante']/@Confirmacion) != ''">
               <confirmacion1>
                  <xsl:value-of select="/*[local-name()='Comprobante']/@Confirmacion"/>
               </confirmacion1>
            </xsl:when>
            <xsl:otherwise>
               <confirmacion1>
                  <xsl:value-of select="'null'"/>
               </confirmacion1>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable> 
      
      
      <!--New CodeTipoAccion-->                
      <!--Validacion para guardar en la DB 0 - 1 dependiendo errores sinErrores-->
      <xsl:variable name="tipoAccion1">         
         <xsl:choose>
            <!--xsl:when test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-BaseRetencionesMayorCero/text()) = 'false'"-->
            <!--xsl:when test="dp:variable('var://context/TCore/ResultGenrGen') != ''"-->            
            <!--<xsl:when test="substring-before(substring-after(dp:variable('var://context/TCore/ResultGenrGen'),'fa'),'se') != ''">-->
            <xsl:when test="contains(dp:variable('var://context/TCore/ResultGenrGen'),'false')">
               <tipoAccion1>    
                  <!-- 0 Con Errores -->
                  <xsl:value-of select="'0'"/>                 
               </tipoAccion1>               
            </xsl:when>
            <xsl:otherwise>
               <xsl:choose>                  
                  <xsl:when test="dp:variable('var://system/TCore/VariNegocio') = 'false'">
                     <tipoAccion1>    
                        <!-- 0 Con Errores -->
                        <xsl:value-of select="'0'"/>                  
                     </tipoAccion1>                
                  </xsl:when>
                  <xsl:otherwise>
                     <tipoAccion1>    
                        <!-- 1 Sin Errores -->
                       <xsl:value-of select="'1'"/>  
                        <!--xsl:value-of select="'0'"/--> 
                     </tipoAccion1>    
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:otherwise>           
         </xsl:choose>     
         
      </xsl:variable>            
      <!--END CodeTipoAccion-->
      
      
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'Imprimiendo ERRRRRRRORRRRRRRRRRR'"></xsl:with-param></xsl:call-template>
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$tipoAccion1"></xsl:with-param></xsl:call-template>
           
      
      <xsl:variable name="RESTauthResult">
         
         <xsl:variable name="VariAPIUser" select="dp:variable('var://system/TCore/RESTauthResultDEBUG1')"/>                           
        
               
         <xsl:variable name="idUsuario33" select="$VariAPIUser/resultadoDatapowerXml/idUsuario"/>
         
         <xsl:if test="$CFDiDate = 'null'">            
            <xsl:variable name="idUsuario33" select="'1'"/>
         </xsl:if>
         
         <!--<xsl:if test="$VariAPIUser/resultadoDatapowerXml/CFDI401 = 'false'"> 
            <dp:set-variable name="'var://context/TCore/ErrorNegoc'" value="'CFDI401'"/> 
            <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'ImprimiendoNegocioooo'"></xsl:with-param></xsl:call-template>
         </xsl:if> -->
         
         <!--Variables personales-->                                            
         <xsl:variable name="request1" select="'null'"/>
         <xsl:variable name="complemento1" select="'null'"/>
         <xsl:variable name="tiempo12" select="'0'"/>        
         <!--xsl:variable name="tipoAccion1" select="'0'"/-->
         
         <!--StartJsonColocarDB-->
         <xsl:variable name="var_uuid" select="concat('{|uuid|:|',$UUID,'|,')"/>
         <xsl:variable name="var_hash" select="concat('|hash|:|',$hashCadenaOriginal,'|,')"/> 
         <xsl:variable name="var_rfc_emisor" select="concat('|rfc_emisor|:|',$RfcEmisor,'|,')"/>
         <xsl:variable name="var_rfc_receptor" select="concat('|rfc_receptor|:|',$RfcReceptor,'|,')"/>
         <xsl:variable name="var_fecha_timbrado" select="concat('|fecha_timbrado|:|',$Now,'|,')"/>
         <xsl:variable name="var_monto" select="concat('|monto|:|',$Total1,'|,')"/>
         <xsl:variable name="var_id_usuario" select="concat('|id_usuario|:|',$idUsuario33,'|,')"/>
         <xsl:variable name="var_xml" select="concat('|xml|:|',$CFDIB64,'|,')"/>       
         <xsl:variable name="var_request" select="concat('|request|:|',$request1,'|,')"/>
         <xsl:variable name="var_serie" select="concat('|serie|:|',$serie1,'|,')"/>
         <xsl:variable name="var_folio" select="concat('|folio|:|',$folio1,'|,')"/>
         <xsl:variable name="var_fecha_emision" select="concat('|fecha_emision|:|',$CFDiDate,'|,')"/>
         <xsl:variable name="var_complemento" select="concat('|complemento|:|',$complemento1,'|,')"/>
         <xsl:variable name="var_codigo" select="concat('|codigo|:|',$CodigoPostal,'|,')"/>
         <xsl:variable name="var_tiempo" select="concat('|tiempo|:|',$tiempo12,'|,')"/>
         <xsl:variable name="var_tipo_accion" select="concat('|tipo_accion|:|',$tipoAccion1,'|,')"/>
         <xsl:variable name="var_numero_certificado" select="concat('|numero_certificado|:|',$nocertificado1,'|,')"/>
         <xsl:variable name="var_timbre_global" select="concat('|timbre_global|:|',$timbreGlobal,'|,')"/>
        <!-- <xsl:variable name="var_numero_certificadoSAT" select="concat('|numero_certificado_sat|:|',$NoCertificatePAC,'|,')"/>
         <xsl:variable name="var_selloCFD" select="concat('|sello_cfd|:|',$SelloCFD,'|,')"/>
         <xsl:variable name="var_selloSAT" select="concat('|sello_sat|:|',$SelloPAC,'|,')"/>
         <xsl:variable name="var_version" select="concat('|version|:|',$Version,'|,')"/>
         <xsl:variable name="var_rfcProvCertif" select="concat('|rfc_prov_certf|:|',$RfcProvCertif,'|,')"/>
         <xsl:variable name="var_leyenda" select="concat('|leyenda|:|',$Leyenda,'|,')"/>  -->                                        
         <xsl:variable name="var_confirmacion" select="concat('|confirmacion|:|',$confirmacion1,'|}')"/>                 
         
         <xsl:variable name="JsonApiGenDb1" select="concat($var_uuid,$var_hash,$var_rfc_emisor,$var_rfc_receptor,$var_fecha_timbrado,$var_monto,$var_id_usuario)"/>
         <xsl:variable name="JsonApiGenDb2" select="concat($var_xml,$var_request,$var_serie,$var_folio,$var_fecha_emision,$var_complemento,$var_codigo,$var_tiempo,$var_tipo_accion,$var_numero_certificado)"/> 
         <xsl:variable name="JsonApiGenDb21" select="concat($var_timbre_global,$var_confirmacion)"/>        
         <xsl:variable name="JsonApiGenDb3" select="concat($var_request,$var_serie,$var_folio,$var_fecha_emision,$var_complemento,$var_codigo,$var_tiempo,$var_tipo_accion,$var_numero_certificado)"/>
        <!-- <xsl:variable name="JsonApiGenDb" select="concat($JsonApiGenDb1,$JsonApiGenDb2)"/>-->
         <xsl:variable name="JsonApiGenDb" select="concat($JsonApiGenDb1,$JsonApiGenDb2,$JsonApiGenDb21)"/>
         <xsl:variable name="JsonApiGenDb4" select="concat($JsonApiGenDb1,$JsonApiGenDb3,$JsonApiGenDb21)"/>
         <xsl:variable name="JsonApiGenDbB64" select="dp:encode($JsonApiGenDb,'base-64')"/>
         
         <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'IMPRIMIENDO-JSONDBENDDBDBDBDBDBDBDBDBDBD'"></xsl:with-param></xsl:call-template>
         <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$JsonApiGenDb4"></xsl:with-param></xsl:call-template>
         <!--EndJsonColocarDB-->
                  
         

         <!--xsl:variable name="ResulURLTotal" select="concat('http',':','/','/','xpd.praxis.uxm.mx:8080/gateway/timbrar/')"/-->
         <!--xsl:variable name="ResulURLTotal" select="concat('http',':','/','/','lxvmlbha1p.xpd.mx:8585/gateway/timbrar/')"/-->
         <xsl:variable name="ResulURLTotal" select="concat('http',':','/','/','api.des.local:8585/gateway/timbrar/')"/>
         
        
         <!--dp:url-open target="{$ResulURLTotal}" response="xml" data-type="xml" content-type="application/xml" timeout="10" http-method="post">         
            <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'Imprimiendo $ResulURLTotal'"></xsl:with-param></xsl:call-template>
            <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$ResulURLTotal"></xsl:with-param></xsl:call-template>                              
         </dp:url-open--> 
         
         <dp:url-open target="{$ResulURLTotal}" response="xml" data-type="xml" content-type="application/xml" timeout="30" http-method="post">
            <soapenv:Envelope>
               <soapenv:Header/>
               <soapenv:Body>
                  <Request>
                     <Message>      						      					
                        <xsl:value-of select="concat($JsonApiGenDbB64)"/>
                     </Message>
                  </Request>
               </soapenv:Body>
            </soapenv:Envelope>
            
            <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Imprimiendo ResulURLTotal--'"></xsl:with-param></xsl:call-template>
            <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$ResulURLTotal"></xsl:with-param></xsl:call-template>
            
                
            
         </dp:url-open> 
      </xsl:variable>
      <!--Variables para uso futuro-->
      
      
      <dp:set-variable name="'var://context/TCore/RESTauthResultDEBUG'" value="$RESTauthResult"/>
      
      
     <xsl:variable name="ResultGenUrl">  
         <Detail>
      <xsl:if test="$RESTauthResult/resultadoDatapowerXml/idUsuario = 'false'"> 
         <xsl:variable name="idUsuario" select="$RESTauthResult/resultadoDatapowerXml/idUsuario"/>
         <errorid501><xsl:value-of select="'false'" /></errorid501>
         <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-\- IMPRIMIENDO-IDUSUARIO -\-'"></xsl:with-param></xsl:call-template>
         
      </xsl:if>
      
      
      <xsl:if test="$RESTauthResult/resultadoDatapowerXml/user = 'false'"> 
         <errorus501><xsl:value-of select="'false'" /></errorus501>      
      </xsl:if>
      
      <xsl:if test="$RESTauthResult/resultadoDatapowerXml/pass = 'false'"> 
         <errorpa501><xsl:value-of select="'false'" /></errorpa501>         
      </xsl:if>
      
      <xsl:if test="$RESTauthResult/resultadoDatapowerXml/hashCFDI = 'false'"> 
         <errorha301><xsl:value-of select="'false'" /></errorha301> 
      </xsl:if>
      
      <xsl:if test="$RESTauthResult/resultadoDatapowerXml/rfc = 'false'"> 
         <errorrf402><xsl:value-of select="'false'" /></errorrf402> 
      </xsl:if>
         
      <xsl:if test="$RESTauthResult/resultadoDatapowerXml/fecha = 'false'">         
         <errorfeNOMI101><xsl:value-of select="'false'" /></errorfeNOMI101>
      </xsl:if>
      
      
      <xsl:if test="$RESTauthResult/resultadoDatapowerXml/numeropedimento = 'false'">
         <errornup301><xsl:value-of select="'false'" /></errornup301>
      </xsl:if>
      
      
      <xsl:if test="$RESTauthResult/resultadoDatapowerXml/numeropedimentoparte = 'false'"> 
         <errornupa301><xsl:value-of select="'false'" /></errornupa301>         
      </xsl:if>
      
      
      <xsl:if test="$RESTauthResult/resultadoDatapowerXml/uuid = 'false'"> 
         <erroruuid301><xsl:value-of select="'false'" /></erroruuid301>          
      </xsl:if>
      
      
      <xsl:if test="$RESTauthResult/resultadoDatapowerXml/unidadclave = 'false'">
         <errorunid301><xsl:value-of select="'false'" /></errorunid301>         
      </xsl:if>
      
      
      <xsl:if test="$RESTauthResult/resultadoDatapowerXml/codigopostal = 'false'">
         <errorcodp301><xsl:value-of select="'false'" /></errorcodp301>         
      </xsl:if>
      
      
      <xsl:if test="$RESTauthResult/resultadoDatapowerXml/claveprodserv = 'false'"> 
         <errorclavCFDI33143><xsl:value-of select="'false'" /></errorclavCFDI33143>  
      </xsl:if>
      
      
      <xsl:if test="$RESTauthResult/resultadoDatapowerXml/formapago = 'false'">
         <errorform301><xsl:value-of select="'false'" /></errorform301>
      </xsl:if>
      
      
      <xsl:if test="$RESTauthResult/resultadoDatapowerXml/metodopago = 'false'"> 
         <errormetop301><xsl:value-of select="'false'" /></errormetop301>
      </xsl:if>
      
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/moneda = 'false'">
               <errormnd142><xsl:value-of select="'false'" /></errormnd142>
            </xsl:if>
     
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/pais = 'false'">
               <errorpais301><xsl:value-of select="'false'" /></errorpais301>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/numregidtrib = 'false'">
               <errornrtCFDI33139><xsl:value-of select="'false'" /></errornrtCFDI33139>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/tipofactortraslado = 'false'">
               <errortftrl301><xsl:value-of select="'false'" /></errortftrl301>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/comprobante = 'false'">
               <errorcpbNOM110><xsl:value-of select="'false'" /></errorcpbNOM110>
            </xsl:if>
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/patente = 'false'">
               <errorptn301><xsl:value-of select="'false'" /></errorptn301>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/regimen = 'false'">
               <errorrgmNOM119><xsl:value-of select="'false'" /></errorrgmNOM119>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/relacion = 'false'">
               <errorrlc301><xsl:value-of select="'false'" /></errorrlc301>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/usoCfdi = 'false'">
               <errorucfdiCFDI33141><xsl:value-of select="'false'" /></errorucfdiCFDI33141>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/rfcReceptor = 'false'">
               <errorrfcRcNOM121><xsl:value-of select="'false'" /></errorrfcRcNOM121>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/fechaTimbrado = 'false'">
               <errorfctCFDI33101><xsl:value-of select="'false'" /></errorfctCFDI33101>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/monto = 'false'">
               <errormnt301><xsl:value-of select="'false'" /></errormnt301>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/xml = 'false'">
               <errorxml301><xsl:value-of select="'false'" /></errorxml301>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/request = 'false'">
               <errorrqst301><xsl:value-of select="'false'" /></errorrqst301>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/serie = 'false'">
               <errorsre301><xsl:value-of select="'false'" /></errorsre301>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/folio = 'false'">
               <errorfol301><xsl:value-of select="'false'" /></errorfol301>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/complemento = 'false'">
               <errorcmp301><xsl:value-of select="'false'" /></errorcmp301>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/codigo = 'false'">
               <errorcdg301><xsl:value-of select="'false'" /></errorcdg301>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/tiempo = 'false'"> 
               <errortmp301><xsl:value-of select="'false'" /></errortmp301>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/tipoAccion = 'false'">
               <errortpa301><xsl:value-of select="'false'" /></errortpa301>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/numeroCertificado = 'false'">
               <errornc301><xsl:value-of select="'false'" /></errornc301>
            </xsl:if>
            
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/claveImpuesto = 'false'"> 
               <errorclNOM103><xsl:value-of select="'false'" /></errorclNOM103>
            </xsl:if>
            
            <xsl:if test="$RESTauthResult/resultadoDatapowerXml/confirmacion = 'false'"> 
               <errorcon301><xsl:value-of select="'false'" /></errorcon301>  
            </xsl:if>      
      
      
         </Detail>
      </xsl:variable>
      
      <dp:set-variable name="'var://context/TCore/RESTauthResultDEBUG'" value="$ResultGenUrl"/>
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-\- Imprimiendo RESTauthResult-\-'"></xsl:with-param></xsl:call-template>
      <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$RESTauthResult"></xsl:with-param></xsl:call-template>
    
      
      <!--*********************************END New Codigo*****************************************************-->
     
      <!-- EndNewCodigo -->
      
      
   </xsl:template>

</xsl:stylesheet>
