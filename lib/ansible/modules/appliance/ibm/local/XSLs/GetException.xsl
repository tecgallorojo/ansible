<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:regexp="http://exslt.org/regular-expressions" exclude-result-prefixes="dp" extension-element-prefixes="dp">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" dp:escaping="minimum" />
	<xsl:strip-space elements="*"/>
             
	<xsl:import href="local:///XSLs/Commons/Utils33.xsl"/>

	<xsl:template match="/">
	  				
		
    <dp:set-variable name="'var://context/TCore/XSDExceptions'" value="''"/>
		
		<!--NuevasValidacionesDelAPI-->
		
	  <xsl:variable name="VariAPIGeneral" select="dp:variable('var://system/TCore/RESTauthResultDEBUG1')"/>
		
		<!--StartValidacionesAPI-->									
		
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ErrorNegoc')) = 'CFDI401'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'401,')"/>					
			<xsl:call-template name="SetError">
	      		<xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"/>
	      	</xsl:call-template>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ErrorNegoc')) = '402'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'402,')"/>					
			<xsl:call-template name="SetError">
				<xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ErrorNegoc')) = '301'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>					
			<xsl:call-template name="SetError">
				<xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"/>
			</xsl:call-template>
		</xsl:if>
		
		
		<xsl:if test="dp:variable('var://system/TCore/RESTauthResultDEBUG1')/resultadoDatapowerXml/CFDI301 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
			<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>	    
			
			<xsl:call-template name="SetError">
	      			<xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"/>
	      	</xsl:call-template>
		</xsl:if>
		
		<xsl:if test="dp:variable('var://system/TCore/RESTauthResultDEBUG1')/resultadoDatapowerXml/idUsuario = 'false'"> 
			<xsl:variable name="idUsuario" select="$RESTauthResult1/resultadoDatapowerXml/idUsuario"/>
			<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'501,')"/>	 
			<!--<xsl:call-template name="SetError">
	         		<xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"/>
	         	</xsl:call-template>-->	         	
		</xsl:if>
		
		<xsl:if test="dp:variable('var://system/TCore/RESTauthResultDEBUG1')/resultadoDatapowerXml/CFDI504 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'504,')"/>
			<dp:set-variable name="'var://context/TCore/TimbrePrevio'" value="dp:variable('var://system/TCore/RESTauthResultDEBUG1')/resultadoDatapowerXml/xmlprevio"/>
			<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>	    
			<xsl:call-template name="SetError">
	      			<xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"/>
	      		</xsl:call-template>
		</xsl:if>
		<xsl:if test="dp:variable('var://system/TCore/RESTauthResultDEBUG1')/resultadoDatapowerXml/CFDI502 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'502,')"/>
			<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>	    			
		</xsl:if>
		
		<xsl:if test="dp:variable('var://system/TCore/RESTauthResultDEBUG1')/resultadoDatapowerXml/timbres = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'503,')"/>  
			<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>	   
			
		</xsl:if>
		<xsl:if test="dp:variable('var://system/TCore/RESTauthResultDEBUG1')/resultadoDatapowerXml/rfc = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'402,')"/> 
			<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>	 
			
		</xsl:if>
		
		
		<!--EndValidacionesAPI-->
		
	   
      <xsl:variable name="VariAPIGenURL">  
         <Detail>

         	<xsl:if test="count(dp:variable('var://context/TCore/CFDiSchemeResult')//*[normalize-space(text()) = 'false']) &gt; 0" > <!-- Error en las validaciones de esquema -->
         		<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>			
         	</xsl:if>

       <xsl:if test="dp:variable('var://system/TCore/RESTauthResultDEBUG1')/resultadoDatapowerXml/idUsuario = 'false'"> 
         		<xsl:variable name="idUsuario" select="dp:variable('var://system/TCore/RESTauthResultDEBUG1')/resultadoDatapowerXml/idUsuario"/>
         		<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'501,')"/>         
      </xsl:if>
       
      <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/user = 'false'"> 
         <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'501,')"/>    
      </xsl:if>
      
      <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/pass = 'false'"> 
         <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'501,')"/>        
      </xsl:if>
      <!--<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/timbres = 'false'"> 
         <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'503,')"/>    
      </xsl:if>-->
      <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/hashCFDI = 'false'"> 
         <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'504,')"/>
      </xsl:if>

         	<!--ValidaSello302-->	  
         	<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ResultCertif/text()) = 'false'">
         		<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'302,')"/>
         	</xsl:if>
         	<xsl:if test="count(dp:variable('var://context/TCore/SignValidationResult')//*[normalize-space(text()) = 'false']) &gt; 0" > <!-- Error validacion del sello -->         		
         		<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'302,')"/>
         	</xsl:if>

         	<!--TipoValidanumeroCertificado-->
         	<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/numeroCertificado = 'false'">
         		<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'308,')"/>
         	</xsl:if>
         	
         	<xsl:if test="count(dp:variable('var://context/TCore/CertValidationResult')//*[normalize-space(text()) = 'false']) &gt; 0" > <!-- Error en las validaciones del certificado -->         		
         		
         		<xsl:if test="normalize-space(dp:variable('var://context/TCore/CertValidationResult')/Detail/CertEmisor/Emision/RFCIntegrity/text()) = 'false'"> <!-- RFC del emisor no coindice con el RFC del certificado -->
         			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'303,')"/>
         			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33105,')"/>
         		</xsl:if>
         		
         		<xsl:if test="normalize-space(dp:variable('var://context/TCore/CertValidationResult')/Detail/CertEmisor/Emision/InRange/text()) = 'false'"> <!-- RFC del emisor no coindice con el RFC del certificado -->
         			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'305,')"/>
         		</xsl:if>
         		
         		<xsl:if test="normalize-space(dp:variable('var://context/TCore/CertValidationResult')/Detail/CertEmisor/Open/text()) = 'false'"> <!-- Certificado revocado o cad -->
         			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'304,')"/>
         		</xsl:if>
         		
         		<xsl:if test="normalize-space(dp:variable('var://context/TCore/CertValidationResult')/Detail/CertEmisor/NotFiel/text()) = 'false'"> <!-- El error de la FIEL -->
         			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'306,')"/>
         		</xsl:if>
         		<!-- No firmado por una autoridad -->
         		<xsl:if test="normalize-space(dp:variable('var://context/TCore/CertValidationResult')/Detail/CertEmisor/SAT-issuer/text()) = 'false'"> 
         			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'308,')"/>
         		</xsl:if>
         		
         		<!--<xsl:if test="normalize-space(dp:variable('var://context/TCore/CertValidationResult')/Detail/CertEmisor/NoCert/text()) = 'false'"> 
         			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'308,')"/>
         		</xsl:if>-->
         		
         		<!--ValidaError 403-->
         		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/FechaXml/text()) = 'false'">
         			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'403,')"/>
         		</xsl:if>
         		
         	</xsl:if>         	         	         	                       	
         	
         </Detail>
      </xsl:variable>
      
      <dp:set-variable name="'var://context/TCore/RESTauthResultDEBUGAPI'" value="$VariAPIGenURL"/>	 
      	   	  	  	 	                   
		
		<!--FinNuevasValidacionesDelAPI-->

		<xsl:if test="count(dp:variable('var://context/TCore/AdmitCFDiResult')//*[normalize-space(text()) = 'false']) &gt; 0" > <!-- Error de admision -->
		  

        <xsl:if test="normalize-space(dp:variable('var://context/TCore/AdmitCFDiResult')/Detail/sinTimbre/text()) = 'false'"> <!-- timbrado previo -->
          <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'307,')"/>
        </xsl:if>		

        <xsl:if test="normalize-space(dp:variable('var://context/TCore/AdmitCFDiResult')/Detail/future/text()) = 'false'"> <!-- Despues de 1.5 horas -->
          <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'401,')"/>
        </xsl:if>

        <xsl:if test="normalize-space(dp:variable('var://context/TCore/AdmitCFDiResult')/Detail/inTime/text()) = 'false'"> <!-- en fecha -->
          <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'404,')"/>
        </xsl:if>

		</xsl:if>


		<!--Errores ComplementoDePago-->
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP101/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP101,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP102/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP102,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP103/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP103,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP104/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP104,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP105/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP105,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP106/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP106,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP107/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP107,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP108/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP108,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP109/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP109,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP110/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP110,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP111/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP111,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP112/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP112,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP113/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP113,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP114/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP114,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP115/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP115,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP116/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP116,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP117/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP117,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP118/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP118,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP119/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP119,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP120/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP120,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP121/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP121,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP122/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP122,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP201/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP201,')"/>
		</xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CRP201 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP201,')"/>  
		</xsl:if> 
		
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP202/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP202,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP203/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP203,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP204/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP204,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP205/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP205,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP206/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP206,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP207/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP207,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP208/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP208,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP208USD/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP208,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP209/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP209,')"/>			
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP210/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP210,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP211/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP211,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP212/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP212,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP213/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP213,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP214/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP214,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP215/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP215,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP216/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP216,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP217/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP217,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP218/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP218,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP219/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP219,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP220/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP220,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP221/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP221,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP222/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP222,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP222USD/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP222,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP223/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP223,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP224/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP224,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP224USD/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP224,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP225/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP225,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP225USD/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP225,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP226/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP226,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP227/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP227,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP228/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP228,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP229/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP229,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP230/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP230,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP231/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP231,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP232/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP232,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP233/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP233,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP234/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP234,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP235/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP235,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP236/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP236,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP237/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP237,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP238/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP238,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP239/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP239,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP240/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP240,')"/>
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ErrorCRP999/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CRP999,')"/>
		</xsl:if>
		<!--FINErrores ComplementoDePago-->
		
		<!-- Errores de Nomina 1.2 -->
   
		<!-- StartNomina1.2V33 -->
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM500/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM500,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM132/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM132,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM133/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM133,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM134/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM134,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM135/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM135,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM136/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM136,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM137/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM137,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM138/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM138,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM139/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM139,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM140/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM140,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM141/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM141,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM142/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM142,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM143/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM143,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM144/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM144,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM145/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM145,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM146/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM146,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM147/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM147,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM148/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM148,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM149/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM149,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM150/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM150,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM151/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM151,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM152/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM152,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM153/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM153,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM154/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM154,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM155/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM155,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM156/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM156,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM157/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM157,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM158/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM158,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM159/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM159,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM160/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM160,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM161/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM161,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM162/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM162,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM163/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM163,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM164/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM164,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM165/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM165,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM166/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM166,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM167/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM167,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM168/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM168,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM169/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM169,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM170/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM170,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM171/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM171,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM172/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM172,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM173/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM173,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM174/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM174,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM175/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM175,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM176/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM176,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM177/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM177,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM178/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM178,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM179/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM179,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM180/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM180,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM181/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM181,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM182/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM182,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM183/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM183,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM184/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM184,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM185/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM185,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM186/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM186,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM187/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM187,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM188/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM188,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM189/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM189,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM190/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM190,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM191/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM191,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM192/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM192,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM193/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM193,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM194/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM194,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM195/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM195,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM196/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM196,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM197/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM197,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM198/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM198,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM199/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM199,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM200/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM200,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM201/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM201,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM202/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM202,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM203/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM203,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM204/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM204,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM205/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM205,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM206/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM206,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM207/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM207,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM208/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM208,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM209/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM209,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM210/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM210,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM211/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM211,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM212/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM212,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM213/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM213,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM214/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM214,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM215/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM215,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM216/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM216,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM217/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM217,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM218/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM218,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM219/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM219,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM220/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM220,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM221/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM221,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM222/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM222,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM223/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM223,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM224/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM224,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/NominaValidationResult')/Detail/nomina12/NOM225/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'NOM225,')"/>      
		</xsl:if>
		<!-- EndNomina1.2V33 -->		
		<!-- Limpiando la Variable de Nomina -->
		<dp:set-variable name="'var://system/TCore/NominaValidationResult'" value="''" />

	<!-- StartValidationCCE 1.1 -->
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE500/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE500,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE101/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE101,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE145/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE145,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE146/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE146,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE147/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE147,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE148/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE148,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE149/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE149,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE150/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE150,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE151/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE151,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE152/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE152,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE153/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE153,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE154/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE154,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE155/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE155,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE156/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE156,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE157/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE157,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE158/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE158,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE159/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE159,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE160/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE160,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE161/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE161,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE162/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE162,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE163/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE163,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE164/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE164,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE165/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE165,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE166/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE166,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE167/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE167,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE168/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE168,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE169/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE169,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE170/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE170,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE171/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE171,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE172/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE172,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE173/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE173,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE174/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE174,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE175/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE175,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE176/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE176,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE177/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE177,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE178/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE178,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE179/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE179,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE180/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE180,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE181/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE181,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE182/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE182,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE183/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE183,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE184/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE184,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE185/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE185,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE186/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE186,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE187/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE187,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE188/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE188,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE189/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE189,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE190/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE190,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE191/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE191,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE192/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE192,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE193/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE193,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE194/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE194,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE195/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE195,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE196/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE196,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE197/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE197,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE198/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE198,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE199/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE199,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE200/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE200,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE201/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE201,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE202/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE202,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE203/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE203,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE204/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE204,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE205/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE205,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE206/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE206,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE207/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE207,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE208/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE208,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE209/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE209,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE210/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE210,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE211/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE211,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE212/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE212,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE213/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE213,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE214/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE214,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE215/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE215,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE216/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE216,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE217/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE217,')"/>      
		</xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://system/TCore/CCEValidationResult')/Detail/cce/CCE218/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'CCE218,')"/>      
		</xsl:if>										
		
	<!-- EndValidationCCE 1.1 -->



		<!--StartValidationINE-ECC-->
		
		<xsl:if test="count(dp:variable('var://system/TCore/ComponentValidationResult')//*[normalize-space(text()) = 'false']) &gt; 0" > <!-- Error de Ine -->
			<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
							 
                 <xsl:for-each select="document('local:///XMLs/INE.xml')/vari/eti/A">		
                 	<xsl:variable name="INEVar" select="."/>                        		
                 	<xsl:if test="contains(dp:variable('var://system/TCore/ComponentValidationResult')/Detail/ine/false/text(),$INEVar)">                  		
                 		<xsl:variable name="IneResultV" select="concat(substring($INEVar,4),',')"/>
                 		<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),$IneResultV)"/>
                 		<xsl:element name="{$INEVar}"  >                        			
                     		<xsl:value-of select="'false'" />	                					
                       	</xsl:element>	
                   	</xsl:if>			
               	</xsl:for-each>
			
			<!--xsl:if test="normalize-space(dp:variable('var://system/TCore/ComponentValidationResult')/Detail/ine/INE180/text()) = 'false'">
				<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'180,')"/>
				<xsl:call-template name="SetError">
					<xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="normalize-space(dp:variable('var://system/TCore/ComponentValidationResult')/Detail/ine/INE181/text()) = 'false'">
				<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'181,')"/>    
				<xsl:call-template name="SetError">
					<xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="normalize-space(dp:variable('var://system/TCore/ComponentValidationResult')/Detail/ine/INE182/text()) = 'false'">						
				<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'182,')"/>	
				<xsl:call-template name="SetError">
					<xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="normalize-space(dp:variable('var://system/TCore/ComponentValidationResult')/Detail/ine/INE183/text()) = 'false'">
				<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'183,')"/> 
				<xsl:call-template name="SetError">
					<xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="normalize-space(dp:variable('var://system/TCore/ComponentValidationResult')/Detail/ine/INE184/text()) = 'false'">
				<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'184,')"/>  
				<xsl:call-template name="SetError">
					<xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"/>
				</xsl:call-template>
			</xsl:if>			
			<xsl:if test="normalize-space(dp:variable('var://system/TCore/ComponentValidationResult')/Detail/ine/INE185/text()) = 'false'">
				<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'185,')"/> 
				<xsl:call-template name="SetError">
					<xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="normalize-space(dp:variable('var://system/TCore/ComponentValidationResult')/Detail/ine/INE186/text()) = 'false'">			
				<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'186,')"/> 
				<xsl:call-template name="SetError">
					<xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="normalize-space(dp:variable('var://system/TCore/ComponentValidationResult')/Detail/ine/INE187/text()) = 'false'">
				<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'187,')"/>      
			</xsl:if-->
			
			<xsl:if test="normalize-space(dp:variable('var://system/TCore/ComponentValidationResult')/Detail/ecc/ECC121/text()) = 'false'">
				<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'ECC121,')"/>      
			</xsl:if>
			<xsl:if test="normalize-space(dp:variable('var://system/TCore/ComponentValidationResult')/Detail/ecc/ECC122/text()) = 'false'">
				<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'ECC122,')"/>      
			</xsl:if>
			<xsl:if test="normalize-space(dp:variable('var://system/TCore/ComponentValidationResult')/Detail/ecc/ECC123/text()) = 'false'">
				<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'ECC123,')"/>      
			</xsl:if>
			<xsl:if test="normalize-space(dp:variable('var://system/TCore/ComponentValidationResult')/Detail/ecc/ECC124/text()) = 'false'">
				<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/Tcore/ErrorCodes'),'ECC124,')"/>      
			</xsl:if>
		</xsl:if>
		
		<!--EndValidationINE-ECC-->
		
		
     <!--ValidaFecha-->   
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ResultFechaGen/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33101,')"/>
	  </xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/fechaTimbrado = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33101,')"/>
	  </xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/fecha = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33101,')"/>
	  </xsl:if>
	
	  <!--ValidaSelloCFDI33102-->	  
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ResultCertif/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33102,')"/>
	  </xsl:if>
	  <xsl:if test="count(dp:variable('var://context/TCore/SignValidationResult')//*[normalize-space(text()) = 'false']) &gt; 0" > <!-- Error validacion del sello -->
	    <!-- <dp:set-variable name="'var://context/TCore/BugCOPoint'" value="count(dp:variable('var://context/TCore/COValidationResult'))"/> -->
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33102,')"/>
	  </xsl:if>
	  <!--TipoValidaFormaPagoComplemento-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ValidaFormaPagoComplemento/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33103,')"/>
	  </xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/formapago = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33104,')"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33104 = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33104,')"/>
		</xsl:if>
		
		<!--TipoValidanumeroCertificado-->
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/numeroCertificado = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33105,')"/>
		</xsl:if>
		
		<xsl:if test="count(dp:variable('var://context/TCore/CertValidationResult')//*[normalize-space(text()) = 'false']) &gt; 0" > <!-- Error en las validaciones del certificado -->
			<!-- No firmado por una autoridad -->
			<xsl:if test="normalize-space(dp:variable('var://context/TCore/CertValidationResult')/Detail/CertEmisor/SAT-issuer/text()) = 'false'"> 
				<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33105,')"/>
			</xsl:if>
			
			<xsl:if test="normalize-space(dp:variable('var://context/TCore/CertValidationResult')/Detail/CertEmisor/NoCert/text()) = 'false'"> 
				<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33105,')"/>
			</xsl:if>
		</xsl:if>
	  <!--ValidaSubTotal-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/SubTotal1/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33106,')"/>
	  	<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
	  </xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/subtotal = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33106,')"/>  
	  	<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
	  </xsl:if>  
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33106 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33106,')"/> 
			<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
		</xsl:if> 
	  <!--ValidaSubTotalImporte-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/subTotalImporte/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33107,')"/>
	  </xsl:if>
	  <!--ValidaSubTotalImporteTP-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/subTotalImporteTP/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33108,')"/>
	  </xsl:if>
	  <!--ValidaDescuento-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/totdescuento/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33109,')"/>
	  </xsl:if>

		<!--ValidaImpuestoTotalImpuestosTraslados-->
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/subTotalDescuento1/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33110,')"/>
		</xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/comprobante = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33110,')"/>  
	  </xsl:if>  
	  <!--se valida El valor de este atributo debe tener hasta la cantidad de decimales que soporte la moneda Descuento CFDI33111-->        
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/decimal = '0'">            
	    <xsl:if test="normalize-space(/*[local-name()='Comprobante']/@Descuento) != ''">				
	      <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/@Descuento,'^\d+(\.\d{0})$'))">                     
	        <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33111,')"/> 					
	      </xsl:if>
	    </xsl:if>               
	  </xsl:if>
	  
	  <!--se valida El valor de este atributo debe tener hasta la cantidad de decimales que soporte la moneda Descuento CFDI33111-->
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/decimal = '2'">   
	    <xsl:if test="normalize-space(/*[local-name()='Comprobante']/@Descuento) != ''">
	      <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/@Descuento,'^\d+(\.\d{2})$'))">                     
	        <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33111,')"/>					
	      </xsl:if>
	    </xsl:if>              
	  </xsl:if>
	  
	  <!--se valida El valor de este atributo debe tener hasta la cantidad de decimales que soporte la moneda Descuento CFDI33111-->
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/decimal = '3'">     
	    <xsl:if test="normalize-space(/*[local-name()='Comprobante']/@Descuento) != ''">
	      <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/@Descuento,'^\d+(\.\d{3})$'))">                     
	        <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33111,')"/>					
	      </xsl:if>
	    </xsl:if>               
	  </xsl:if>
	  
	  <!--se valida El valor de este atributo debe tener hasta la cantidad de decimales que soporte la moneda Descuento CFDI33111-->
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/decimal = '4'">       
	    <xsl:if test="normalize-space(/*[local-name()='Comprobante']/@Descuento) != ''">
	      <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/@Descuento,'^\d+(\.\d{4})$'))">                     
	        <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33111,')"/>					
	      </xsl:if>
	    </xsl:if>               
	  </xsl:if>     
	  
	  <!--ValidaTipoDescuentodecimales-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/TipoDescuentodecimales/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33111,')"/>
	  </xsl:if>
	  
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/descuento = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33111,')"/>  
	  </xsl:if> 
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33111 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33111,')"/>  
		</xsl:if> 
		
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/moneda = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33112,')"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33112 = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33112,')"/>
		</xsl:if>
	  <!--ValidaTipoCambio-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-tipocambiomx1/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33113,')"/>
	  </xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/tipoCambio = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33113,')"/>  
	  </xsl:if>  
	  
	  <!--ValidaTipoCambioMonedadiferenteMXN-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-tipocambiomd1/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33114,')"/>
	  </xsl:if>
	  
		<!--ValidaTipoCambioMonedaIgualXXXTipoCambioNull-->
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-tipocambioxxx/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33115,')"/>
		</xsl:if>
		
	  
	 
	  <!--ValidaTipoCambioPatron-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/TipoCambio11/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33116,')"/>
	  </xsl:if>
		
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/confirmacion17 = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33117,')"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33117 = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33117,')"/>
		</xsl:if>
		
	  <!--Validacomprobante-Total-18-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-Total-18/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33118,')"/>
	  </xsl:if>
	  
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/total19 = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33119,')"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33118 = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33118,')"/>
		</xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33119 = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33119,')"/>
		</xsl:if>
		
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/comprobante = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33120,')"/>
	  </xsl:if>
	  
	  <!--ValidaTipoDeComprobante-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-tipocomprobanted/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33120,')"/>
	  </xsl:if>
	  
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/metodopago = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33121,')"/>
	  </xsl:if>
	  
	  <!--ValidaMetodoPago-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-metodopagopue/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33121,')"/>
	  </xsl:if>
	  
	  <!--TipoValidacomprobante-metodopagopuePIP-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-metodopagopuePIP/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33122,')"/>
	  </xsl:if>
	  
	  <!--ValidaTipoComprobanteMetodoPago-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-tipocomprobantemetod/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33123,')"/>
	  </xsl:if>
	  
	  <!--Tipocomprobante-metodopagopuePEUPPD-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-metodopagopuePEUPPD/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33124,')"/>
	  </xsl:if>
	  
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/LugarExpedicion = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33125,')"/>  
	  </xsl:if>  
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33125 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33125,')"/>  
		</xsl:if>
		
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/confirmacion26 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33126,')"/>  
	  </xsl:if>  
	  
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33126 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33126,')"/>  
		</xsl:if> 
		
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/confirmacion27 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33127,')"/>  
	  </xsl:if> 
	  
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33127 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33127,')"/>  
		</xsl:if> 
		
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/confirmacion28 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33128,')"/>  
	  </xsl:if> 
	  
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33128 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33128,')"/>  
		</xsl:if> 
	  <!--ValidaTipoComprobanteTipoRelacion-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-tipoRelacion/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33129,')"/>
	  </xsl:if>
	  
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/regimen = 'false'">            
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33130,')"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33130 = 'false'">            
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33130,')"/>
		</xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/regimenfiscal30 = 'false'">            
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33130,')"/>
	  </xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/regimenfiscal31 = 'false'">            
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33131,')"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33131 = 'false'">            
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33131,')"/>
		</xsl:if>
		
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/rfcReceptor = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33132,')"/>             
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33132 = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33132,')"/>             
		</xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/residenciafiscal33 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33133,')"/>  
	  </xsl:if> 
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33133 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33133,')"/>  
		</xsl:if> 
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/residenciafiscal34 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33134,')"/>  
	  </xsl:if> 
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33134 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33134,')"/>  
		</xsl:if> 
	  
	  <!--ValidaTipoComprobanteResidenciaFiscal-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-ResidenciaFiscal/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33135,')"/>
	  </xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/pais = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33135,')"/>
	  </xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/residenciafiscal35 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33135,')"/>  
	  </xsl:if> 
	  
	  
	  <!--Validacomprobante-Tiporesidenciafiscal36-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-Tiporesidenciafiscal36/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33136,')"/>
	  </xsl:if>		
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/residenciafiscal36 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33136,')"/>  
	  </xsl:if> 
	  
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/residenciafiscal37 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33137,')"/>  
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33137 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33137,')"/>  
		</xsl:if>
	  <!--Validacomprobante-Tiporesidenciafiscal38-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-Tiporesidenciafiscal38/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33138,')"/>
	  </xsl:if>	
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/residenciafiscal38 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33138,')"/>  
	  </xsl:if> 
	  
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/numregidtrib = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33139,')"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33139 = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33139,')"/>
		</xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errornrtCFDI33139/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33139,')"/>
	  </xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/residenciafiscal39 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33139,')"/>  
	  </xsl:if> 
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/usocfdi40 = 'false'">      
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33140,')"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33140 = 'false'">      
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33140,')"/>
		</xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorucfdiCFDI33141/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33141,')"/>
	  </xsl:if>
	  
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/usocfdi41 = 'false'">      
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33141,')"/>
	  </xsl:if>
	  
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33141 = 'false'">      
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33141,')"/>
		</xsl:if>
		
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/claveprodserv42 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33142,')"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33142 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33142,')"/>
		</xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/claveprodserv43 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33143,')"/>
	  	<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
	  </xsl:if>
		
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33143 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33143,')"/>
			<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
		</xsl:if>
		
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/adicional = 'iedu'">
	    <xsl:if test="not(count(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Iedu']) &gt; 0)"> 
	      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33143,')"/>  
	    	<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
	    </xsl:if>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorclavCFDI33143/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33143,')"/>
	  	<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
	  </xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/adicional = 'divisas'">
	    <xsl:if test="not(count(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Divisas']) &gt; 0)">                  
	      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33143,')"/>  
	    	<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
	    </xsl:if>
	  </xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/adicional = 'aerolineas'">
	    <xsl:if test="not(count(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Aerolineas']) &gt; 0)"> 
	      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33143,')"/>  
	    	<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
	    </xsl:if>
	  </xsl:if>
	  
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/claveprodserv44 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33144,')"/>
	  	<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33144 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33144,')"/>
		</xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/iva = 'si'">
	    <xsl:if test="not((/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][1]/@Impuesto = '002') or (/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][2]/@Impuesto = '002') or (/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][3]/@Impuesto = '002') or (/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][4]/@Impuesto = '002'))">
	      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33144,')"/>  
	    </xsl:if>
	  </xsl:if>
	  
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/ieps = 'no'">
	    <xsl:if test="(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][1]/@Impuesto = '003') or (/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][2]/@Impuesto = '003') or (/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][3]/@Impuesto = '003') or (/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][4]/@Impuesto = '003')">
	      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33144,')"/>  
	    </xsl:if>
	  </xsl:if>    
	  
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/unidadclave = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33145,')"/>         
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33145 = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33145,')"/>         
		</xsl:if>
	  <!--ValidaTipoValorUnitariodecimales-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/TipoValorUnitariodecimales/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33146,')"/>
	  </xsl:if>
	  <!--ValidaTipoComprobanteResidenciaFiscal-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-TipoDeComprobanteVU/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33147,')"/>
	  </xsl:if>
	  <!--ValidaTipoValorImportedecimales-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/TipoValorImportedecimales/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33148,')"/>
	  </xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/importe = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33149,')"/>  
	  </xsl:if> 
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/importe1 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33149,')"/>  
	  </xsl:if> 
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33149 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33149,')"/>  
		</xsl:if> 
		
	  <!--ValidaTipoValorImportedecimalesDc-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/TipoValorImportedecimalesDc/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33150,')"/>
	  </xsl:if>
	  
	  <!--se valida El valor de este atributo debe tener hasta la cantidad de decimales que soporte la moneda Descuento CFDI33150-->
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/decimal = '0'">
	    <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento) != ''">
	      <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento,'^\d+(\.\d{0})$'))">                     
	        <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33150,')"/>					
	      </xsl:if>
	    </xsl:if>
	  </xsl:if>	  	  
	  
	  <!--se valida El valor de este atributo debe tener hasta la cantidad de decimales que soporte la moneda Descuento CFDI33150-->
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/decimal = '2'"> 
	    <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento) != ''">
	      <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento,'^\d+(\.\d{2})$'))">                     
	        <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33150,')"/>					
	      </xsl:if>
	    </xsl:if>
	  </xsl:if>	  	  
	  
	  <!--se valida El valor de este atributo debe tener hasta la cantidad de decimales que soporte la moneda Descuento CFDI33150-->
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/decimal = '3'">
	    <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento) != ''">
	      <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento,'^\d+(\.\d{3})$'))">                     
	        <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33150,')"/>					
	      </xsl:if>
	    </xsl:if>
	  </xsl:if>
	  	  	  
	  <!--se valida El valor de este atributo debe tener hasta la cantidad de decimales que soporte la moneda Descuento CFDI33150-->
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/decimal = '4'">
	    <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento) != ''">
	      <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento,'^\d+(\.\d{4})$'))">                     
	        <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33150,')"/>					
	      </xsl:if>
	    </xsl:if>
	  </xsl:if>
	  
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33150 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33150,')"/>
		</xsl:if>
		
	  <!--ValidaTipoComprobanteDescuentoImporte-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-DescuentoImporte/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33151,')"/>
	  </xsl:if>
	  
	  <!--ValidaTipocomprobante-IMPUESTOSRetencTras-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-IMPUESTOSRetencTras/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33152,')"/>
	  </xsl:if>
	  
	  <!--ValidaTipoValorBasecimales-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/TipoValorBasecimales/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33153,')"/>
	  </xsl:if>
	  
	  <!--ValidaBaseMayorCero-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-BaseMayorCero/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33154,')"/>
	  </xsl:if>
	  
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/claveImpuesto = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33155,')"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33155 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33155,')"/>
		</xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/tasacuotaimpuesto = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33155,')"/>  
	  </xsl:if> 
	  <!--ValidaImpuesto-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-TipoImpuesto1/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33155,')"/>
	  </xsl:if>
	  
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/tasacuotafactor = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33156,')"/>  
	  </xsl:if> 
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33156 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33156,')"/>  
		</xsl:if> 
	  <!--ValidaTipoFactorTraslado-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-TipoFactorTraslado/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33156,')"/>
	  </xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/tipofactortraslado = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33156,')"/>
	  </xsl:if>
	  	  
	  <!--ValidaTipoFactorExento-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-TipoFactorExento/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33157,')"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33157 = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33157,')"/>
		</xsl:if>
	  <!--ValidaTipoFactorTasaOCuota-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-TipoFactorTasaOCuota/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33158,')"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33158 = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33158,')"/>
		</xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/tasacuota59 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33159,')"/>  
	  </xsl:if> 
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33159 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33159,')"/>  
		</xsl:if> 
	  <!--ValidaTipoValorImportedecimales60-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/TipoValorImportedecimales60/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33160,')"/>
	  </xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/importe2 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33161,')"/>  
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33161 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33161,')"/>  
		</xsl:if>
	  <!--ValidaTipoValorBasecimalesRet-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/TipoValorBasecimalesRet/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33162,')"/>
	  </xsl:if>
	  <!--ValidaBaseRetencionesMayorCero-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-BaseRetencionesMayorCero/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33163,')"/>
	  </xsl:if>
	  
	  <!--ValidaTipoImpuestoRetencion-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-TipoImpuestoRetencion1/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33164,')"/>
	  </xsl:if>
	  <!--ValidaTipoFactorTrasladoRetencion-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-TipoFactorTrasladoRetencion/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33165,')"/>
	  </xsl:if>
	  
	  
	  <!--ValidaTipoFactorExentoRetencion-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-TipoFactorExentoRetencion/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33166,')"/>
	  </xsl:if>
	  
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/tasacuota = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33167,')"/>  
	  </xsl:if> 
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33167 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33167,')"/>  
		</xsl:if> 
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/tasacuota67 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33167,')"/>  
	  </xsl:if> 
	  <!--ValidaTipoValorImportedecimalesRet-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/TipoValorImportedecimalesRet/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33168,')"/>
	  </xsl:if>
	  
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/importe3 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33169,')"/>  
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33169 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33169,')"/>  
		</xsl:if>
		
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33170 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33170,')"/>  
		</xsl:if>
		
	  <!--Validacomprobante-TipoNumeroPedimento71-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-TipoNumeroPedimento71/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33171,')"/>
	  </xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/numeropedimento = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33171,')"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33172 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33172,')"/>  
		</xsl:if>
		
	  <!--ValidaTipoDescuentodecimalesVU-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/TipoDescuentodecimalesVU/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33173,')"/>
	  </xsl:if>
	  
	  <!--ValidaValorUnitarioConcepto-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-ValorUnitarioConcepto/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33174,')"/>
	  </xsl:if>
	  
	  <!--ValidaTipoValorImportedecimalesImp-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/TipoValorImportedecimalesImp/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33175,')"/>
	  </xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/importe4 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33176,')"/>  
	  </xsl:if> 
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33176 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33176,')"/>  
		</xsl:if> 
		
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/numeropedimentoparte = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33177,')"/>         
	  </xsl:if>  
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33177 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33177,')"/>         
		</xsl:if>
		
	  <!--Validacomprobante-TipoNumeroPedimento78-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-TipoNumeroPedimento78/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33178,')"/>
	  </xsl:if>
	  
	  <!--ValidaValorUnitarioConcepto-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-ImpuestoTipoDeComprobanteToP/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33179,')"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/comprobante-ImpuestoTipoDeComprobanteToP = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33179,')"/>  
		</xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/total_impuestos_retenidos = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33180,')"/>  
	  </xsl:if> 
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33180 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33180,')"/>  
		</xsl:if>
	  <!--TipoValorTotalImpuestosRetenidosdecimales-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/TipoValorTotalImpuestosRetenidosdecimales/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33180,')"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33181 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33181,')"/>  
		</xsl:if>
	  <!--TipoValorcomprobante-TipoImpuestoRetencion81-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-TipoImpuestoRetencion81/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33181,')"/>
	  </xsl:if>
	  <!--ValidaImpuestoTotalImpuestosRetenidos-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-ImpuestoTotalImpuestosRetenidos/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33181,')"/>
	  </xsl:if>	 	  
	  
	  <!--TipoValorTotalImpuestosTrasladadosdecimales-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/TipoValorTotalImpuestosTrasladadosdecimales/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33182,')"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33182 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33182,')"/>  
		</xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/total_impuestos_trasladados = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33182,')"/>  
	  </xsl:if>
	  <!--TipoValorcomprobante-TipoImpuestoRetencion83-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-TipoImpuestoRetencion83/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33183,')"/>
	  </xsl:if>
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33183 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33183,')"/>  
		</xsl:if>
	  <!--Validacomprobante-ImpuestoTipoDeComprobanteTRt-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-ImpuestoTipoDeComprobanteTRt/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33184,')"/>
	  </xsl:if>
	  
	  <!--Tipocomprobante-TipoImpuestoRetencion12-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-TipoImpuestoRetencion12/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33185,')"/>
	  </xsl:if>
		<!--Validacomprobante-ImpuestoTotalImpRet-->
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-ImpuestoTotalImpRet/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33186,')"/>
		</xsl:if>
		
	  <!--Tipocomprobante-ImpuestoTras87-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-ImpuestoTras87/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33187,')"/>
	  </xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/importe5 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33187,')"/>  
	  </xsl:if> 
	  <!--Tipocomprobante-TipoImpuestoRetencion88-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-TipoImpuestoRetencion88/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33188,')"/>
	  </xsl:if>
		<!--Validacomprobante-TipoImpuestoRetencion89-->
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-TipoImpuestoRetencion89/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33189,')"/>
		</xsl:if>
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/importe6 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33189,')"/>  
	  </xsl:if> 
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33189 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33189,')"/>  
		</xsl:if> 
	  <!--Validacomprobante-ImpuestoTipoDeComprobanteTtras-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-ImpuestoTipoDeComprobanteTtras/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33190,')"/>
	  </xsl:if>
	  <!--Tipo comprobante-ImpuestoTotalImpuestosTrasladosNT-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-ImpuestoTotalImpuestosTrasladosNT/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33190,')"/>
	  </xsl:if>
		
	  <!--Tipocomprobante-TipoImpuestoRetencion91-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-TipoImpuestoRetencion91/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33191,')"/>
	  </xsl:if>
		
	  <!--Tipocomprobante-ImpuestoTipoDeComprobanteTtras92-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-ImpuestoTipoDeComprobanteTtras92/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33192,')"/>
	  </xsl:if>
	 
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/tasacuota93 = 'false'"> 
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33193,')"/>  
	  </xsl:if> 
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33193 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33193,')"/>  
		</xsl:if> 
	  <!--Tipocomprobante-TipoImpuestoRetencion94-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-TipoImpuestoRetencion94/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33194,')"/>
	  </xsl:if>
		
	  <!--Validacomprobante-Impuestos-Traslado-Cuota95-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/comprobante-Impuestos-Traslado-Cuota95/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33195,')"/>
	  </xsl:if> 
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI33195 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33195,')"/>  
		</xsl:if> 
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/tipoAccion = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33196,')"/>
	  </xsl:if> 
	  
	  <xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/codigopostal = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33196,')"/>         
	  </xsl:if>
      <xsl:if test="normalize-space(dp:variable('var://context/TCore/MetodoDePagoResult')) = 'false'"> <!-- No cumple con el catalogo MetdoDePago -->
	      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'309,')"/>
	    </xsl:if>			
		
    <!--Errores de validacion ApiGateway-->
	  
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorha301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorrf402/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'402,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorfeNOMI101/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'NOM101,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errornup301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errornupa301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/erroruuid301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>	  
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorunid301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorcodp301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	 
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorform301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errormetop301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errormnd142/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'142,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorpais301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	 
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errortftrl301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorcpbNOM110/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'NOM110,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorptn301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorrgmNOM119/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'NOM119,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorrlc301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	 
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorrfcRcNOM121/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'NOM121,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorfctCFDI33101/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33101,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errormnt301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorxml301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorrqst301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorsre301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorfol301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorcmp301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorcdg301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errortmp301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errortpa301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <!--valida el NoCertificado en la DB-->
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errornc301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorclNOM103/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'NOM103,')"/>
	  </xsl:if>
	  <xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errorcon301/text()) = 'false'">
	    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
	  </xsl:if>
		<xsl:if test="normalize-space(dp:variable('var://context/TCore/RESTauthResultDEBUG')/Detail/errornc301/text()) = 'false'">
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
		</xsl:if>
		
    <!-- ************************************************************************************************************************ -->

		<xsl:if test="dp:variable('var://context/TCore/TimbreGenerationResult')/node() and not(dp:variable('var://context/TCore/TimbreGenerationResult')/*[local-name()='Detail']/*[local-name()='Timbre']/node())" >  <!-- Error de Timbre -->
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'C501,')"/>
		</xsl:if>

		<xsl:if test="dp:variable('var://context/TCore/SelloGenerationResult')/node() and not(dp:variable('var://context/TCore/SelloGenerationResult')/*[local-name()='Detail']/*[local-name()='cfdisellado']/node())" >  <!-- Error de Sello -->
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'817,')"/>
		</xsl:if>	 
		<!--Errores Externos StartAPI-WebServer-Complementos-->
		<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/codigo500 = 'false'"> 
			<dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'500,')"/>  
		</xsl:if> 
		<!--Errores Externos EndAPI-WebServer-Complementos-->
		
		
    <xsl:choose> 
      <xsl:when test="dp:variable('var://context/TCore/ErrorCodes') != ''"> <!-- Errores -->
          <xsl:call-template name="SetError">
            <xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"></xsl:with-param>
            <xsl:with-param name="XSDExceptions" select="dp:variable('var://context/TCore/XSDExceptions')"></xsl:with-param>
          </xsl:call-template>
      </xsl:when>
      <xsl:otherwise> <!-- Continuar -->
        <xsl:copy-of select="/" />
      </xsl:otherwise>
    </xsl:choose>
	  
	  <xsl:choose>
	    <xsl:when test="$VariAPIGeneral/resultadoDatapowerXml/EXITO = 'true'">	      
	        <xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'Continuando XMLServices-True'"></xsl:with-param></xsl:call-template>	      
	    </xsl:when>
	    <xsl:otherwise>	     
	        <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33196,')"/>	      	      
	    </xsl:otherwise>
	  </xsl:choose>
	  
		<!-- code verifica errores-->
		<xsl:choose>
      <xsl:when test="dp:variable('var://context/INPUT/_extension/error') != ''">        
        <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33196,')"/>
        <xsl:call-template name="SetError">
          <xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"/>
        </xsl:call-template>
        
      </xsl:when>
      <xsl:otherwise>
        
      </xsl:otherwise>
    </xsl:choose>
				
	</xsl:template>

</xsl:stylesheet>