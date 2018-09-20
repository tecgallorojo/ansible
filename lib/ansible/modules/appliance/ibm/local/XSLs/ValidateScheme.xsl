<?xml version="1.0" encoding="UTF-8"?> 

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dp="http://www.datapower.com/extensions" extension-element-prefixes="xsl dp" exclude-result-prefixes="xsl dp">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" dp:escaping="minimum" />

	<xsl:import href="local:///XSLs/Commons/Utils33.xsl"/>

	<xsl:template match="/">
		<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Entrando a ValidateScheme --'"></xsl:with-param></xsl:call-template>
		<xsl:variable name="CleanCFDi">
			<xsl:call-template name="doCleanCFDi" />
		</xsl:variable>

		<!-- Directorio de la version -->
		<xsl:variable name="DVersion" select="string(translate(/*[local-name()='Comprobante']/@Version, '.', '_'))" />

		<!-- Ruta a los recursos del SAT local:///XSDs/SAT/-->
		<xsl:variable name="PathSATXSD">
			<xsl:call-template name="getPropertyValue">
				<xsl:with-param name="name" select="'PATH-SAT-XSD'"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- Ruta a los recursos del SAT local:///XSDs/SAT/Complements/-->
		<xsl:variable name="RootPathSATXSDComplements">
			<xsl:call-template name="getPropertyValue">
				<xsl:with-param name="name" select="'PATH-SAT-XSD-COMPLEMENT'"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<!-- Ruta a los recursos del SAT LIMPIA LAS PROPIEDADES ClearProperty.xsl http://LOOPBACK:9559/-->
		<!--http://LOOPBACK:8556-->
		<!--xsl:variable name="XSDServiceDetail" select="'http://LOOPBACK:8556'"/-->
		<xsl:variable name="XSDServiceDetail" select="'http://LOOPBACK:9562'"/>
		<!--xsl:variable name="XSDServiceDetail">
			<xsl:call-template name="getPropertyValue">
				<xsl:with-param name="name" select="'XSD-SERVICE-DETAIL'"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable-->
		
		<!--local:///XSDs/SAT/Complements/3_3/-->
		<xsl:variable name="PathSATXSDComplements">
			<xsl:value-of select="concat($RootPathSATXSDComplements,$DVersion,'/')" />
		</xsl:variable>
		
	

		<xsl:variable name="CFDiValidation">
			<Detail>
				<CFDi>
					<xsl:choose>
						<!--concatena(local:///XSDs/SAT/cfdv3_3.xsd), valida l concatenación con CFDI enviado por el cliente-->
						<xsl:when test="count(dp:schema-validate(concat($PathSATXSD,'cfdv',$DVersion,'.xsd'),$CleanCFDi)) &gt; 0"> <!-- Si pasa la validación de XSD, revisamos algunos detalles adicionales -->
							<xsd><xsl:value-of select="'true'"/></xsd>
							
							
							<RFCReceptor> <!-- validar RFC del receptor -->
								<xsl:call-template name="ValidRFC">
									<xsl:with-param name="value" select="/*[local-name()='Comprobante']/*[local-name()='Receptor']/@Rfc" />
								</xsl:call-template>
							</RFCReceptor>
							
							<RFCEmisor> <!-- validar RFC del emisor -->
								<xsl:call-template name="ValidRFC">
									<xsl:with-param name="value" select="/*[local-name()='Comprobante']/*[local-name()='Emisor']/@Rfc" />
								</xsl:call-template>
							</RFCEmisor>
							
							<Conceptos> <!-- Conceptos -->
								<xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*">
									<xsl:element name="Concepto" >
										<xsl:attribute name="name">
											<xsl:value-of select="@Descripcion"/>
										</xsl:attribute>
										
										<!-- Validar Complemento Conceptos -->
										<xsl:for-each select="./*[local-name()='ComplementoConcepto']/*">
											<xsl:element name="ComplementoConcepto" >
												
												<xsl:attribute name="type">
													<xsl:value-of select="local-name()"/>
												</xsl:attribute>
												<!--Busca los URI de complementoConcepto y después de la ruta riginal del SAT obtengo el valor-->
												<dp:set-variable name="'var://context/TCore/IdComplementConcept'" value="normalize-space(translate(substring-after(namespace-uri(.),'http://www.sat.gob.mx/'), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))"/>
												
												<xsl:choose>
													<!--local:///XSDs/SAT/Complements/3_3/cc_terceros.xsd-->
													<xsl:when test="count(dp:schema-validate(concat($PathSATXSDComplements,'cc_',dp:variable('var://context/TCore/IdComplementConcept'),'.xsd'),.)) &gt; 0" > <!-- si es posible validar con la información del atributo "schemaLocation" -->
														<xsd><xsl:value-of select="'true'"/></xsd>
														
													</xsl:when>
													<xsl:otherwise>
														<xsd><xsl:value-of select="'false'"/></xsd>
														<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
														
														<xsl:variable name="XSD-VALIDATION-DETAIL">
															<dp:url-open target="{$XSDServiceDetail}" response="xml" data-type="xml">
																<validate>
																	<xsd><xsl:value-of select="concat($PathSATXSDComplements,'cc_',dp:variable('var://context/TCore/IdComplementConcept'),'.xsd')"/></xsd>
																	<nodeset><xsl:copy-of select="."/></nodeset>
																</validate>
															</dp:url-open>
														</xsl:variable>
														
														<detail><xsl:value-of select="$XSD-VALIDATION-DETAIL"/></detail>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:element>
											
										</xsl:for-each>
										
									</xsl:element>
								</xsl:for-each>
							</Conceptos>
							
							<Impuestos> <!-- Validar Impuestos -->
								<xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Impuestos']/*/*">
									<xsl:element name="Opercion" >
										<xsl:attribute name="type">
											<xsl:value-of select="local-name()"/>
										</xsl:attribute>
									</xsl:element>
								</xsl:for-each>
							</Impuestos>
							
						</xsl:when>
						<xsl:otherwise> <!-- No paso la validacion de esquema -->
							<xsd><xsl:value-of select="'false'"/></xsd>
							<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
							
							<xsl:variable name="XSD-VALIDATION-DETAIL">
								<!--http://LOOPBACK:9559/-->
								<dp:url-open target="{$XSDServiceDetail}" response="xml" data-type="xml">				
									<validate>
										<xsd><xsl:value-of select="concat($PathSATXSD,'cfdv',$DVersion,'.xsd')"/></xsd>
										<nodeset><xsl:copy-of select="$CleanCFDi"/></nodeset>
									</validate>
								</dp:url-open>
							</xsl:variable>
							
							<detail><xsl:value-of select="$XSD-VALIDATION-DETAIL"/></detail>
							
						</xsl:otherwise>
					</xsl:choose>
					
					<Complementos> <!-- Valida complemento -->
						<xsl:for-each select="/*[local-name() = 'Comprobante']/*[local-name() = 'Complemento']/*[local-name() != 'TimbreFiscalDigital']">
							<xsl:element name="Complemento" >
								<xsl:attribute name="type">
									<xsl:value-of select="local-name()"/>
								</xsl:attribute>
								
								<dp:set-variable name="'var://context/TCore/IdComplement'" value="normalize-space(translate(substring-after(namespace-uri(.),'http://www.sat.gob.mx/'), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))"/>
								
								<xsl:choose>
									<xsl:when test="dp:variable('var://context/TCore/IdComplement') = 'donat' and @version = '1.1'" >
										<xsl:choose>
											<xsl:when test="count(dp:schema-validate(concat($PathSATXSDComplements,dp:variable('var://context/TCore/IdComplement'),'11.xsd'),.)) &gt; 0" >
												<xsd><xsl:value-of select="'true'"/></xsd>
												
											</xsl:when>
											<xsl:otherwise>
												<xsd><xsl:value-of select="'false'"/></xsd>
												<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
												
												<xsl:variable name="XSD-VALIDATION-DETAIL">							
													<dp:url-open target="{$XSDServiceDetail}" response="xml" data-type="xml">												
														<validate>
															<xsd><xsl:value-of select="concat($PathSATXSDComplements,dp:variable('var://context/TCore/IdComplement'),'11.xsd')"/></xsd>
															<nodeset><xsl:copy-of select="."/></nodeset>
														</validate>
													</dp:url-open>
												</xsl:variable>
												
												<detail><xsl:value-of select="$XSD-VALIDATION-DETAIL"/></detail>
												
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="count(dp:schema-validate(concat($PathSATXSDComplements,dp:variable('var://context/TCore/IdComplement'),'.xsd'),.)) &gt; 0" >
												<xsd><xsl:value-of select="'true'"/></xsd>
												
											</xsl:when>
											<xsl:otherwise>
												<xsd><xsl:value-of select="'false'"/></xsd>
												<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
												
												<xsl:variable name="XSD-VALIDATION-DETAIL">
													<!--http://LOOPBACK:9559/-->													
													<dp:url-open target="{$XSDServiceDetail}" response="xml" data-type="xml">											
														<validate>
															<xsd><xsl:value-of select="concat($PathSATXSDComplements,dp:variable('var://context/TCore/IdComplement'),'.xsd')"/></xsd>
															<nodeset><xsl:copy-of select="."/></nodeset>
														</validate>
													</dp:url-open>
												</xsl:variable>
												
												<detail><xsl:value-of select="$XSD-VALIDATION-DETAIL"/></detail>
												
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
								
							</xsl:element>
						</xsl:for-each>
					</Complementos>
					
				</CFDi>
			</Detail>
		</xsl:variable>

		<!-- almacenamos el resultado de la validacion -->
		<dp:set-variable name="'var://context/TCore/CFDiSchemeResult'" value="$CFDiValidation"/>
		
		<!--NewValidationValidateSchemeNegocio-->		
		
		<xsl:variable name="VariAPIGeneral" select="dp:variable('var://system/TCore/RESTauthResultDEBUG1')"/>
		   	     
		
		<xsl:variable name="VariAPIGenURL">  
			<Detail>
				
				<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/idUsuario = 'false'"> 					
					<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>										
				</xsl:if>
				
				<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/user = 'false'"> 					
					<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
				</xsl:if>
				
				<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/pass = 'false'"> 					
					<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
				</xsl:if>
				<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/timbres = 'false'"> 					
					<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
				</xsl:if>
				<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/hashCFDI = 'false'"> 					
					<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
				</xsl:if>												
				
				<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI401 = 'false'"> 					
					<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
				</xsl:if> 
				<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/CFDI402 = 'false'"> 
					<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
				</xsl:if>     
				<!--TipoValidanumeroCertificado-->
				<xsl:if test="$VariAPIGeneral/resultadoDatapowerXml/numeroCertificado = 'false'">
					<dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
				</xsl:if>
				
				
			</Detail>
		</xsl:variable>
	
		
		<!--EndValidationValidateSchemeNegocio-->
		
		
		
		
		
		
		<xsl:call-template name="logMessage"><xsl:with-param name="msg" select="'-- Saliendo de ValidateScheme --'"></xsl:with-param></xsl:call-template>
	</xsl:template>

	<!-- Pass all data -->
	<xsl:template name="doCleanCFDi" match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- Elimina el nodo Addenda -->
	<xsl:template name="ProcessAddenda" match="//*[local-name() = 'Addenda']">
		<!-- Clear -->
	</xsl:template>

	<!-- Elimina el nodo Complemento -->
	<xsl:template name="ProcessComplement" match="//*[local-name() = 'Complemento']">
	</xsl:template>
	

	<!-- Elimina el nodo Complemento Concepto 	-->
	<xsl:template name="ProcessComplementConcept" match="//*[local-name() = 'ComplementoConcepto']">
	</xsl:template>


	<!-- Elimina el timbre si viene -->
	<xsl:template name="ProcessTimbreFiscalDigital" match="//*[local-name() = 'TimbreFiscalDigital']">
		<!-- Clean-->
	</xsl:template>

</xsl:stylesheet>