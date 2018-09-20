<?xml version="1.0" encoding="UTF-8"?> 
	
	<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" 
		xmlns:date="http://exslt.org/dates-and-times"
		xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
		xmlns:str="http://exslt.org/strings"
		xmlns:regexp="http://exslt.org/regular-expressions"
		extension-element-prefixes="dp xsl str">

		<xsl:template name="getPropertyValue">
			<xsl:param name="name"/>
			<xsl:param name="type"/>
			<xsl:if test="string(dp:variable('var://system/TCore/properties33'))=''">
					<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'Inicializando Properties'"></xsl:with-param></xsl:call-template>
					<xsl:variable name="propertiesFile33" select="document('local:///XMLs/Properties33.xml')"/>
					<dp:set-variable name="'var://system/TCore/properties33'" value="$propertiesFile33"/>
			</xsl:if>

			<xsl:variable name="value">
				<xsl:copy-of select="dp:variable('var://system/TCore/properties33')/properties/property[name=$name]/value"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$value=''">
					<xsl:value-of select="'Undefined Name/Value'" />	
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$type='node'">
							<xsl:copy-of select="$value/*[local-name()='value']/*" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$value/*[local-name()='value']" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:template>

		<xsl:template name="logMessage">
			<xsl:param name="msg"></xsl:param>
			<xsl:param name="level"></xsl:param>			
			<xsl:message terminate="no" dp:type="mgmt" dp:priority="notice">
				<xsl:value-of select="dp:time-value()"/>-<xsl:value-of select="$msg"/>
			</xsl:message>
		</xsl:template>
		
		<xsl:template name="getNameAddenda">
			<xsl:param name="nsAddendaXSD"/>
			<xsl:variable name="tokens" select="str:tokenize($nsAddendaXSD,'/')"/>
			<dp:set-local-variable name="found" value="'false'"/>
			<xsl:variable name="result">
				<xsl:for-each select="$tokens">
					<xsl:if test="(.)='XSD' or dp:local-variable($found)='true'">
						<xsl:value-of select="concat('/',.)"/>
						<dp:set-local-variable name="found" value="'true'"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:copy-of select="$result"/>
		</xsl:template>

		<xsl:template name="SetError">
			<xsl:param name="errorCodes" />
			<xsl:param name="XSDExceptions" />

      <xsl:variable name="ErrorLog" select="'Error en el procesamiento'" />

      <xsl:variable name="ErrorResult">
        <xsl:element name="Errores">

          <xsl:for-each select="str:tokenize($errorCodes,',')">
            <xsl:if test="string(.) != ''" >
              <dp:set-local-variable name="'EC'" value="normalize-space(.)" /> 

              <xsl:element name="Error">
                  <xsl:attribute name="code">
                    <xsl:value-of select="dp:local-variable('EC')" /> <!-- Codigo de error  -->
		  </xsl:attribute>
                  <xsl:value-of select="document('local:///XMLs/ErrorCodes.xml')/properties/property[name = dp:local-variable('EC')]/value" />
                  
              </xsl:element>
            </xsl:if>

          </xsl:for-each>

        </xsl:element>
      </xsl:variable>

  		<dp:set-variable name="'var://context/TCore/ErrorResult'" value="$ErrorResult" />

				<dp:reject><xsl:value-of select="$ErrorLog" /></dp:reject>
        <xsl:message terminate="yes"><xsl:value-of select="$errorCodes" /></xsl:message>

		</xsl:template>

		<xsl:template name="createDateTime">
			<xsl:value-of select="concat(date:year(),'-',format-number(date:month-in-year(),'00'),'-',format-number(date:day-in-month(),'00'),'T',format-number(date:hour-in-day(),'00'),':',format-number(date:minute-in-hour(),'00'),':',format-number(date:second-in-minute(),'00'))"/>
			<!-- <xsl:value-of select="'2010-09-20T18:02:51'"/> -->
		</xsl:template>

		<xsl:template name="requestInitTime">
			<xsl:param name="service"/>
			<dp:set-variable name="concat('var://context/TCore/',$service,'/initTimeRequest')" value="dp:time-value()"/>
		</xsl:template>
		
		<xsl:template name="requestEndTime">
			<xsl:param name="service"/>
			<xsl:variable name="initTime" select="dp:variable(concat('var://context/TCore/',$service,'/initTimeRequest'))"/>
			<dp:append-response-header name="concat($service,'-Time-Response')" value="(dp:time-value() - number($initTime))"/>	
		</xsl:template>
  
  		<!-- Template para determinar el Path de un certificado para no tenerlos todos en una sola carpeta -->		
	  	<xsl:template name="getPathForCerts">
	 		<xsl:param name="objName"/>
	 		<xsl:param name="validate"/>
	 		<xsl:variable name="rootCertPath">
	 			<xsl:call-template name="getPropertyValue">
					<xsl:with-param name="name" select="'root-certs-directory'"></xsl:with-param>
				</xsl:call-template>
	 		</xsl:variable>
	 		<xsl:variable name="rootKeyPath" select="'cert:///'"></xsl:variable>
	 		<xsl:variable name="certDir" select="substring($objName,(string-length($objName)-2))"></xsl:variable>
	 		
	 		<xsl:choose>
	 			<xsl:when test="$validate = 'true' and (string(number($certDir)) = 'NaN' or (string-length(normalize-space($certDir))) &lt; 3 or not(dp:index-of($certDir,'-') = 0) )">
	 				<Error><xsl:value-of select="concat(' El nombre del certificado debe de terminar con tres dígitos ',$objName)"/></Error>
	 			</xsl:when>
	 			<xsl:otherwise>
	 				<Paths>
			 			<Cert><xsl:value-of select="concat('local://',$rootCertPath,'/',$certDir,'/')"/></Cert>
			 			<Key><xsl:value-of select="$rootKeyPath"/></Key>
			 		</Paths>
	 			</xsl:otherwise>
	 		</xsl:choose>
	 	</xsl:template>

		<xsl:template name="validAttribsOfNode">
	    	<xsl:param name="tmpNode"/>
	    	<xsl:param name="excludeAtts"/>
			<xsl:for-each select="$tmpNode/@*">
    			<xsl:if test="$excludeAtts='' or dp:index-of($excludeAtts,concat(normalize-space(name()),'|'))=0">
		    		<xsl:if test="not(dp:index-of(normalize-space(.),'|')=0)">
						<xsl:call-template name="SetError">
							<xsl:with-param name="errorCode" select="'BZ.166'"></xsl:with-param>
						</xsl:call-template>
		    		</xsl:if>
    			</xsl:if>
	    	</xsl:for-each>
	   	</xsl:template>

	  	<xsl:template name="createRespCadenaComplemento">
	  		<xsl:param name="cadena"/>
	  		<CadenaComplemento><xsl:value-of select="normalize-space($cadena)"/></CadenaComplemento>
	  	</xsl:template>

		<xsl:template name="isCryptographicError">
			<xsl:param name="cadena"></xsl:param>
			<xsl:variable name="cadenaTrim" select="normalize-space($cadena)"/>
			<xsl:choose>
				<xsl:when test="$cadenaTrim=''">
					<xsl:value-of select="'Y'" />
				</xsl:when>
				<xsl:when test="starts-with($cadenaTrim,'*') and ends-with($cadenaTrim,'*')">
					<xsl:value-of select="'Y'" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'N'" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:template>

		<!-- Utilerias del SAT -->
		<xsl:template name="Requerido">
			<xsl:param name="valor"/>|<xsl:call-template name="ManejaEspacios">
				<xsl:with-param name="s" select="$valor"/>
			</xsl:call-template>
		</xsl:template>
	
		<!-- Manejador de datos opcionales -->
		<xsl:template name="Opcional">
			<xsl:param name="valor"/>
			<xsl:if test="$valor">|<xsl:call-template name="ManejaEspacios"><xsl:with-param name="s" select="$valor"/></xsl:call-template></xsl:if>
		</xsl:template>
		
		<!-- Normalizador de espacios en blanco -->
		<xsl:template name="ManejaEspacios">
			<xsl:param name="s"/>
			<xsl:value-of select="normalize-space(string($s))"/>
		</xsl:template>

		<xsl:template name="IDUnico"> 
			<xsl:variable name="ident" select="dp:variable('var://service/system/ident')/identification/serial-number/text()"/> 
			<xsl:variable name="uuid" select="dp:generate-uuid()"/>
			<xsl:value-of select="concat($ident,'_',$uuid)"/>
		</xsl:template>

<!-- Template para validar si una fecha este dentro de otro rango de fechas regresa Y si esta en rango y N si no lo esta-->
	<xsl:template name="isDateInRange">
		<xsl:param name="testDate"/>
		<xsl:param name="initDate"/>
		<xsl:param name="endDate"/>
		<xsl:variable name="initDif" select="date:seconds(date:difference($initDate,$testDate))"/><!-- Si el resultado es menor 0 es una fecha menor -->
		<xsl:variable name="endDif" select="date:seconds(date:difference($endDate,$testDate))"/><!-- Si el resultado es mayor 0 es una fecha mayor -->
		<xsl:choose>
			<xsl:when test="$initDif &lt; 0">N</xsl:when>
			<xsl:when test="$endDif > 0">N</xsl:when>
			<xsl:otherwise>Y</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	

		<xsl:template name="ValidRFC"> 
			<xsl:param name="value"/>
				<xsl:value-of select="regexp:test(normalize-space($value),'[A-Z,Ñ,&amp;]{3,4}[0-9]{2}[0-1][0-9][0-3][0-9][A-Z,0-9]?[A-Z,0-9]?[0-9,A-Z]?')" />	
		</xsl:template>

</xsl:stylesheet>