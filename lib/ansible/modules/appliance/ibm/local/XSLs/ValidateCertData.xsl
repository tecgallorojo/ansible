<?xml version="1.0" encoding="UTF-8"?> 

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" 
	xmlns:str="http://exslt.org/strings" xmlns:date="http://exslt.org/dates-and-times"  xmlns:func="http://exslt.org/functions" xmlns:regexp="http://exslt.org/regular-expressions" 
	extension-element-prefixes="dp str func date" exclude-result-prefixes="regexp dp func date">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" dp:escaping="minimum" />

	<xsl:import href="local:///XSLs/Commons/Utils33.xsl"/>

	<xsl:template match="/">
		<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Entrando a ValidatCertData --'"></xsl:with-param></xsl:call-template>
		<!-- Issuers almacenados en un Validation Credential que es IssuersCe rtificates  -->
		<xsl:variable name="IssuersCertificates">
			<xsl:call-template name="getPropertyValue">
				<xsl:with-param name="name" select="'ISSUERS-VALIDATION-CREDENTIAL'"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<!--  Certificado emisor en BASE64  -->
		<xsl:variable name="CertificadoEmisor" select="concat('cert:',/*[local-name()='Comprobante']/@Certificado)" />
		
		<xsl:variable name="NoCertificadoEmisor" select="/*[local-name()='Comprobante']/@NoCertificado" />
		
		<xsl:variable name="Cert2Validate">
			<input>
				<subject><xsl:value-of select="$CertificadoEmisor" /></subject>
			</input>
		</xsl:variable>

		<xsl:variable name="CertValidation">

			<Detail>

				<!-- Validaciones certificado emisor -->
				<xsl:variable name="CertificateDetails">
					<xsl:copy-of select="dp:get-cert-details($CertificadoEmisor)" />
				</xsl:variable>
				<dp:set-variable name="'var://context/TCore/CertificateDetailsEnd'" value="$CertificateDetails"/>
				
				
				<CertEmisor>

					<xsl:choose>
						<xsl:when test="normalize-space($CertificateDetails/Error) = ''" > <!-- Si no tenemos errores al cargar el certificado  -->
							<Open><xsl:value-of select="'true'"/></Open>
						</xsl:when>
						<xsl:otherwise>
							<Open><xsl:value-of select="'false'"/></Open>
							<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
							<Open-result><xsl:value-of select="normalize-space($CertificateDetails/Error)" /></Open-result>
						</xsl:otherwise>
					</xsl:choose>

					<!-- Validar si el certificado fue firmado por unos de los issuers conocidos -->
					<xsl:variable name="VCertIssuer" select="dp:validate-certificate($Cert2Validate,$IssuersCertificates)" />

					<xsl:choose>
						<xsl:when test="string($VCertIssuer) = ''"> 
							<SAT-issuer><xsl:value-of select="'true'"/></SAT-issuer>
						</xsl:when>
						<xsl:otherwise> <!-- Certificado no puede ser validado -->
							<SAT-issuer><xsl:value-of select="'false'"/></SAT-issuer>
							<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
							<SAT-issuer-result><xsl:value-of select="$VCertIssuer"/></SAT-issuer-result>
						</xsl:otherwise>
					</xsl:choose>
                                        <!-- Verificar qie no sea FIEL -->
                                        <xsl:if test="$CertificateDetails/*[local-name()='CertificateDetails']/*[local-name()='Extensions']/*[@name='extendedKeyUsage']/item[text()='TLS Web Client Authentication']">
                                                <NotFiel><xsl:value-of select="'false'"/></NotFiel>
                                        		<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
                                         </xsl:if>
					
					

					<xsl:variable name="certInfo">
						<CertInfo>
							<SerialNumber><xsl:value-of select="$CertificateDetails/*[local-name()='CertificateDetails']/*[local-name()='SerialNumber']"/></SerialNumber>
							<beginDate><xsl:value-of select="$CertificateDetails/*[local-name()='CertificateDetails']/*[local-name()='NotBefore']"/></beginDate>
							<endDate><xsl:value-of select="$CertificateDetails/*[local-name()='CertificateDetails']/*[local-name()='NotAfter']"/></endDate>
							<subject><xsl:value-of select="$CertificateDetails/*[local-name()='CertificateDetails']/*[local-name()='Subject']"/></subject>
							<issuer><xsl:value-of select="$CertificateDetails/*[local-name()='CertificateDetails']/*[local-name()='Issuer']"/></issuer>
							
						</CertInfo>
					</xsl:variable>
					<!--se obtiene el RfcPACEmisor del Certificado-->
					<xsl:variable name="CertificateDetailsissuer" select="$certInfo/CertInfo/issuer"/>	
					<xsl:variable name="CertificateDetailsRfcIssuer" select="substring-before(substring-after($certInfo/CertInfo/issuer,'x500UniqueIdentifier='),',')"/>	
					<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'CertificateDetailsRfcIssuer'"></xsl:with-param></xsl:call-template>
					<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$CertificateDetailsRfcIssuer"></xsl:with-param></xsl:call-template>
					
					
					<!--se obtiene el SerialNumber-->
					<xsl:variable name="CertificateDetailSN" select="$certInfo/CertInfo/SerialNumber"/>	
					<xsl:variable name="CertificateDetailNoCert">
						<xsl:value-of select="regexp:replace(dp:radix-convert($CertificateDetailSN,10,16),'3([0-9])','g','$1')" />						
					</xsl:variable>
					<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'NoCertificadoCfdi'"></xsl:with-param></xsl:call-template>
					<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="$CertificateDetailNoCert"></xsl:with-param></xsl:call-template>
					
					<xsl:choose>
						<xsl:when test="$NoCertificadoEmisor = $CertificateDetailNoCert" > <!-- Si no tenemos errores en el NoCertificado  -->
							<NoCert><xsl:value-of select="'true'"/></NoCert>
						</xsl:when>
						<xsl:otherwise>
							<NoCert><xsl:value-of select="'false'"/></NoCert>	
							<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
						</xsl:otherwise>
					</xsl:choose>
					
					<!-- Validaciones del certificado -->
					<xsl:call-template name="validateInfoCert">
						<xsl:with-param name="certInfo" select="$certInfo"/>
					</xsl:call-template>

					<!-- copio detalles 
					<xsl:copy-of select="$certInfo" /> -->

				</CertEmisor>
			</Detail>
		</xsl:variable>

		<!-- almacenamos el resultado de la validacion -->
		<dp:set-variable name="'var://context/TCore/CertValidationResult'" value="$CertValidation"/>
	
		
		
		<xsl:if test="count(dp:variable('var://context/TCore/CertValidationResult')//*[normalize-space(text()) = 'false']) &gt; 0" > <!-- Error en las validaciones del certificado -->         		
			
			<xsl:if test="normalize-space(dp:variable('var://context/TCore/CertValidationResult')/Detail/CertEmisor/Emision/RFCIntegrity/text()) = 'false'"> <!-- RFC del emisor no coindice con el RFC del certificado -->
				<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
			</xsl:if>
			
			<xsl:if test="normalize-space(dp:variable('var://context/TCore/CertValidationResult')/Detail/CertEmisor/Emision/InRange/text()) = 'false'"> <!-- RFC del emisor no coindice con el RFC del certificado -->
				<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
			</xsl:if>
			
			<xsl:if test="normalize-space(dp:variable('var://context/TCore/CertValidationResult')/Detail/CertEmisor/Open/text()) = 'false'"> <!-- Certificado revocado o cad -->
				<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
			</xsl:if>
			
			<xsl:if test="normalize-space(dp:variable('var://context/TCore/CertValidationResult')/Detail/CertEmisor/NotFiel/text()) = 'false'"> <!-- El error de la FIEL -->
				<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
			</xsl:if>
			<!-- No firmado por una autoridad -->
			<xsl:if test="normalize-space(dp:variable('var://context/TCore/CertValidationResult')/Detail/CertEmisor/SAT-issuer/text()) = 'false'"> 
				<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
			</xsl:if>
			
			<xsl:if test="normalize-space(dp:variable('var://context/TCore/CertValidationResult')/Detail/CertEmisor/NoCert/text()) = 'false'"> 
				<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
			</xsl:if>
		</xsl:if>
	
		<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Saliendo de ValidateCertData --'"></xsl:with-param></xsl:call-template>
	</xsl:template>

	<!-- Valida la información del certificado -->
	<xsl:template name="validateInfoCert">
		<xsl:param name="certInfo"/>

		<xsl:variable name="Now">
			<xsl:call-template name="createDateTime" />
		</xsl:variable>

		<xsl:variable name="dateEmisionInRange">
			<xsl:call-template name="isDateInRange">
				<!-- se cambio a mayusculas fecha @Fecha-->
				<xsl:with-param name="testDate" select="/*[local-name()='Comprobante']/@Fecha"/>
				<xsl:with-param name="initDate" select="$certInfo/CertInfo/beginDate"/>
				<xsl:with-param name="endDate" select="$certInfo/CertInfo/endDate"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="dateActive">
			<xsl:call-template name="isDateInRange">
				<xsl:with-param name="testDate" select="$Now"/>
				<xsl:with-param name="initDate" select="$certInfo/CertInfo/beginDate"/>
				<xsl:with-param name="endDate" select="$certInfo/CertInfo/endDate"/>
			</xsl:call-template>
		</xsl:variable>

		<Activo>
			<xsl:choose> <!-- La fecha de emisión esta fuera del rango de fechas del certificado -->
				<xsl:when test="$dateActive = 'N'" >
					<xsl:value-of select="'false'"/>
					<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'true'"/>
				</xsl:otherwise>
			</xsl:choose>
		</Activo>

		<Emision>
			<xsl:choose> <!-- La fecha de emisión esta fuera del rango de fechas del certificado -->
				<xsl:when test="$dateEmisionInRange = 'N'" >
					<InRange><xsl:value-of select="'false'"/></InRange>
					<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
				</xsl:when>
				<xsl:otherwise>
					<InRange><xsl:value-of select="'true'"/></InRange>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:choose> 
				<!-- El RFC del emisor no coindice con el RFC del certificado -->
				<xsl:when test="dp:index-of($certInfo/CertInfo/subject, /*[local-name()='Comprobante']/*[local-name()='Emisor']/@Rfc) = 0" >
					<RFCIntegrity><xsl:value-of select="'false'"/></RFCIntegrity>
					<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>					
				</xsl:when>
				<xsl:otherwise>
					<RFCIntegrity><xsl:value-of select="'true'"/></RFCIntegrity>					
				</xsl:otherwise>
			</xsl:choose>

		</Emision>

	</xsl:template>

</xsl:stylesheet>