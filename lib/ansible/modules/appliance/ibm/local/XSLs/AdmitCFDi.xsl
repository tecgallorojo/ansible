<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dp="http://www.datapower.com/extensions" 
  xmlns:regexp="http://exslt.org/regular-expressions"
  xmlns:date="http://exslt.org/dates-and-times" extension-element-prefixes="dp date" 
  exclude-result-prefixes="xs dp xsl date">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" dp:escaping="minimum"/>
  <xsl:import href="local:///XSLs/Commons/Utils33.xsl"/>
  
  <xsl:template match="/">    
       
    <xsl:variable name="Now">
		<!-- llama al template createDateTime definido en Utils.xsl -->
      <xsl:call-template name="createDateTime"/>
    </xsl:variable>
  
    <!--Start New Code-->
    <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="''"/>
    
    <xsl:choose>
      <!--<xsl:when test="substring-before(substring-after(dp:variable('var://system/TCore/RESTauthResultDEBUG1'),'fa'),'se') != ''">-->
      <xsl:when test="contains(dp:variable('var://system/TCore/RESTauthResultDEBUG1'),'false')">
        <dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>        
      </xsl:when>     
    </xsl:choose>
    <!--StartNegocio-->   
    <xsl:if test="dp:variable('var://system/TCore/RESTauthResultDEBUG1')/resultadoDatapowerXml/CFDI301 = 'false'"> 
      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/>
      <dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>	          
      <xsl:call-template name="SetError">
        <xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"/>
      </xsl:call-template>
    </xsl:if>               
    
    <xsl:if test="dp:variable('var://system/TCore/RESTauthResultDEBUG1')/resultadoDatapowerXml/CFDI401 = 'false'">   
      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'401,')"/>      
      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'CFDI33101,')"/>       
    </xsl:if> 
    <xsl:if test="dp:variable('var://system/TCore/RESTauthResultDEBUG1')/resultadoDatapowerXml/CFDI402 = 'false'">     
      <dp:set-variable name="'var://context/TCore/ErrorNegoc'" value="'402'"/>
    </xsl:if>     
    
    
    <!--StartValidarXML-->
    <xsl:if test="not(normalize-space(/*[local-name()='Comprobante']/@Certificado) != '')">			
      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/> 
      <dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>
      <dp:set-variable name="'var://context/TCore/ErrorNegoc'" value="'301'"/>
      <!--<xsl:call-template name="SetError">
            <xsl:with-param name="errorCodes" select="dp:variable('var://context/TCore/ErrorCodes')"/>
          </xsl:call-template>-->
    </xsl:if>
    <xsl:if test="normalize-space(/*[local-name()='Comprobante']/@Version) != '3.3'">			
      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/> 
      <dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>	
      <dp:set-variable name="'var://context/TCore/ErrorNegoc'" value="'301'"/>
    </xsl:if>
    <xsl:if test="not(normalize-space(/*[local-name()='Comprobante']/@Fecha) != '')">		
      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/> 
      <dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>	
      <dp:set-variable name="'var://context/TCore/ErrorNegoc'" value="'301'"/>
    </xsl:if>
    <xsl:if test="not(normalize-space(/*[local-name()='Comprobante']/@Sello) != '')">			
      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/> 
      <dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>	
      <dp:set-variable name="'var://context/TCore/ErrorNegoc'" value="'301'"/>
    </xsl:if>
    <xsl:if test="not(normalize-space(/*[local-name()='Comprobante']/@NoCertificado) != '')">			
      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/> 
      <dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>		
      <dp:set-variable name="'var://context/TCore/ErrorNegoc'" value="'301'"/>
    </xsl:if>
    <xsl:if test="not(normalize-space(/*[local-name()='Comprobante']/@SubTotal) != '')">			
      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/> 
      <dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>		
      <dp:set-variable name="'var://context/TCore/ErrorNegoc'" value="'301'"/>
    </xsl:if>
    <xsl:if test="not(normalize-space(/*[local-name()='Comprobante']/@Moneda) != '')">			
      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/> 
      <dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>		
      <dp:set-variable name="'var://context/TCore/ErrorNegoc'" value="'301'"/>
    </xsl:if>
    <xsl:if test="not(normalize-space(/*[local-name()='Comprobante']/@Total) != '')">			
      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/> 
      <dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>			
      <dp:set-variable name="'var://context/TCore/ErrorNegoc'" value="'301'"/>
    </xsl:if>
    <xsl:if test="not(normalize-space(/*[local-name()='Comprobante']/@TipoDeComprobante) != '')">			
      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/> 
      <dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>	
      <dp:set-variable name="'var://context/TCore/ErrorNegoc'" value="'301'"/>
    </xsl:if>
    <xsl:if test="not(normalize-space(/*[local-name()='Comprobante']/@LugarExpedicion) != '')">			
      <dp:set-variable name="'var://context/TCore/ErrorCodes'" value="concat(dp:variable('var://context/TCore/ErrorCodes'),'301,')"/> 
      <dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>			
      <dp:set-variable name="'var://context/TCore/ErrorNegoc'" value="'301'"/>
    </xsl:if>
    <!--EndValidarXML-->
    
    
    <!--EndNegocio-->
    
    
    
    
    <xsl:variable name="CFDiDate" select="normalize-space(/*[name()='cfdi:Comprobante']/@Fecha)"/>
    
    <!--CFDI33101-->
    <xsl:variable name="ResultGenrGen">  
      <Detail>                                
        
        <!--Validacion Fecha 101-->
        <xsl:if test="not(regexp:test(normalize-space(/*[local-name() = 'Comprobante']/@Fecha),'(20[1-9][0-9])-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])T(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9])'))">
          <ResultFechaGen><xsl:value-of select="'false'" /></ResultFechaGen>          
        </xsl:if>
        <!--ValidaCFDI33102 Si hay error no guarda en la DB-->
        <xsl:if test="count(dp:variable('var://context/TCore/SignValidationResult')//*[normalize-space(text()) = 'false']) &gt; 0" >
          <ResultCertif><xsl:value-of select="'false'" /></ResultCertif>
          <dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>         
        </xsl:if>

        <!--Error 403-->        
          <xsl:if test="substring-before(/*[local-name() = 'Comprobante']/@Fecha,'-') &lt; 2012">
            <FechaXml><xsl:value-of select="'false'" /></FechaXml>          
          </xsl:if>	      
                

        <!--CFDI33106-->
        <xsl:variable name="TVMoneda" select="/*[local-name() = 'Comprobante']" />
        <xsl:if test="($TVMoneda/@Moneda) = 'MXN'">
          <xsl:choose>           
            <xsl:when test="substring-after(/*[local-name() = 'Comprobante']/@SubTotal,'.') != ''">
              <xsl:if test="substring(substring-after(/*[local-name() = 'Comprobante']/@SubTotal,'.'),3,1)">					
                <SubTotal1><xsl:value-of select="'false'" /></SubTotal1> 
              </xsl:if>	       
            </xsl:when>
          </xsl:choose>	
          <xsl:choose>           
            <xsl:when test="((substring-before(/*[local-name() = 'Comprobante']/@SubTotal,'.') != '') and (substring-after(/*[local-name() = 'Comprobante']/@SubTotal,'.') = ''))">						
              <SubTotal1><xsl:value-of select="'false'" /></SubTotal1> 						       
            </xsl:when>		
          </xsl:choose>		
        </xsl:if>
            
        <!-- Comprobante.ValidaFormaPago-CFDI33103 -->
        <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FechaPago) != ''">
          <xsl:if test="normalize-space(/*[local-name()='Comprobante']/@FormaPago) != ''">
            <ValidaFormaPagoComplemento><xsl:value-of select="'false'" /></ValidaFormaPagoComplemento>           
          </xsl:if>
        </xsl:if>
        
        <!--ValidaSubTotalImporteCFDI33107-->
        <xsl:if test="((/*[local-name() = 'Comprobante']/@TipoDeComprobante = 'I') or (/*[local-name() = 'Comprobante']/@TipoDeComprobante = 'E') or (/*[local-name() = 'Comprobante']/@TipoDeComprobante = 'N'))">
          <xsl:variable name="SUBTOTALImp" select="format-number(sum(/*[local-name() = 'Comprobante']/@SubTotal), '##################.00')" />
          <xsl:variable name="SUMIMPORTE" select="format-number(sum(/*[local-name() = 'Comprobante']/*[local-name() = 'Conceptos']/*[local-name() = 'Concepto']/@Importe), '##################.00')" />			
          <xsl:if test="$SUBTOTALImp != $SUMIMPORTE">            
            <subTotalImporte><xsl:value-of select="'false'" /></subTotalImporte>            
          </xsl:if>
        </xsl:if>    
        <!--ValidaCFDI33174-->
        <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Parte']/@ValorUnitario) != ''">
          <xsl:if test="not(number(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Parte']/@ValorUnitario) &gt; 0)">
            <comprobante-ValorUnitarioConcepto><xsl:value-of select="'false'" /></comprobante-ValorUnitarioConcepto>            
          </xsl:if>                        
        </xsl:if>       
       
        <!--ValidaDescuentoImporteCFDI33110BuenaVALIDADAPIGATEWAY-->           
        <xsl:if test="((/*[local-name() = 'Comprobante']/@TipoDeComprobante = 'I') or (/*[local-name() = 'Comprobante']/@TipoDeComprobante = 'E') or (/*[local-name() = 'Comprobante']/@TipoDeComprobante = 'N'))">          
          <xsl:variable name="DescuentoV10">
            <xsl:choose>
              <xsl:when test="normalize-space(/*[local-name() = 'Comprobante']/@Descuento) != ''">
                <DescuentoV10>
                  <xsl:value-of select="format-number(sum(/*[local-name() = 'Comprobante']/@Descuento), '######.00')"/>									
                </DescuentoV10>
              </xsl:when>
              <xsl:otherwise>
                <DescuentoV10>
                  <xsl:value-of select="'null'"/>
                </DescuentoV10>						
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable> 
          <xsl:variable name="Descuento10">
            <xsl:choose>
              <xsl:when test="normalize-space(/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento) != ''">
                <Descuento10>								
                  <xsl:value-of select="format-number(sum(/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento), '######.00')"/>
                </Descuento10>
              </xsl:when>
              <xsl:otherwise>
                <Descuento10>
                  <xsl:value-of select="'null'"/>
                </Descuento10>							
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable> 
          <xsl:value-of select="$DescuentoV10"/>
          <xsl:value-of select="$Descuento10"/>
          <xsl:if test="$DescuentoV10 != $Descuento10">
            <subTotalDescuento1>
              <xsl:value-of select="'false'"/>                 
            </subTotalDescuento1>                
          </xsl:if>
        </xsl:if>                 
        
        
        
        <!--ValidaSubTotalImporteToP CFDI33108-->
        <xsl:if test="(/*[local-name() = 'Comprobante']/@TipoDeComprobante = 'T' or (/*[local-name() = 'Comprobante']/@TipoDeComprobante = 'P' ))">
          <xsl:variable name="SUBTOTALImp" select="/*[local-name() = 'Comprobante']" />
          <xsl:if test="$SUBTOTALImp/@SubTotal &gt; 0">
            <subTotalImporteTP>
              <xsl:value-of select="'false'" />              
            </subTotalImporteTP>            
          </xsl:if>
          
        </xsl:if>      

        <!--ValidaDescuentoCFDI33109-->
        <xsl:if test="($TVMoneda/@Descuento) != ''">
        <!--xsl:if test="not(($SUBTOTALImp/@SubTotal) = '')"-->
          <!--xsl:if test="$SUBTOTALImp/@SubTotal != ''"-->
          <xsl:if test="not(($TVMoneda/@Descuento) &lt;= ($TVMoneda/@SubTotal))">                             
              <totdescuento><xsl:value-of select="'false'" /></totdescuento>            
            </xsl:if>
          <!--/xsl:if-->
        </xsl:if>
        
        <!--ValidaTipoCambioCFDI33113bien-->
        <xsl:if test="((/*[local-name() = 'Comprobante']/@Moneda ='MXN') and (/*[local-name() = 'Comprobante']/@TipoCambio != '1'))">
            <comprobante-tipocambiomx1>
              <xsl:value-of select="'false'"/>              
            </comprobante-tipocambiomx1>          
          
        </xsl:if>
     
        <!--se valida la existencia de Tipo Cambio para moneda diferente a la MXNCFDI33114bien-->
        <xsl:if test="((/*[local-name() = 'Comprobante']/@Moneda !='MXN') and (/*[local-name() = 'Comprobante']/@Moneda !='XXX'))">
          <xsl:if test="not(/*[local-name() = 'Comprobante']/@TipoCambio)">
            <comprobante-tipocambiomd1>
              <xsl:value-of select="'false'"/>              
            </comprobante-tipocambiomd1>            
          </xsl:if>
        </xsl:if>
        
        <!--se valida la existencia de Tipo Cambio null para moneda diferente igual XXXCFDI33115bien-->
        <xsl:if test="(/*[local-name() = 'Comprobante']/@Moneda ='XXX')">
          <xsl:if test="normalize-space(/*[local-name()='Comprobante']/@TipoCambio) != ''">
            <comprobante-tipocambioxxx>
              <xsl:value-of select="'false'"/>              
            </comprobante-tipocambioxxx>            
          </xsl:if>
        </xsl:if>      
        
        <!--se valida MetodoPagoPIPCFDI33122-->
        <xsl:if test="(/*[local-name() = 'Comprobante']/@MetodoPago ='PIP')">
          <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FechaPago) = ''">
            <comprobante-metodopagopuePIP>
              <xsl:value-of select="'false'"/>             
            </comprobante-metodopagopuePIP>            
          </xsl:if>
        </xsl:if>  
      
        <!--Evalua si tiene decimales-->
        <xsl:variable name="tipocambiotot">         
          <xsl:choose>           
            <xsl:when test="substring-after(/*[local-name() = 'Comprobante']/@TipoCambio,'.') != ''">
              <!--Para validar si tiene más de 7 decimales-->	
              <xsl:if test="substring(substring-after(/*[local-name() = 'Comprobante']/@TipoCambio,'.'),7,1)">					
                <tipocambiotot>                  
                  <xsl:value-of select="'0'"/> 						
                </tipocambiotot>
              </xsl:if>	                         
            </xsl:when>
            <xsl:otherwise>
              <tipocambiotot>                  
                <xsl:value-of select="'1'"/>                  
              </tipocambiotot>                
            </xsl:otherwise>           
          </xsl:choose>               
        </xsl:variable>     
        
        <xsl:if test="$tipocambiotot = '0'">
              <!-- Comprobante.TipoCambio.match([0-9]{1,18}(.[0-9]{1,6})?) = falseCFDI33116 -->
              <xsl:if test="((/*[local-name() = 'Comprobante']/@Moneda ='MXN') and (/*[local-name() = 'Comprobante']/@TipoCambio != '1'))">
                <xsl:variable name="VTipoCamb" select="/*[local-name() = 'Comprobante']" />
                <!--xsl:if test="not(regexp:test($VTipoCamb/@TipoCambio,'[0-9]{1,18}(.[0-9]{1,6})?'))"-->
                  <xsl:if test="not(regexp:test($VTipoCamb/@TipoCambio,'^\d+(\.\d{6})$'))">
                    <TipoCambio11><xsl:value-of select="'false'" /></TipoCambio11>             
                  </xsl:if>
              </xsl:if>
                                                        
              <!-- Comprobante.TipoCambio.match([0-9]{1,18}(.[0-9]{1,6})?) = falseCFDI33116MONEDAUSA -->
              <xsl:if test="((/*[local-name() = 'Comprobante']/@Moneda ='USD') and (/*[local-name() = 'Comprobante']/@TipoCambio != ''))">
                <xsl:variable name="VTipoCamb1" select="/*[local-name() = 'Comprobante']" />
                <!--xsl:if test="not(regexp:test($VTipoCamb1/@TipoCambio,'[0-9]{1,18}(.[0-9]{1,6})?'))"-->
                <xsl:if test="not(regexp:test($VTipoCamb1/@TipoCambio,'^\d+(\.\d{6})$'))">
                  <TipoCambio11><xsl:value-of select="'false'" /></TipoCambio11>           
                </xsl:if>
              </xsl:if>
        </xsl:if>    
        
        
        <!-- Comprobante.TipoCambio.match([0-9]{1,18}(.[0-9]{1,6})?) = falseCFDI33116 -->
        <xsl:if test="(/*[local-name() = 'Comprobante']/@TipoCambio != '')">
          <xsl:if test="not(regexp:test(/*[local-name() = 'Comprobante']/@TipoCambio,'[0-9]{1,18}(.[0-9]{1,6})?'))">      
              <TipoCambio11><xsl:value-of select="'false'" /></TipoCambio11>             
          </xsl:if>
        </xsl:if>
        <xsl:if test="(/*[local-name() = 'Comprobante']/@TipoCambio &lt; 0)">               
            <TipoCambio11><xsl:value-of select="'false'" /></TipoCambio11>                       
        </xsl:if>
        
        <!--CFDI33111-->
        <xsl:variable name="TVMoneda" select="/*[local-name() = 'Comprobante']" />
        <xsl:if test="($TVMoneda/@Moneda) = 'MXN'">
          <xsl:choose>           
            <xsl:when test="substring-after(/*[local-name() = 'Comprobante']/@Descuento,'.') != ''">
              <xsl:if test="substring(substring-after(/*[local-name() = 'Comprobante']/@Descuento,'.'),3,1)">					
                <TipoDescuentodecimales><xsl:value-of select="'false'" /></TipoDescuentodecimales> 
              </xsl:if>	 					
            </xsl:when>		
          </xsl:choose>	
          <xsl:choose>           
            <xsl:when test="((substring-before(/*[local-name() = 'Comprobante']/@Descuento,'.') != '') and (substring-after(/*[local-name() = 'Comprobante']/@Descuento,'.') = ''))">						
              <TipoDescuentodecimales><xsl:value-of select="'false'" /></TipoDescuentodecimales> 						       
            </xsl:when>		
          </xsl:choose>		
        </xsl:if>
            
        <!-- Validacion18v2FuncionaCFDI33118 -->
        <xsl:if test="normalize-space(/*[local-name() = 'Comprobante']/@Total != '')">
          <xsl:if test="normalize-space(/*[local-name() = 'Comprobante']/@SubTotal != '')">
            <xsl:variable name="Descuento18">
              <xsl:choose>
                <xsl:when test="normalize-space(/*[local-name() = 'Comprobante']/@Descuento) != ''">
                  <Descuento18>
                    <xsl:value-of select="format-number(sum(/*[local-name() = 'Comprobante']/@Descuento), '######.00')"/>								
                  </Descuento18>
                </xsl:when>
                <xsl:otherwise>
                  <Descuento18>
                    <xsl:value-of select="format-number((0.00), '0.00')"/>
                  </Descuento18>           
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ImporteT18">
              <xsl:choose>
                <xsl:when test="normalize-space(/*[local-name() = 'Comprobante']/*[local-name() = 'Impuestos']/@TotalImpuestosTrasladados) != ''">
                  <ImporteT18>
                    <xsl:value-of select="format-number(sum(/*[local-name() = 'Comprobante']/*[local-name() = 'Impuestos']/@TotalImpuestosTrasladados), '######.00')"/>
                  </ImporteT18>
                </xsl:when>
                <xsl:otherwise>
                  <ImporteT18>
                    <xsl:value-of select="format-number((0.00), '0.00')"/>
                  </ImporteT18>           
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ImporteR18">
              <xsl:choose>
                <xsl:when test="normalize-space(/*[local-name() = 'Comprobante']/*[local-name() = 'Impuestos']/@TotalImpuestosRetenidos) != ''">
                  <ImporteR18>
                    <xsl:value-of select="format-number(sum(/*[local-name() = 'Comprobante']/*[local-name() = 'Impuestos']/@TotalImpuestosRetenidos), '######.00')"/>
                  </ImporteR18>
                </xsl:when>
                <xsl:otherwise>
                  <ImporteR18>
                    <xsl:value-of select="format-number((0.00), '0.00')"/>
                  </ImporteR18>           
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="ImporteRL18">
              <xsl:choose>
                <xsl:when test="normalize-space(/*[local-name() = 'Comprobante']/*[local-name() = 'Complemento']/*[local-name() = 'ImpuestosLocales']/@TotaldeRetenciones) != ''">
                  <ImporteRL18>
                    <xsl:value-of select="format-number(sum(/*[local-name() = 'Comprobante']/*[local-name() = 'Complemento']/*[local-name() = 'ImpuestosLocales']/@TotaldeRetenciones), '######.00')"/>
                  </ImporteRL18>
                </xsl:when>
                <xsl:otherwise>
                  <ImporteRL18>
                    <xsl:value-of select="format-number((0.00), '0.00')"/>
                  </ImporteRL18>           
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ImporteTL18">
              <xsl:choose>
                <xsl:when test="normalize-space(/*[local-name() = 'Comprobante']/*[local-name() = 'Complemento']/*[local-name() = 'ImpuestosLocales']/@TotaldeTraslados) != ''">
                  <ImporteTL18>
                    <xsl:value-of select="format-number(sum(/*[local-name() = 'Comprobante']/*[local-name() = 'Complemento']/*[local-name() = 'ImpuestosLocales']/@TotaldeTraslados), '######.00')"/>
                  </ImporteTL18>
                </xsl:when>
                <xsl:otherwise>
                  <ImporteTL18>
                    <xsl:value-of select="format-number((0.00), '0.00')"/>
                  </ImporteTL18>           
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="Total18">
              <xsl:value-of select="format-number((/*[local-name() = 'Comprobante']/@Total ), '######.00')"/>
            </xsl:variable>
            <xsl:variable name="SubTotal8">
              <xsl:value-of select="format-number((/*[local-name() = 'Comprobante']/@SubTotal ), '######.00')"/>
            </xsl:variable>
            
            
            
            <xsl:if test="($Total18 != format-number(($SubTotal8 - $Descuento18) + ($ImporteT18 - $ImporteR18)+($ImporteTL18 - $ImporteRL18), '######.00'))">
              <comprobante-Total-18>
                <xsl:value-of select="'false'"/>                
              </comprobante-Total-18>                 
            </xsl:if>	
          </xsl:if>
          
        </xsl:if>
        
      <!--se valida TipoDeComprobante CFDI33120-->
        <xsl:variable name="TComprobt" select="/*[local-name() = 'Comprobante']" /> 
        <xsl:if test="not(($TComprobt/@TipoDeComprobante) = 'I' or ($TComprobt/@TipoDeComprobante) = 'E' or ($TComprobt/@TipoDeComprobante) = 'T' or ($TComprobt/@TipoDeComprobante) = 'N' or ($TComprobt/@TipoDeComprobante) = 'P')">
          
            <comprobante-tipocomprobanted>
              <xsl:value-of select="'false'"/>              
            </comprobante-tipocomprobanted>          
          </xsl:if>  
        
      <!--se valida MetodoPagoCFDI33121-->
        <xsl:if test="normalize-space(/*[local-name()='Comprobante']/@MetodoPago) != ''">
          <xsl:if test="not(($TComprobt/@MetodoPago) = 'PUE' or ($TComprobt/@MetodoPago) = 'PIP' or ($TComprobt/@MetodoPago) = 'PPD')">
            <comprobante-metodopagopue>
              <xsl:value-of select="'false'"/>              
            </comprobante-metodopagopue>            
          </xsl:if> 
        </xsl:if>
        
       
        <!--se valida MetodoPagoPUE-PPD-->
        <xsl:if test="(/*[local-name() = 'Comprobante']/@MetodoPago ='PUE' or (/*[local-name() = 'Comprobante']/@MetodoPago ='PPD'))">
          <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FechaPago) != ''">
            <comprobante-metodopagopuePEUPPD>
              <xsl:value-of select="'false'"/>              
            </comprobante-metodopagopuePEUPPD>            
          </xsl:if>
        </xsl:if>  
        
      <!--se valida TipoDeComprobanteToP CFDI33123-->
      <xsl:if test="((/*[local-name() = 'Comprobante']/@TipoDeComprobante ='T') or (/*[local-name() = 'Comprobante']/@TipoDeComprobante ='P'))">
        <xsl:if test="normalize-space(/*[local-name()='Comprobante']/@MetodoPago) != ''">
          <comprobante-tipocomprobantemetod>
            <xsl:value-of select="'false'"/>            
          </comprobante-tipocomprobantemetod>          
        </xsl:if>
      </xsl:if>  
     
        <!--se valida TipoRelacionCFDI33129BIEN-->
        <!--xsl:if test="(/*[local-name() = 'Comprobante']/*[local-name()='CfdiRelacionados']/@TipoRelacion !='01') and (/*[local-name() = 'Comprobante']/*[local-name()='CfdiRelacionados']/@TipoRelacion !='02') and (/*[local-name() = 'Comprobante']/*[local-name()='CfdiRelacionados']/@TipoRelacion !='03') and (/*[local-name() = 'Comprobante']/*[local-name()='CfdiRelacionados']/@TipoRelacion !='04') and (/*[local-name() = 'Comprobante']/*[local-name()='CfdiRelacionados']/@TipoRelacion !='05') and (/*[local-name() = 'Comprobante']/*[local-name()='CfdiRelacionados']/@TipoRelacion !='06')"-->
        <xsl:if test="((/*[local-name() = 'Comprobante']/*[local-name()='CfdiRelacionados']/@TipoRelacion !='01') and (/*[local-name() = 'Comprobante']/*[local-name()='CfdiRelacionados']/@TipoRelacion !='02') and (/*[local-name() = 'Comprobante']/*[local-name()='CfdiRelacionados']/@TipoRelacion !='03') and (/*[local-name() = 'Comprobante']/*[local-name()='CfdiRelacionados']/@TipoRelacion !='04') and (/*[local-name() = 'Comprobante']/*[local-name()='CfdiRelacionados']/@TipoRelacion !='05') and (/*[local-name() = 'Comprobante']/*[local-name()='CfdiRelacionados']/@TipoRelacion !='06'))">          
          <comprobante-tipoRelacion>
            <xsl:value-of select="'false'"/>          
          </comprobante-tipoRelacion>        
        </xsl:if>
      
      
        
      <!--se valida ResidenciaFiscalCFDI33135-->
        <xsl:variable name="TVResideFisc" select="/*[local-name() = 'Comprobante']/*[local-name()='Receptor']" /> 
        <xsl:if test="normalize-space($TVResideFisc/@ResidenciaFiscal) = 'MEX'">
          <comprobante-ResidenciaFiscal>
            <xsl:value-of select="'false'"/>            
          </comprobante-ResidenciaFiscal>          
        </xsl:if>    
        
        <!--CFDI33136-->
        <xsl:variable name="RfcRecp" select="/*[local-name() = 'Comprobante']/*[local-name()='Receptor']" /> 
        <xsl:if test="normalize-space($RfcRecp/@Rfc) = 'XEXX010101000'"> 
          <xsl:variable name="VTNumeroCCE36" select="/*[local-name() = 'Comprobante']/*[local-name()='Complemento']/*[local-name()='ComercioExterior']" /> 
          <xsl:if test="(count($VTNumeroCCE36) &gt; 0 or normalize-space(/*[local-name() = 'Comprobante']/*[local-name()='Receptor']/@NumRegIdTrib) != '')">
            <xsl:if test="normalize-space(/*[local-name() = 'Comprobante']/*[local-name()='Receptor']/@ResidenciaFiscal) = ''">
              <comprobante-Tiporesidenciafiscal36><xsl:value-of select="'false'"/></comprobante-Tiporesidenciafiscal36>  
            </xsl:if>
          </xsl:if>
        </xsl:if>
        
        <!--CFDI33138-->
        <xsl:variable name="RfcRecp1" select="/*[local-name() = 'Comprobante']/*[local-name()='Receptor']" /> 
        <xsl:if test="normalize-space($RfcRecp1/@Rfc) = 'XEXX010101000'"> 
          <xsl:variable name="VTNumeroCCE38" select="/*[local-name() = 'Comprobante']/*[local-name()='Complemento']/*[local-name()='ComercioExterior']" /> 
          <xsl:if test="count($VTNumeroCCE38) &gt; 0">
            <xsl:if test="normalize-space(/*[local-name() = 'Comprobante']/*[local-name()='Receptor']/@NumRegIdTrib) = ''">
              <comprobante-Tiporesidenciafiscal38><xsl:value-of select="'false'"/></comprobante-Tiporesidenciafiscal38>  
            </xsl:if>
          </xsl:if>
        </xsl:if>
        <!--se valida TipoDeComprobanteVU-CFDI33147-->
        <xsl:variable name="TComprobt12" select="/*[local-name() = 'Comprobante']" /> 
        <xsl:if test="($TComprobt12/@TipoDeComprobante) = 'I' or ($TComprobt12/@TipoDeComprobante) = 'E' or ($TComprobt12/@TipoDeComprobante) = 'N'">       
          <xsl:if test="not(number($TComprobt12/*[local-name()='Conceptos']/*[local-name()='Concepto']/@ValorUnitario) &gt; 0)">            
          <comprobante-TipoDeComprobanteVU>
            <xsl:value-of select="'false'"/>            
          </comprobante-TipoDeComprobanteVU>            
        </xsl:if>
      </xsl:if>  
        
        
        <!--se valida DescuentoImporteCFDI33151-->        
        <xsl:variable name="VTImpuestosDesc" select="/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']" />
        <xsl:if test="$VTImpuestosDesc/@Importe != ''">
          <xsl:if test="$VTImpuestosDesc/@Descuento != ''">
            <xsl:if test="not(($VTImpuestosDesc/@Descuento) &lt;= ($VTImpuestosDesc/@Importe))">
              <comprobante-DescuentoImporte>
                <xsl:value-of select="'false'"/>                
              </comprobante-DescuentoImporte>              
            </xsl:if>
          </xsl:if>
        </xsl:if>
        
            
        
        <!--se valida ImpuestosCFDI33152Modificada-->   
        <xsl:if test="count(/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']) &gt; 0">
          <xsl:if test="((normalize-space(/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@Impuesto) = '') and (normalize-space(/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion']/@Impuesto) = ''))">
            <comprobante-IMPUESTOSRetencTras>
              <xsl:value-of select="'false'"/>                
            </comprobante-IMPUESTOSRetencTras>    
          </xsl:if>          
        </xsl:if>
        
      <!--se valida BaseMayorCeroCFDI33154-->   
        <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@Base) != ''">
          <xsl:if test="number(normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@Base) &lt;= 0)">
           <comprobante-BaseMayorCero>
             <xsl:value-of select="'false'"/>             
            </comprobante-BaseMayorCero>            
          </xsl:if>
        </xsl:if>
        
        <!--se valida ImpuestoCFDI33155VALIDADOPORAPI-BIEN-->
        <xsl:variable name="VTImpuestos" select="/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']" />
        <xsl:if test="normalize-space($VTImpuestos/@Impuesto) != ''">
          <xsl:if test="normalize-space($VTImpuestos/@Impuesto) != '001'">        
            <xsl:if test="normalize-space($VTImpuestos/@Impuesto) != '002'">           
              <xsl:if test="normalize-space($VTImpuestos/@Impuesto) != '003'">             
                <comprobante-TipoImpuesto1>
                  <xsl:value-of select="'false'"/>                  
                </comprobante-TipoImpuesto1>                
              </xsl:if>
            </xsl:if>
          </xsl:if>
        </xsl:if>

        <!--se valida TipoFactorTrasladoCFDI33156VALIDADOPORAPI-->
        <xsl:if test="normalize-space($VTImpuestos/@TipoFactor) != ''">
        <xsl:if test="normalize-space($VTImpuestos/@TipoFactor) != 'Tasa'">
          <xsl:if test="normalize-space($VTImpuestos/@TipoFactor) != 'Cuota'">
            <xsl:if test="normalize-space($VTImpuestos/@TipoFactor) != 'Exento'">
                <comprobante-TipoFactorTraslado>
                  <xsl:value-of select="'false'"/>                  
                </comprobante-TipoFactorTraslado>              
              </xsl:if>
            </xsl:if>
          </xsl:if>
        </xsl:if>
        
        <!--se valida TipoFactorExentoCFDI33157-->
        <xsl:variable name="VTImpuestos" select="/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']" />
        <xsl:for-each select="$VTImpuestos/@Impuesto[. != '']">	
          <xsl:variable name="postionP" select="position()"/> 
          <xsl:value-of select="$postionP"/>
          <xsl:for-each select="$VTImpuestos[$postionP]/@TipoFactor[. = 'Exento']">
            <xsl:if test="(($VTImpuestos[$postionP]/@TasaOCuota != '') or ($VTImpuestos[$postionP]/@Importe != ''))">				
              <comprobante-TipoFactorExento>
                <xsl:value-of select="'false'"/>                
              </comprobante-TipoFactorExento>              				
            </xsl:if>
          </xsl:for-each>			
        </xsl:for-each>
      
      
        <!--se valida TipoFactorTasaOCuotaCFDI33158-->
        <xsl:variable name="VTImpuestos" select="/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']" />
        <xsl:for-each select="$VTImpuestos/@Impuesto[. != '']">	
          <xsl:variable name="postionP" select="position()"/> 
          <xsl:value-of select="$postionP"/>
          <xsl:for-each select="$VTImpuestos[$postionP]/@TipoFactor[. = 'Tasa'] ">
            <xsl:if test="((not($VTImpuestos[$postionP]/@TasaOCuota) != '') or (not($VTImpuestos[$postionP]/@Importe) != ''))">				
              <comprobante-TipoFactorTasaOCuota>
                <xsl:value-of select="'false'"/>                
              </comprobante-TipoFactorTasaOCuota>              				
            </xsl:if>
          </xsl:for-each>		
          <xsl:for-each select="$VTImpuestos[$postionP]/@TipoFactor[. = 'Cuota'] ">
            <xsl:if test="((not($VTImpuestos[$postionP]/@TasaOCuota) != '') or (not($VTImpuestos[$postionP]/@Importe) != ''))">				
              <comprobante-TipoFactorTasaOCuota>
                <xsl:value-of select="'false'"/>                
              </comprobante-TipoFactorTasaOCuota>              				
            </xsl:if>
          </xsl:for-each>		
        </xsl:for-each>
      
      <!--se valida BaseRetencionesMayorCeroCFDI33163-->     
        <xsl:variable name="VTBaseRetenc" select="/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion'][1]" />
        <xsl:variable name="VTBaseRetenc1" select="/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion'][2]" />
        <xsl:variable name="VTBaseRetencTra" select="/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][1]" />
        <xsl:variable name="VTBaseRetencTra1" select="/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][2]" />
        <xsl:if test="number(normalize-space($VTBaseRetenc/@Base) &lt;= 0)">
          <comprobante-BaseRetencionesMayorCero>
            <xsl:value-of select="'false'"/>            
          </comprobante-BaseRetencionesMayorCero>          
        </xsl:if>
        <xsl:if test="number(normalize-space($VTBaseRetenc1/@Base) &lt;= 0)">
          <comprobante-BaseRetencionesMayorCero>
            <xsl:value-of select="'false'"/>            
          </comprobante-BaseRetencionesMayorCero>          
        </xsl:if>
        <xsl:if test="number(normalize-space($VTBaseRetencTra/@Base) &lt;= 0)">
          <comprobante-BaseRetencionesMayorCero>
            <xsl:value-of select="'false'"/>            
          </comprobante-BaseRetencionesMayorCero>          
        </xsl:if>
        <xsl:if test="number(normalize-space($VTBaseRetencTra1/@Base) &lt;= 0)">
          <comprobante-BaseRetencionesMayorCero>
            <xsl:value-of select="'false'"/>            
          </comprobante-BaseRetencionesMayorCero>          
        </xsl:if>
        
      <!--se valida ImpuestoRetencionCFDI33164*CFDI33165*CFDI33166bien-->
        <xsl:variable name="VTImpuestosReten" select="/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion']" />
        <xsl:variable name="VTImpuestosReten1" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']" />
        <xsl:if test="count(/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosRetenidos) &gt; 0">         
          <xsl:if test="normalize-space($VTImpuestosReten/@Impuesto) != ''">
          <xsl:if test="normalize-space($VTImpuestosReten/@Impuesto) != '001'">
            <xsl:if test="normalize-space($VTImpuestosReten/@Impuesto) != '002'">
              <xsl:if test="normalize-space($VTImpuestosReten/@Impuesto) != '003'">
              <comprobante-TipoImpuestoRetencion1>
                <xsl:value-of select="'false'"/>                
              </comprobante-TipoImpuestoRetencion1>                
            </xsl:if>
            </xsl:if>
          </xsl:if>
          </xsl:if>
          <xsl:if test="normalize-space($VTImpuestosReten/@TipoFactor) != ''">
          <xsl:if test="normalize-space($VTImpuestosReten/@TipoFactor) != 'Tasa'">   
            <xsl:if test="normalize-space($VTImpuestosReten/@TipoFactor) != 'Cuota'"> 
              <xsl:if test="normalize-space($VTImpuestosReten/@TipoFactor) != 'Exento'"> 
              <comprobante-TipoFactorTrasladoRetencion>
                <xsl:value-of select="'false'"/>                
              </comprobante-TipoFactorTrasladoRetencion>                
            </xsl:if>
            </xsl:if>
          </xsl:if>
          </xsl:if>
          <xsl:if test="count($VTImpuestosReten[1]/@TipoFactor) &gt; 0"> 
           <xsl:if test="not(normalize-space($VTImpuestosReten[1]/@TipoFactor) != 'Exento')">          
            <comprobante-TipoFactorExentoRetencion>
              <xsl:value-of select="'false'"/>              
            </comprobante-TipoFactorExentoRetencion>             
          </xsl:if>
          </xsl:if>
          <xsl:if test="count($VTImpuestosReten[2]/@TipoFactor) &gt; 0"> 
            <xsl:if test="not(normalize-space($VTImpuestosReten[2]/@TipoFactor) != 'Exento')">          
              <comprobante-TipoFactorExentoRetencion>
                <xsl:value-of select="'false'"/>                
              </comprobante-TipoFactorExentoRetencion>             
            </xsl:if>
          </xsl:if>
        </xsl:if>
        
        <!--se valida NumeroPedimentoCFDI33171-->
        <xsl:variable name="VTNumeroPedmt" select="/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='InformacionAduanera']" />            
          <xsl:if test="normalize-space($VTNumeroPedmt/@NumeroPedimento) != ''">           
            <xsl:if test="count(/*[local-name() = 'Comprobante']/*[local-name()='Complemento']/*[local-name()='ComercioExterior']) &gt; 0">           
            <comprobante-TipoNumeroPedimento71>
              <xsl:value-of select="'false'"/>              
            </comprobante-TipoNumeroPedimento71>            
          </xsl:if>
        </xsl:if>
        
        <!--se valida NumeroPedimentoCFDI33178-->        
        <xsl:variable name="VTNumeroPedmtP1" select="/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Parte']/*[local-name()='InformacionAduanera']" />
        <xsl:variable name="VTNumeroPedmt11" select="/*[local-name() = 'Comprobante']/*[local-name()='Complemento']/*[local-name()='ComercioExterior']" />        
        <xsl:if test="normalize-space($VTNumeroPedmtP1/@NumeroPedimento) != ''">           
          <xsl:if test="count($VTNumeroPedmt11) &gt; 0">           
            <comprobante-TipoNumeroPedimento78>
              <xsl:value-of select="'false'"/>              
            </comprobante-TipoNumeroPedimento78>            
          </xsl:if>
        </xsl:if>
        
        <!--se valida ImpuestoRetencionCFDI33185-->
        <xsl:variable name="VTImpuestosReten12" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion'][1]" />
        <xsl:if test="normalize-space($VTImpuestosReten12/@Impuesto) != ''">
          <xsl:if test="normalize-space($VTImpuestosReten12/@Impuesto) != '001'">
            <xsl:if test="normalize-space($VTImpuestosReten12/@Impuesto) != '002'">
              <xsl:if test="normalize-space($VTImpuestosReten12/@Impuesto) != '003'">
                <comprobante-TipoImpuestoRetencion12>
                  <xsl:value-of select="'false'"/>                  
                </comprobante-TipoImpuestoRetencion12>                
              </xsl:if>
            </xsl:if>
          </xsl:if>
        </xsl:if>
        
        <!--se valida ImpuestoRetencionCFDI33185-->
        <xsl:variable name="VTImpuestosReten12" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion'][2]" />
        <xsl:if test="normalize-space($VTImpuestosReten12/@Impuesto) != ''">
          <xsl:if test="normalize-space($VTImpuestosReten12/@Impuesto) != '001'">
            <xsl:if test="normalize-space($VTImpuestosReten12/@Impuesto) != '002'">
              <xsl:if test="normalize-space($VTImpuestosReten12/@Impuesto) != '003'">
                <comprobante-TipoImpuestoRetencion12>
                  <xsl:value-of select="'false'"/>                  
                </comprobante-TipoImpuestoRetencion12>                
              </xsl:if>
            </xsl:if>
          </xsl:if>
        </xsl:if>
        <!--se valida ImpuestoRetencionCFDI33185-->
        <xsl:variable name="VTImpuestosReten12" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion'][3]" />
        <xsl:if test="normalize-space($VTImpuestosReten12/@Impuesto) != ''">
          <xsl:if test="normalize-space($VTImpuestosReten12/@Impuesto) != '001'">
            <xsl:if test="normalize-space($VTImpuestosReten12/@Impuesto) != '002'">
              <xsl:if test="normalize-space($VTImpuestosReten12/@Impuesto) != '003'">
                <comprobante-TipoImpuestoRetencion12>
                  <xsl:value-of select="'false'"/>                  
                </comprobante-TipoImpuestoRetencion12>                
              </xsl:if>
            </xsl:if>
          </xsl:if>
        </xsl:if>
      
        
        <!--se valida ImpuestoRetencionCFDI33191-->
        <xsl:variable name="VTImpuestosReten91" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][1]" />
        <xsl:if test="normalize-space($VTImpuestosReten91/@Impuesto) != ''">
          <xsl:if test="normalize-space($VTImpuestosReten91/@Impuesto) != '001'">
            <xsl:if test="normalize-space($VTImpuestosReten91/@Impuesto) != '002'">
              <xsl:if test="normalize-space($VTImpuestosReten91/@Impuesto) != '003'">                               
                <comprobante-TipoImpuestoRetencion91>
                  <xsl:value-of select="'false'"/>                  
                </comprobante-TipoImpuestoRetencion91>                
              </xsl:if>
            </xsl:if>
          </xsl:if>
        </xsl:if>
        <!--se valida ImpuestoRetencionCFDI33191-->
        <xsl:variable name="VTImpuestosReten91" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][2]" />
        <xsl:if test="normalize-space($VTImpuestosReten91/@Impuesto) != ''">
          <xsl:if test="normalize-space($VTImpuestosReten91/@Impuesto) != '001'">
            <xsl:if test="normalize-space($VTImpuestosReten91/@Impuesto) != '002'">
              <xsl:if test="normalize-space($VTImpuestosReten91/@Impuesto) != '003'">                               
                <comprobante-TipoImpuestoRetencion91>
                  <xsl:value-of select="'false'"/>                  
                </comprobante-TipoImpuestoRetencion91>                
              </xsl:if>
            </xsl:if>
          </xsl:if>
        </xsl:if>
        <!--se valida ImpuestoRetencionCFDI33191-->
        <xsl:variable name="VTImpuestosReten91" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][3]" />
        <xsl:if test="normalize-space($VTImpuestosReten91/@Impuesto) != ''">
          <xsl:if test="normalize-space($VTImpuestosReten91/@Impuesto) != '001'">
            <xsl:if test="normalize-space($VTImpuestosReten91/@Impuesto) != '002'">
              <xsl:if test="normalize-space($VTImpuestosReten91/@Impuesto) != '003'">                               
                <comprobante-TipoImpuestoRetencion91>
                  <xsl:value-of select="'false'"/>                  
                </comprobante-TipoImpuestoRetencion91>                
              </xsl:if>
            </xsl:if>
          </xsl:if>
        </xsl:if>
                 
        
        <!--se valida TotalImpuestosRetenidosCFDI33181-->
        <xsl:if test="normalize-space(/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosRetenidos) != ''">           
          <xsl:variable name="VTImpuestosRetenids" select="format-number(number(normalize-space(/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosRetenidos)), '######.00')" />
          <xsl:variable name="Importes81">
            <xsl:value-of select="format-number(sum(/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion']/@Importe), '######.00')"/>
          </xsl:variable>
          <xsl:if test="$VTImpuestosRetenids != $Importes81">
            <comprobante-TipoImpuestoRetencion81>
              <xsl:value-of select="'false'"/>              
            </comprobante-TipoImpuestoRetencion81> 
            
          </xsl:if>
        </xsl:if> 
        
        <!--se valida TotalImpuestosRetenidosCFDI33183-->
        <xsl:if test="normalize-space(/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosTrasladados) != ''">           
          <xsl:variable name="VTImpuestosRetenidst" select="format-number(number(normalize-space(/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosTrasladados)), '######.00')" />
          <xsl:variable name="Importes83">
            <xsl:value-of select="format-number(sum(/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@Importe), '######.00')"/>
          </xsl:variable>
          <xsl:if test="$VTImpuestosRetenidst != $Importes83">
            <comprobante-TipoImpuestoRetencion83>
              <xsl:value-of select="'false'"/>              
            </comprobante-TipoImpuestoRetencion83> 
            
          </xsl:if>
        </xsl:if> 
        
        <!-- ValidacionCFDI33189 Funciona en forma Global -->
        <xsl:if test="normalize-space(/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion']/@Importe) != ''">           
      			<xsl:variable name="VTImpuestos89" select="format-number(sum(/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion']/@Importe), '######.00')" />			
      			<xsl:variable name="Impuestos89">									 	
      					<xsl:value-of select="format-number(sum(/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion']/@Importe), '######.00')"/>									
      			</xsl:variable>			
      			<xsl:if test="$VTImpuestos89 != $Impuestos89">
      				<comprobante-TipoImpuestoRetencion89>
      					<xsl:value-of select="'false'"/>              
      				</comprobante-TipoImpuestoRetencion89> 
      				
      			</xsl:if>
		    </xsl:if>
        
        
        <!-- Validacion CFDI33195-->
        <xsl:variable name="VTImpuestosTras951" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']" />
        <xsl:variable name="VTImpuestosTras95" select="/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']" />             
        <xsl:if test="$VTImpuestosTras95/@TipoFactor != 'Exento'">
          <xsl:if test="count($VTImpuestosTras951/@Importe) &gt; 0">                    
            <xsl:variable name="Importe1_951">
              <xsl:value-of select="format-number(sum($VTImpuestosTras951/@Importe), '######.00')"/>
            </xsl:variable>
            <xsl:if test="count($VTImpuestosTras95/@Importe) &gt; 0">           
              <xsl:variable name="Importe2_95">
                <xsl:value-of select="format-number(sum($VTImpuestosTras95/@Importe), '######.00')"/>
              </xsl:variable>                              
                  <xsl:if test="$Importe1_951 != $Importe2_95">                  
                    <comprobante-Impuestos-Traslado-Cuota95><xsl:value-of select="'false'"/></comprobante-Impuestos-Traslado-Cuota95>                   
                  </xsl:if>                              
            </xsl:if>  		  
          </xsl:if>
        </xsl:if>
                
        <!--se valida la cantidad de decimales para moneda MXN ImporteCFDI33150-->
        <xsl:if test="(/*[local-name() = 'Comprobante']/@Moneda) = 'MXN'">
          <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento) != ''"> 
            <xsl:choose>           
              <xsl:when test="substring-after(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento,'.') != ''">
                <xsl:if test="substring(substring-after(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento,'.'),3,1)">					
                  <TipoValorImportedecimalesDc><xsl:value-of select="'false'" /></TipoValorImportedecimalesDc> 
                </xsl:if>	 					
              </xsl:when>		
            </xsl:choose>	
            <xsl:choose>           
              <xsl:when test="((substring-before(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento,'.') != '') and (substring-after(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento,'.') = ''))">						
                <TipoValorImportedecimalesDc><xsl:value-of select="'false'" /></TipoValorImportedecimalesDc> 						       
              </xsl:when>		
            </xsl:choose>	
          </xsl:if>
        </xsl:if>
        
        
      <!--ValidaImpuestoTipoDeComprobanteToPCFDI33179-->        
     <xsl:if test="normalize-space(/*[local-name() = 'Comprobante']/@TipoDeComprobante) = 'T'">                  
          <xsl:if test="count(/*[local-name()='Comprobante']/*[local-name()='Impuestos']) &gt; 0">            
            <comprobante-ImpuestoTipoDeComprobanteToP>
              <xsl:value-of select="'false'" />
            </comprobante-ImpuestoTipoDeComprobanteToP>
            
          </xsl:if>
      </xsl:if>
        <xsl:if test="normalize-space(/*[local-name() = 'Comprobante']/@TipoDeComprobante) = 'P'">                  
          <xsl:if test="count(/*[local-name()='Comprobante']/*[local-name()='Impuestos']) &gt; 0">            
            <comprobante-ImpuestoTipoDeComprobanteToP>
              <xsl:value-of select="'false'" />
            </comprobante-ImpuestoTipoDeComprobanteToP>            
          </xsl:if>
        </xsl:if>  
      <!--ValidaTotalImpuestosRetenidosCFDI33181-->
      <xsl:if test="(/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/@TotalImpuestosRetenidos !='')">
        <xsl:if test="((/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/@TotalImpuestosRetenidos) != (/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion']/@Importe))">
          <comprobante-ImpuestoTotalImpuestosRetenidos>
            <xsl:value-of select="'false'" />
          </comprobante-ImpuestoTotalImpuestosRetenidos>
          
        </xsl:if>
      </xsl:if>
        
        <!--ValidaTotalImpuestosRetenidosCFDI33184-->
        <xsl:if test="count(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/*[local-name()='Retenciones']) &gt; 0">   
          <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosRetenidos) = ''"> 
            <comprobante-ImpuestoTipoDeComprobanteTRt>
              <xsl:value-of select="'false'" />
            </comprobante-ImpuestoTipoDeComprobanteTRt>
            
          </xsl:if>
        </xsl:if>
        
        <!--ValidaTotalImpuestosRetenidosCFDI33186--> 
          <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosRetenidos) != ''"> 
            <xsl:variable name="VTvari86" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion'][1]/@Impuesto" />
            <xsl:variable name="VTvari862" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion'][2]/@Impuesto" />
            <xsl:if test="normalize-space($VTvari86) != ''">              
              <xsl:if test="normalize-space($VTvari862) != ''">               
                <xsl:if test="normalize-space($VTvari862) = normalize-space($VTvari86)">
                  <comprobante-ImpuestoTotalImpRet>
                    <xsl:value-of select="'false'" />
                  </comprobante-ImpuestoTotalImpRet>
                  
                </xsl:if>
              </xsl:if>              
            </xsl:if>
          </xsl:if>
        
        <!--ValidaTotalImpuestosRetenidosCFDI33187--> 
        <xsl:if test="(/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion']/@Importe !='')">
          <xsl:if test="not(/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosRetenidos !='')">
            <comprobante-ImpuestoTras87><xsl:value-of select="'false'" /></comprobante-ImpuestoTras87>
            
          </xsl:if>
        </xsl:if>
        <xsl:if test="(/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosRetenidos !='')">
          <xsl:if test="not(/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Retenciones']/*[local-name()='Retencion']/@Importe !='')">          
            <comprobante-ImpuestoTras87><xsl:value-of select="'false'" /></comprobante-ImpuestoTras87>
          </xsl:if>                      
        </xsl:if>
        
        
        <!--ValidaTotalImpuestosRetenidosCFDI33190-->
        <xsl:if test="count(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']) &gt; 0">   
          <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosTrasladados) = ''"> 
            <comprobante-ImpuestoTipoDeComprobanteTtras>
              <xsl:value-of select="'false'" />
            </comprobante-ImpuestoTipoDeComprobanteTtras>
            
          </xsl:if>
        </xsl:if>
        
        <!--ValidaTotalImpuestosTrasladosCFDI33192--> 
        <!--Impuesto-->
        <xsl:variable name="VTImpuesTras92" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][1]/@Impuesto" />
        <xsl:variable name="VTImpuesTras921" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][2]/@Impuesto" />
        <xsl:variable name="VTImpuesTras922" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][3]/@Impuesto" />
        <xsl:variable name="VTImpuesTras923" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][4]/@Impuesto" />
        <!--Factor-->
        <xsl:variable name="VTFactorTras92" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][1]/@TipoFactor" />
        <xsl:variable name="VTFactorTras921" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][2]/@TipoFactor" />
        <xsl:variable name="VTFactorTras922" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][3]/@TipoFactor" />
        <xsl:variable name="VTFactorTras923" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][4]/@TipoFactor" />
        <!--Tasa-->
        <xsl:variable name="VTTasaTras92" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][1]/@TasaOCuota" />
        <xsl:variable name="VTTasaTras921" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][2]/@TasaOCuota" />
        <xsl:variable name="VTTasaTras922" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][3]/@TasaOCuota" />
        <xsl:variable name="VTTasaTras923" select="/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado'][4]/@TasaOCuota" />
        
        <xsl:if test="normalize-space($VTImpuesTras92) != ''">
          <xsl:if test="normalize-space($VTImpuesTras921) != ''">
            <xsl:if test="((normalize-space($VTImpuesTras92) = normalize-space($VTImpuesTras921)) and (normalize-space($VTFactorTras92) = normalize-space($VTFactorTras921)) and (normalize-space($VTTasaTras92) = normalize-space($VTTasaTras921)))"> 
              <comprobante-ImpuestoTipoDeComprobanteTtras92>
                <xsl:value-of select="'false'" />
              </comprobante-ImpuestoTipoDeComprobanteTtras92>
              
            </xsl:if>
            <xsl:if test="normalize-space($VTImpuesTras922) != ''">
              <xsl:if test="((normalize-space($VTImpuesTras922) = normalize-space($VTImpuesTras92)) and (normalize-space($VTFactorTras922) = normalize-space($VTFactorTras92)) and (normalize-space($VTTasaTras922) = normalize-space($VTTasaTras92)))">
                <comprobante-ImpuestoTipoDeComprobanteTtras92>
                  <xsl:value-of select="'false'" />
                </comprobante-ImpuestoTipoDeComprobanteTtras92>
                
              </xsl:if>
              <xsl:if test="((normalize-space($VTImpuesTras921) = normalize-space($VTImpuesTras922)) and (normalize-space($VTFactorTras921) = normalize-space($VTFactorTras922)) and (normalize-space($VTTasaTras921) = normalize-space($VTTasaTras922)))">
                <comprobante-ImpuestoTipoDeComprobanteTtras92>
                  <xsl:value-of select="'false'" />
                </comprobante-ImpuestoTipoDeComprobanteTtras92>
                
              </xsl:if>
            </xsl:if>
            
            <xsl:if test="normalize-space($VTImpuesTras923) != ''">
              <xsl:if test="((normalize-space($VTImpuesTras923) = normalize-space($VTImpuesTras92)) and (normalize-space($VTFactorTras923) = normalize-space($VTFactorTras92)) and (normalize-space($VTTasaTras923) = normalize-space($VTTasaTras92)))">
                <comprobante-ImpuestoTipoDeComprobanteTtras92>
                  <xsl:value-of select="'false'" />
                </comprobante-ImpuestoTipoDeComprobanteTtras92>
                
              </xsl:if>
              <xsl:if test="((normalize-space($VTImpuesTras921) = normalize-space($VTImpuesTras923)) and (normalize-space($VTFactorTras921) = normalize-space($VTFactorTras923)) and (normalize-space($VTTasaTras921) = normalize-space($VTTasaTras923)))">
                <comprobante-ImpuestoTipoDeComprobanteTtras92>
                  <xsl:value-of select="'false'" />
                </comprobante-ImpuestoTipoDeComprobanteTtras92>
                
              </xsl:if>
              <xsl:if test="((normalize-space($VTImpuesTras922) = normalize-space($VTImpuesTras923)) and (normalize-space($VTFactorTras922) = normalize-space($VTFactorTras923)) and (normalize-space($VTTasaTras922) = normalize-space($VTTasaTras923)))">
                <comprobante-ImpuestoTipoDeComprobanteTtras92>
                  <xsl:value-of select="'false'" />
                </comprobante-ImpuestoTipoDeComprobanteTtras92>
                
              </xsl:if>
            </xsl:if>
          </xsl:if>
        </xsl:if>
        
        
      
        <!--ValidaTotalImpuestosTrasladadosNodoTranslado-->
        
        <xsl:if test="(/*[local-name() = 'Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*[local-name()='Impuestos']/*[local-name()='Translados']/*[local-name()='Traslado']/@Base != '')">
          <xsl:if test="(/*[local-name() = 'Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosTrasladados !='')">
            <comprobante-ImpuestoTotalImpuestosTrasladosNT>
              <xsl:value-of select="'false'" />
            </comprobante-ImpuestoTotalImpuestosTrasladosNT>
            
          </xsl:if>
          </xsl:if>
        
        
        <!--se valida la cantidad de decimales para moneda MXN TotalDeImpuestosRetenidosCFDI33180*CFDI33182-->
        <xsl:if test="(/*[local-name() = 'Comprobante']/@Moneda ='MXN')">
          <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosRetenidos) != ''">   
            <xsl:choose>           
              <xsl:when test="substring-after(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosRetenidos,'.') != ''">
                <xsl:if test="substring(substring-after(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosRetenidos,'.'),3,1)">					
                  <TipoValorTotalImpuestosRetenidosdecimales><xsl:value-of select="'false'" /></TipoValorTotalImpuestosRetenidosdecimales> 
                </xsl:if>	 					
              </xsl:when>		
            </xsl:choose>	
            <xsl:choose>           
              <xsl:when test="((substring-before(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosRetenidos,'.') != '') and (substring-after(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosRetenidos,'.') = ''))">						
                <TipoValorTotalImpuestosRetenidosdecimales><xsl:value-of select="'false'" /></TipoValorTotalImpuestosRetenidosdecimales> 						       
              </xsl:when>		
            </xsl:choose>								
          </xsl:if>
          <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosTrasladados) != ''">				
            <xsl:choose>           
              <xsl:when test="substring-after(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosTrasladados,'.') != ''">
                <xsl:if test="substring(substring-after(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosTrasladados,'.'),3,1)">					
                  <TipoValorTotalImpuestosTrasladadosdecimales><xsl:value-of select="'false'" /></TipoValorTotalImpuestosTrasladadosdecimales> 
                </xsl:if>	 					
              </xsl:when>		
            </xsl:choose>	
            <xsl:choose>           
              <xsl:when test="((substring-before(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosTrasladados,'.') != '') and (substring-after(/*[local-name()='Comprobante']/*[local-name()='Impuestos']/@TotalImpuestosTrasladados,'.') = ''))">						
                <TipoValorTotalImpuestosTrasladadosdecimales><xsl:value-of select="'false'" /></TipoValorTotalImpuestosTrasladadosdecimales> 						       
              </xsl:when>		
            </xsl:choose>										
          </xsl:if>
        </xsl:if>
        
        
        <!--StartComplementoDePago-->
        <!--CRP101-->        
        <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/@Version) != ''">
          <xsl:if test="normalize-space(/*[local-name()='Comprobante']/@TipoDeComprobante) != 'P'">             
              <ErrorCRP101>
                <xsl:value-of select="'false'"/>
              </ErrorCRP101>                                  
          </xsl:if>
        
          <!--CRP102-->        
          <xsl:if test="/*[local-name()='Comprobante']/@SubTotal &gt; 0">  
            <ErrorCRP102>
              <xsl:value-of select="'false'"/>
            </ErrorCRP102>                             
          </xsl:if>
          
          <!--CRP103-->        
          <xsl:if test="normalize-space(/*[local-name()='Comprobante']/@Moneda) != 'XXX'">  
            <ErrorCRP103>
              <xsl:value-of select="'false'"/>
            </ErrorCRP103>                             
          </xsl:if>
                    
          <!--CRP104-->        
          <xsl:if test="count(/*[local-name()='Comprobante']/@FormaPago) &gt; 0">  
            <ErrorCRP104>
              <xsl:value-of select="'false'"/>
            </ErrorCRP104>                             
          </xsl:if>
          <!--CRP105-->        
          <xsl:if test="count(/*[local-name()='Comprobante']/@MetodoPago) &gt; 0">  
            <ErrorCRP105>
              <xsl:value-of select="'false'"/>
            </ErrorCRP105>                             
          </xsl:if>
          <!--CRP106-->        
          <xsl:if test="count(/*[local-name()='Comprobante']/@CondicionesDePago) &gt; 0">  
            <ErrorCRP106>
              <xsl:value-of select="'false'"/>
            </ErrorCRP106>                             
          </xsl:if>
          <!--CRP107-->        
          <xsl:if test="count(/*[local-name()='Comprobante']/@Descuento) &gt; 0">  
            <ErrorCRP107>
              <xsl:value-of select="'false'"/>
            </ErrorCRP107>                             
          </xsl:if>
          <!--CRP108-->        
          <xsl:if test="count(/*[local-name()='Comprobante']/@TipoCambio) &gt; 0">  
            <ErrorCRP108>
              <xsl:value-of select="'false'"/>
            </ErrorCRP108>                             
          </xsl:if>
          <!--CRP109-->        
          <xsl:if test="/*[local-name()='Comprobante']/@Total &gt; 0">  
            <ErrorCRP109>
              <xsl:value-of select="'false'"/>
            </ErrorCRP109>                             
          </xsl:if>
          <!--CRP110-->        
          <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Receptor']/@UsoCFDI) != ''">
            <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Receptor']/@UsoCFDI) != 'P01'">  
              <ErrorCRP110>
                <xsl:value-of select="'false'"/>
              </ErrorCRP110>                             
            </xsl:if>
          </xsl:if>
          <!--CRP111-->        
          <xsl:if test="count(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto'][1]) &gt; 0">   
            <xsl:if test="count(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto'][2]) &gt; 0"> 
              <ErrorCRP111>
                <xsl:value-of select="'false'"/>
              </ErrorCRP111> 
            </xsl:if>
          </xsl:if>
          <!--CRP112 Verifica que no tenga nodos hijos-->     						
          <xsl:if test="count(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/*) &gt; 0">                     					
            <ErrorCRP212>
              <xsl:value-of select="'false'"/>
            </ErrorCRP212>                			
          </xsl:if>
          <!--CRP113-->        
          <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@ClaveProdServ) != '84111506'">              
              <ErrorCRP113>
                <xsl:value-of select="'false'"/>
              </ErrorCRP113>             
          </xsl:if>
          <!--CRP114-->        
          <xsl:if test="count(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@NoIdentificacion) &gt; 0">              
            <ErrorCRP114>
              <xsl:value-of select="'false'"/>
            </ErrorCRP114>             
          </xsl:if>
          <!--CRP115-->        
          <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Cantidad) != '1'">              
            <ErrorCRP115>
              <xsl:value-of select="'false'"/>
            </ErrorCRP115>             
          </xsl:if>
          <!--CRP116-->        
          <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@ClaveUnidad) != 'ACT'">              
            <ErrorCRP116>
              <xsl:value-of select="'false'"/>
            </ErrorCRP116>             
          </xsl:if>
          <!--CRP117-->        
          <xsl:if test="count(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Unidad) &gt; 0">              
            <ErrorCRP117>
              <xsl:value-of select="'false'"/>
            </ErrorCRP117>             
          </xsl:if>
          <!--CRP118-->        
          <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descripcion) != 'Pago'">              
            <ErrorCRP118>
              <xsl:value-of select="'false'"/>
            </ErrorCRP118>             
          </xsl:if>
          <!--CRP119-->        
          <xsl:if test="(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@ValorUnitario) &gt; 0 or (/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@ValorUnitario) &lt; 0">              
            <ErrorCRP119>
              <xsl:value-of select="'false'"/>
            </ErrorCRP119>             
          </xsl:if>
          
          <!--CRP120-->        
          <xsl:if test="(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Importe) &gt; 0 or (/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Importe) &lt; 0">              
            <ErrorCRP120>
              <xsl:value-of select="'false'"/>
            </ErrorCRP120>             
          </xsl:if>
          <!--CRP121-->        
          <xsl:if test="count(/*[local-name()='Comprobante']/*[local-name()='Conceptos']/*[local-name()='Concepto']/@Descuento) &gt; 0">              
            <ErrorCRP121>
              <xsl:value-of select="'false'"/>
            </ErrorCRP121>             
          </xsl:if>
          <!--CRP122-->        
          <xsl:if test="count(/*[local-name()='Comprobante']/*[local-name()='Impuestos']) &gt; 0">              
              <ErrorCRP122>
                <xsl:value-of select="'false'"/>
              </ErrorCRP122>             
          </xsl:if>
         
          <!--CRP201-->     
          <xsl:variable name="ErrorCRP201">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FormaDePagoP[. = '99']">
              <xsl:variable name="postionP" select="position()"/> 
              <xsl:value-of select="$postionP"/>														
              <ErrorCRP201><xsl:value-of select="'false'" /></ErrorCRP201> 						       																										
            </xsl:for-each>
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP201"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP201,'fa'),1,1)">
            <ErrorCRP201>
              <xsl:value-of select="'false'"/>
            </ErrorCRP201>             
          </xsl:if>		
          
          <!--CRP202-->     
          <xsl:variable name="ErrorCRP202">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@MonedaP[. = 'XXX']">
              <xsl:variable name="postionP" select="position()"/> 
              <xsl:value-of select="$postionP"/>														
              <ErrorCRP202><xsl:value-of select="'false'" /></ErrorCRP202> 						       																										
            </xsl:for-each>
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP202"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP202,'fa'),1,1)">
            <ErrorCRP202>
              <xsl:value-of select="'false'"/>
            </ErrorCRP202>             
          </xsl:if>
          
          
          
          <!--CRP203-->
          <xsl:variable name="ErrorCRP203">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@MonedaP[. != 'MXN']">
              <xsl:variable name="postion" select="position()"/> 
              <xsl:value-of select="$postion"/>
              <xsl:if test="not(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@TipoCambioP) != ''">
                <ErrorCRP203>
                  <xsl:value-of select="'false'"/>
                </ErrorCRP203> 		
              </xsl:if>					
            </xsl:for-each>			
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP203"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP203,'fa'),1,1)">
            <ErrorCRP203>
              <xsl:value-of select="'false'"/>
            </ErrorCRP203>             
          </xsl:if>	
          
          <!--CRP204--> 
          <xsl:variable name="ErrorCRP204">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@MonedaP[. = 'MXN']">
              <xsl:variable name="postion" select="position()"/> 
              <xsl:value-of select="$postion"/>
              <xsl:if test="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@TipoCambioP != ''">
                <ErrorCRP204>
                  <xsl:value-of select="'false'"/>
                </ErrorCRP204> 		
              </xsl:if>					
            </xsl:for-each>			
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP204"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP204,'fa'),1,1)">
            <ErrorCRP204>
              <xsl:value-of select="'false'"/>
            </ErrorCRP204>             
          </xsl:if>	
          <!--CRP206--> 
          <xsl:variable name="ErrorCRP206">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@Monto">
              <xsl:variable name="postion" select="position()"/> 
              <xsl:value-of select="$postion"/>								
              <xsl:variable name="SUMImpPagado" select="sum(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/*[local-name()='DoctoRelacionado']/@ImpPagado)" />
              <xsl:if test="$SUMImpPagado &gt; (/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@Monto)">             
                <ErrorCRP206>
                  <xsl:value-of select="'false'"/>
                </ErrorCRP206> 
              </xsl:if>
            </xsl:for-each>			
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP206"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP206,'fa'),1,1)">
            <ErrorCRP206>
              <xsl:value-of select="'false'"/>
            </ErrorCRP206>             
          </xsl:if>	
          
          <!--CRP207-->     
          <xsl:variable name="ErrorCRP207">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@Monto[. &lt;= 0]">
              <xsl:variable name="postionP" select="position()"/> 
              <xsl:value-of select="$postionP"/>														
              <ErrorCRP207><xsl:value-of select="'false'" /></ErrorCRP207> 						       																										
            </xsl:for-each>
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP207"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP207,'fa'),1,1)">
            <ErrorCRP207>
              <xsl:value-of select="'false'"/>
            </ErrorCRP207>             
          </xsl:if>
          
          <!--CRP208-->     
          <xsl:variable name="ErrorCRP208">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FechaPago[. != '']">
              <xsl:variable name="postionP" select="position()"/> 
              <xsl:value-of select="$postionP"/>	
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado']/@MonedaDR[. = 'MXN']">
                <xsl:variable name="postion" select="position()"/> 
                <xsl:value-of select="$postion"/>
                <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/@Monto) != ''">					           
                  <xsl:if test="substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/@Monto,'.') != ''">
                    <xsl:if test="substring(substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/@Monto,'.'),3,1)">					
                      <ErrorCRP208><xsl:value-of select="'false'" /></ErrorCRP208> 
                    </xsl:if>	 					
                  </xsl:if>		
                  
                  <xsl:if test="((substring-before(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/@Monto,'.') != '') and not((substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/@Monto,'.')) != ''))">						
                    <ErrorCRP208><xsl:value-of select="'false'" /></ErrorCRP208> 						       
                  </xsl:if>													
                </xsl:if>					
              </xsl:for-each>		
            </xsl:for-each>
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP208"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP208,'fa'),1,1)">
            <ErrorCRP208>
              <xsl:value-of select="'false'"/>
            </ErrorCRP208>             
          </xsl:if>
          
          
          <!--CRP208USD-->     
          <xsl:variable name="ErrorCRP208USD">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FechaPago[. != '']">
              <xsl:variable name="postionP" select="position()"/> 
              <xsl:value-of select="$postionP"/>	
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado']/@MonedaDR[. = 'USD']">
                <xsl:variable name="postion" select="position()"/> 
                <xsl:value-of select="$postion"/>
                <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/@Monto) != ''">					           
                  <xsl:if test="substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/@Monto,'.') != ''">
                    <xsl:if test="substring(substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/@Monto,'.'),3,1)">					
                      <ErrorCRP208USD><xsl:value-of select="'false'" /></ErrorCRP208USD> 
                    </xsl:if>	 					
                  </xsl:if>		
                  
                  <xsl:if test="((substring-before(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/@Monto,'.') != '') and not((substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/@Monto,'.')) != ''))">						
                    <ErrorCRP208USD><xsl:value-of select="'false'" /></ErrorCRP208USD> 						       
                  </xsl:if>													
                </xsl:if>					
              </xsl:for-each>		
            </xsl:for-each>
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP208USD"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP208USD,'fa'),1,1)">
            <ErrorCRP208USD>
              <xsl:value-of select="'false'"/>
            </ErrorCRP208USD>             
          </xsl:if>
          
          <!--CRP211-->     
          <xsl:variable name="ErrorCRP211">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@RfcEmisorCtaOrd[. = 'XEXX010101000']">
              <xsl:variable name="postion" select="position()"/> 
              <xsl:value-of select="$postion"/>
              <xsl:if test="not(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@NomBancoOrdExt) != ''">
                <ErrorCRP211>
                  <xsl:value-of select="'false'"/>
                </ErrorCRP211> 		
              </xsl:if>					
            </xsl:for-each>			
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP211"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP211,'fa'),1,1)">
            <ErrorCRP211>
              <xsl:value-of select="'false'"/>
            </ErrorCRP211>             
          </xsl:if>	
          <!--CRP212--> 
          <xsl:variable name="ErrorCRP212">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FechaPago">
              <xsl:variable name="postion" select="position()"/> 
              <xsl:value-of select="$postion"/>	
              <xsl:variable name="POSPAGO" select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]" />
              <xsl:if test="(($POSPAGO/@FormaDePagoP != '02') and ($POSPAGO/@FormaDePagoP != '03') and ($POSPAGO/@FormaDePagoP != '04') and ($POSPAGO/@FormaDePagoP != '05') and ($POSPAGO/@FormaDePagoP != '06') and ($POSPAGO/@FormaDePagoP != '28') and ($POSPAGO/@FormaDePagoP != '29'))">				             
                <xsl:if test="normalize-space($POSPAGO/@CtaOrdenante) != ''">               
                  <ErrorCRP212>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP212>               
                </xsl:if>
              </xsl:if>
            </xsl:for-each>			
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP212"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP212,'fa'),1,1)">
            <ErrorCRP212>
              <xsl:value-of select="'false'"/>
            </ErrorCRP212>             
          </xsl:if>	
          <!--StartCRP213--> 			
          <xsl:variable name="ErrorCRP213">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@CtaOrdenante[. != '']">
              <xsl:variable name="postion" select="position()"/> 
              <xsl:value-of select="$postion"/>
              
              <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@FormaDePagoP) = '02'">
                <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@CtaOrdenante,'^([0-9]{11})$|^([0-9]{18})$'))">
                  <ErrorCRP213>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP213>               
                </xsl:if>
              </xsl:if>
              <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@FormaDePagoP) = '03'">
                <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@CtaOrdenante,'^([0-9]{10})$|^([0-9]{16})$|^([0-9]{18})$'))">
                  <ErrorCRP213>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP213>               
                </xsl:if>
              </xsl:if>
              <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@FormaDePagoP) = '04'">
                <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@CtaOrdenante,'^([0-9]{16})$'))">
                  <ErrorCRP213>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP213>               
                </xsl:if>
              </xsl:if>
              <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@FormaDePagoP) = '05'">
                <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@CtaOrdenante,'^([0-9]{10,11})$|^([0-9]{15,16})$|^([0-9]{18})$|^([A-Z0-9_]{10,50})$'))">
                  <ErrorCRP213>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP213>               
                </xsl:if>
              </xsl:if>
              <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@FormaDePagoP) = '06'">
                <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@CtaOrdenante,'^([0-9]{10})$'))">
                  <ErrorCRP213>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP213>               
                </xsl:if>
              </xsl:if>
              <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@FormaDePagoP) = '28'">
                <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@CtaOrdenante,'^([0-9]{16})$'))">
                  <ErrorCRP213>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP213>               
                </xsl:if>
              </xsl:if>
              <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@FormaDePagoP) = '29'">
                <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@CtaOrdenante,'^([0-9]{15,16})$'))">
                  <ErrorCRP213>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP213>               
                </xsl:if>
              </xsl:if>
            </xsl:for-each>			
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP213"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP213,'fa'),1,1)">
            <ErrorCRP213>
              <xsl:value-of select="'false'"/>
            </ErrorCRP213>             
          </xsl:if>	
          <!--EndCRP213--> 	
          

          <!--CRP214--> 
          <xsl:variable name="ErrorCRP214">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FechaPago">
              <xsl:variable name="postion" select="position()"/> 
              <xsl:value-of select="$postion"/>	
              <xsl:variable name="POSPAGO" select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]" />
              <xsl:if test="(($POSPAGO/@FormaDePagoP != '02') and ($POSPAGO/@FormaDePagoP != '03') and ($POSPAGO/@FormaDePagoP != '04') and ($POSPAGO/@FormaDePagoP != '05') and ($POSPAGO/@FormaDePagoP != '28') and ($POSPAGO/@FormaDePagoP != '29'))">				             
                <xsl:if test="normalize-space($POSPAGO/@RfcEmisorCtaBen) != ''">               
                  <ErrorCRP214>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP214>               
                </xsl:if>
              </xsl:if>
            </xsl:for-each>			
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP214"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP214,'fa'),1,1)">
            <ErrorCRP214>
              <xsl:value-of select="'false'"/>
            </ErrorCRP214>             
          </xsl:if>	
          <!--CRP215--> 
          <xsl:variable name="ErrorCRP215">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FechaPago">
              <xsl:variable name="postion" select="position()"/> 
              <xsl:value-of select="$postion"/>	
              <xsl:variable name="POSPAGO" select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]" />
              <xsl:if test="(($POSPAGO/@FormaDePagoP != '02') and ($POSPAGO/@FormaDePagoP != '03') and ($POSPAGO/@FormaDePagoP != '04') and ($POSPAGO/@FormaDePagoP != '05') and ($POSPAGO/@FormaDePagoP != '28') and ($POSPAGO/@FormaDePagoP != '29'))">				             
                <xsl:if test="normalize-space($POSPAGO/@CtaBeneficiario) != ''">               
                  <ErrorCRP215>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP215>               
                </xsl:if>
              </xsl:if>
            </xsl:for-each>			
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP215"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP215,'fa'),1,1)">
            <ErrorCRP215>
              <xsl:value-of select="'false'"/>
            </ErrorCRP215>             
          </xsl:if>	
          <!--CRP216-->     
          <xsl:variable name="ErrorCRP216">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FormaDePagoP[. != '03']">
              <xsl:variable name="postion" select="position()"/> 
              <xsl:value-of select="$postion"/>
              <xsl:if test="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@TipoCadPago != ''">
                <ErrorCRP216>
                  <xsl:value-of select="'false'"/>
                </ErrorCRP216> 		
              </xsl:if>					
            </xsl:for-each>			
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP216"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP216,'fa'),1,1)">
            <ErrorCRP216>
              <xsl:value-of select="'false'"/>
            </ErrorCRP216>             
          </xsl:if>	
          
          <!--InicioCRP217 hasta CRP226--> 
          <xsl:if test="count(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado']) &gt; 0">
                
            <!--CRP217--> 
            <xsl:variable name="ErrorCRP217">
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FechaPago[. != '']">
                <xsl:variable name="postionP" select="position()"/> 
                <xsl:value-of select="$postionP"/>			
                <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado']/@MonedaDR[. = 'XXX']">
                  <xsl:variable name="postion" select="position()"/> 
                  <xsl:value-of select="$postion"/>					
                  <ErrorCRP217>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP217> 												
                </xsl:for-each>			
              </xsl:for-each>
            </xsl:variable>	
            <xsl:value-of select="$ErrorCRP217"/>												
            
            <xsl:if test="substring(substring-after($ErrorCRP217,'fa'),1,1)">
              <ErrorCRP217>
                <xsl:value-of select="'false'"/>
              </ErrorCRP217>             
            </xsl:if>			
            
            <!--CRP218-->     
            <xsl:variable name="ErrorCRP218">
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@MonedaP[. != '']">
                <xsl:variable name="postionP" select="position()"/> 
                <xsl:value-of select="$postionP"/>
                <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado']/@MonedaDR[. != '']">
                  <xsl:variable name="postion" select="position()"/> 
                  <xsl:value-of select="$postion"/>
                  <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado'][$postion]/@MonedaDR) != normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/@MonedaP)">
                    <xsl:if test="not(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado'][$postion]/@TipoCambioDR) != ''">
                      <ErrorCRP218>
                        <xsl:value-of select="'false'"/>
                      </ErrorCRP218>
                    </xsl:if>
                  </xsl:if>			
                </xsl:for-each>
              </xsl:for-each>			
            </xsl:variable>	
            <xsl:value-of select="$ErrorCRP218"/>												
            
            <xsl:if test="substring(substring-after($ErrorCRP218,'fa'),1,1)">
              <ErrorCRP218>
                <xsl:value-of select="'false'"/>
              </ErrorCRP218>             
            </xsl:if>	
            
                
            <!--CRP219-->     
            <xsl:variable name="ErrorCRP219">
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@MonedaP[. != '']">
                <xsl:variable name="postionP" select="position()"/> 
                <xsl:value-of select="$postionP"/>
                <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado']/@MonedaDR[. != '']">
                  <xsl:variable name="postion" select="position()"/> 
                  <xsl:value-of select="$postion"/>
                  <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado'][$postion]/@MonedaDR) = normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/@MonedaP)">
                    <xsl:if test="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado'][$postion]/@TipoCambioDR != ''">
                      <ErrorCRP219>
                        <xsl:value-of select="'false'"/>
                      </ErrorCRP219>
                    </xsl:if>
                  </xsl:if>	
                </xsl:for-each>
              </xsl:for-each>			
            </xsl:variable>	
            <xsl:value-of select="$ErrorCRP219"/>												
            
            <xsl:if test="substring(substring-after($ErrorCRP219,'fa'),1,1)">
              <ErrorCRP219>
                <xsl:value-of select="'false'"/>
              </ErrorCRP219>             
            </xsl:if>
                
            <!--CRP220-->     
            <xsl:variable name="ErrorCRP220">
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@MonedaP[. != 'MXN']">
                <xsl:variable name="postionP" select="position()"/> 
                <xsl:value-of select="$postionP"/>
                <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado']/@MonedaDR[. != '']">
                  <xsl:variable name="postion" select="position()"/> 
                  <xsl:value-of select="$postion"/>
                  <xsl:if test="((normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado'][$postion]/@MonedaDR) = 'MXN') and (/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/@MonedaP != 'MXN'))">					
                    <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado'][$postion]/@TipoCambioDR) != '1'">	
                      <ErrorCRP220>
                        <xsl:value-of select="'false'"/>
                      </ErrorCRP220>
                    </xsl:if>
                  </xsl:if>			
                </xsl:for-each>
              </xsl:for-each>			
            </xsl:variable>	
            <xsl:value-of select="$ErrorCRP220"/>												
            
            <xsl:if test="substring(substring-after($ErrorCRP220,'fa'),1,1)">
              <ErrorCRP220>
                <xsl:value-of select="'false'"/>
              </ErrorCRP220>             
            </xsl:if>
            
            <!--CRP221--> 
            <xsl:variable name="ErrorCRP221">
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FechaPago[. != '']">
                <xsl:variable name="postionP" select="position()"/> 
                <xsl:value-of select="$postionP"/>			
                <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado']/@ImpSaldoAnt[. &lt;= 0]">
                  <xsl:variable name="postion" select="position()"/> 
                  <xsl:value-of select="$postion"/>					
                  <ErrorCRP221>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP221> 												
                </xsl:for-each>			
              </xsl:for-each>
            </xsl:variable>	
            <xsl:value-of select="$ErrorCRP221"/>												
            
            <xsl:if test="substring(substring-after($ErrorCRP221,'fa'),1,1)">
              <ErrorCRP221>
                <xsl:value-of select="'false'"/>
              </ErrorCRP221>             
            </xsl:if>                        
            
            
            <!--CRP222MXN-->     
            <xsl:variable name="ErrorCRP222">
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado']/@MonedaDR[. = 'MXN']">
                <xsl:variable name="postion" select="position()"/> 
                <xsl:value-of select="$postion"/>
                <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoAnt) != ''">					           
                  <xsl:if test="substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoAnt,'.') != ''">
                    <xsl:if test="substring(substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoAnt,'.'),3,1)">					
                      <ErrorCRP222><xsl:value-of select="'false'" /></ErrorCRP222> 
                    </xsl:if>	 					
                  </xsl:if>		
                  
                  <xsl:if test="((substring-before(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoAnt,'.') != '') and not((substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoAnt,'.')) != ''))">						
                    <ErrorCRP222><xsl:value-of select="'false'" /></ErrorCRP222> 						       
                  </xsl:if>													
                </xsl:if>					
              </xsl:for-each>			
            </xsl:variable>	
            <xsl:value-of select="$ErrorCRP222"/>												
            
            <xsl:if test="substring(substring-after($ErrorCRP222,'fa'),1,1)">
              <ErrorCRP222>
                <xsl:value-of select="'false'"/>
              </ErrorCRP222>             
            </xsl:if>

            <!--CRP222USD-->     
            <xsl:variable name="ErrorCRP222USD">
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado']/@MonedaDR[. = 'USD']">
                <xsl:variable name="postion" select="position()"/> 
                <xsl:value-of select="$postion"/>
                <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoAnt) != ''">					           
                  <xsl:if test="substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoAnt,'.') != ''">
                    <xsl:if test="substring(substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoAnt,'.'),3,1)">					
                      <ErrorCRP222USD><xsl:value-of select="'false'" /></ErrorCRP222USD> 
                    </xsl:if>	 					
                  </xsl:if>		
                  
                  <xsl:if test="((substring-before(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoAnt,'.') != '') and not((substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoAnt,'.')) != ''))">						
                    <ErrorCRP222USD><xsl:value-of select="'false'" /></ErrorCRP222USD> 						       
                  </xsl:if>													
                </xsl:if>					
              </xsl:for-each>			
            </xsl:variable>	
            <xsl:value-of select="$ErrorCRP222USD"/>												
            
            <xsl:if test="substring(substring-after($ErrorCRP222USD,'fa'),1,1)">
              <ErrorCRP222USD>
                <xsl:value-of select="'false'"/>
              </ErrorCRP222USD>             
            </xsl:if>
            
            <!--CRP223--> 
            <xsl:variable name="ErrorCRP223">
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FechaPago[. != '']">
                <xsl:variable name="postionP" select="position()"/> 
                <xsl:value-of select="$postionP"/>			
                <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado']/@ImpPagado[. &lt;= 0]">
                  <xsl:variable name="postion" select="position()"/> 
                  <xsl:value-of select="$postion"/>					
                  <ErrorCRP223>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP223> 												
                </xsl:for-each>			
              </xsl:for-each>
            </xsl:variable>	
            <xsl:value-of select="$ErrorCRP223"/>												
            
            <xsl:if test="substring(substring-after($ErrorCRP223,'fa'),1,1)">
              <ErrorCRP223>
                <xsl:value-of select="'false'"/>
              </ErrorCRP223>             
            </xsl:if>
            

            <!--CRP224-->     
            <xsl:variable name="ErrorCRP224">
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado']/@MonedaDR[. = 'MXN']">
                <xsl:variable name="postion" select="position()"/> 
                <xsl:value-of select="$postion"/>
                <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpPagado) != ''">					           
                  <xsl:if test="substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpPagado,'.') != ''">
                    <xsl:if test="substring(substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpPagado,'.'),3,1)">					
                      <ErrorCRP224><xsl:value-of select="'false'" /></ErrorCRP224> 
                    </xsl:if>	 					
                  </xsl:if>		
                  
                  <xsl:if test="((substring-before(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpPagado,'.') != '') and not((substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpPagado,'.')) != ''))">						
                    <ErrorCRP224><xsl:value-of select="'false'" /></ErrorCRP224> 						       
                  </xsl:if>													
                </xsl:if>					
              </xsl:for-each>			
            </xsl:variable>	
            <xsl:value-of select="$ErrorCRP224"/>												
            
            <xsl:if test="substring(substring-after($ErrorCRP224,'fa'),1,1)">
              <ErrorCRP224>
                <xsl:value-of select="'false'"/>
              </ErrorCRP224>             
            </xsl:if>
            
            <!--CRP224USD-->     
            <xsl:variable name="ErrorCRP224USD">
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado']/@MonedaDR[. = 'USD']">
                <xsl:variable name="postion" select="position()"/> 
                <xsl:value-of select="$postion"/>
                <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpPagado) != ''">					           
                  <xsl:if test="substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpPagado,'.') != ''">
                    <xsl:if test="substring(substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpPagado,'.'),3,1)">					
                      <ErrorCRP224USD><xsl:value-of select="'false'" /></ErrorCRP224USD> 
                    </xsl:if>	 					
                  </xsl:if>		
                  
                  <xsl:if test="((substring-before(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpPagado,'.') != '') and not((substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpPagado,'.')) != ''))">						
                    <ErrorCRP224USD><xsl:value-of select="'false'" /></ErrorCRP224USD> 						       
                  </xsl:if>													
                </xsl:if>					
              </xsl:for-each>			
            </xsl:variable>	
            <xsl:value-of select="$ErrorCRP224USD"/>												
            
            <xsl:if test="substring(substring-after($ErrorCRP224USD,'fa'),1,1)">
              <ErrorCRP224USD>
                <xsl:value-of select="'false'"/>
              </ErrorCRP224USD>             
            </xsl:if>
            
            <!--CRP225-->     
            <xsl:variable name="ErrorCRP225">
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado']/@MonedaDR[. = 'MXN']">
                <xsl:variable name="postion" select="position()"/> 
                <xsl:value-of select="$postion"/>
                <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoInsoluto) != ''">					           
                  <xsl:if test="substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoInsoluto,'.') != ''">
                    <xsl:if test="substring(substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoInsoluto,'.'),3,1)">					
                      <ErrorCRP225><xsl:value-of select="'false'" /></ErrorCRP225> 
                    </xsl:if>	 					
                  </xsl:if>		
                  
                  <xsl:if test="((substring-before(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoInsoluto,'.') != '') and not((substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoInsoluto,'.')) != ''))">						
                    <ErrorCRP225><xsl:value-of select="'false'" /></ErrorCRP225> 						       
                  </xsl:if>													
                </xsl:if>					
              </xsl:for-each>			
            </xsl:variable>	
            <xsl:value-of select="$ErrorCRP225"/>												
            
            <xsl:if test="substring(substring-after($ErrorCRP225,'fa'),1,1)">
              <ErrorCRP225>
                <xsl:value-of select="'false'"/>
              </ErrorCRP225>             
            </xsl:if>
            
            <!--CRP225USD-->     
            <xsl:variable name="ErrorCRP225USD">
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado']/@MonedaDR[. = 'USD']">
                <xsl:variable name="postion" select="position()"/> 
                <xsl:value-of select="$postion"/>
                <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoInsoluto) != ''">					           
                  <xsl:if test="substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoInsoluto,'.') != ''">
                    <xsl:if test="substring(substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoInsoluto,'.'),3,1)">					
                      <ErrorCRP225USD><xsl:value-of select="'false'" /></ErrorCRP225USD> 
                    </xsl:if>	 					
                  </xsl:if>		
                  
                  <xsl:if test="((substring-before(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoInsoluto,'.') != '') and not((substring-after(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoInsoluto,'.')) != ''))">						
                    <ErrorCRP225USD><xsl:value-of select="'false'" /></ErrorCRP225USD> 						       
                  </xsl:if>													
                </xsl:if>					
              </xsl:for-each>			
            </xsl:variable>	
            <xsl:value-of select="$ErrorCRP225USD"/>												
            
            <xsl:if test="substring(substring-after($ErrorCRP225USD,'fa'),1,1)">
              <ErrorCRP225USD>
                <xsl:value-of select="'false'"/>
              </ErrorCRP225USD>             
            </xsl:if>
            
            <!--CRP226-->     
            <xsl:variable name="ErrorCRP226">
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FechaPago[. != '']">
                <xsl:variable name="postion" select="position()"/> 
                <xsl:value-of select="$postion"/>
                <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/*[local-name()='DoctoRelacionado']/@ImpSaldoInsoluto) != ''">
                  <xsl:variable name="SUMImpPagado">
                    <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/*[local-name()='DoctoRelacionado']/@ImpPagado) != ''">
                      <SUMImpPagado>								
                        <xsl:value-of select="format-number(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/*[local-name()='DoctoRelacionado']/@ImpPagado, '######.00')" />
                      </SUMImpPagado>
                    </xsl:if>
                    <xsl:if test="not(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/*[local-name()='DoctoRelacionado']/@ImpPagado) != ''">
                      <SUMImpPagado>
                        <xsl:value-of select="format-number(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@Monto, '######.00')" />
                      </SUMImpPagado>
                    </xsl:if>
                  </xsl:variable>                  
                  <xsl:variable name="SUMSaldoAnt" select="format-number(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/*[local-name()='DoctoRelacionado']/@ImpSaldoAnt, '######.00')" />                  
                  <xsl:variable name="SUMSaldoInsoluto" select="format-number(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/*[local-name()='DoctoRelacionado']/@ImpSaldoInsoluto, '######.00')" />                 
                  <xsl:variable name="SUMVari" select="$SUMSaldoAnt - $SUMImpPagado" />                  
                  <xsl:if test="(((/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/*[local-name()='DoctoRelacionado']/@ImpSaldoInsoluto) &lt; 0) or ($SUMSaldoInsoluto != $SUMVari))">
                    <ErrorCRP226>
                      <xsl:value-of select="'false'"/>
                    </ErrorCRP226> 		
                  </xsl:if>
                </xsl:if>					
              </xsl:for-each>			
            </xsl:variable>	
            <xsl:value-of select="$ErrorCRP226"/>												
            
            <xsl:if test="substring(substring-after($ErrorCRP226,'fa'),1,1)">
              <ErrorCRP226>
                <xsl:value-of select="'false'"/>
              </ErrorCRP226>             
            </xsl:if>	
            

          </xsl:if> <!--Cierre desde la 17 hasta la 26-->
          <!--CRP227-->     
          <xsl:variable name="ErrorCRP227">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@TipoCadPago[. != '']">
              <xsl:variable name="postion" select="position()"/> 
              <xsl:value-of select="$postion"/>
              <xsl:if test="not(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@CertPago) != ''">
                <ErrorCRP227>
                  <xsl:value-of select="'false'"/>
                </ErrorCRP227> 		
              </xsl:if>					
            </xsl:for-each>			
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP227"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP227,'fa'),1,1)">
            <ErrorCRP227>
              <xsl:value-of select="'false'"/>
            </ErrorCRP227>             
          </xsl:if>	
          <!--CRP228-->     
          <xsl:variable name="ErrorCRP228">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@CertPago[. != '']">
              <xsl:variable name="postion" select="position()"/> 
              <xsl:value-of select="$postion"/>
              <xsl:if test="not(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@TipoCadPago) != ''">
                <ErrorCRP228>
                  <xsl:value-of select="'false'"/>
                </ErrorCRP228> 		
              </xsl:if>					
            </xsl:for-each>			
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP228"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP228,'fa'),1,1)">
            <ErrorCRP228>
              <xsl:value-of select="'false'"/>
            </ErrorCRP228>             
          </xsl:if>	
          <!--CRP229-->     
          <xsl:variable name="ErrorCRP229">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@TipoCadPago[. != '']">
              <xsl:variable name="postion" select="position()"/> 
              <xsl:value-of select="$postion"/>
              <xsl:if test="not(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@CadPago) != ''">
                <ErrorCRP229>
                  <xsl:value-of select="'false'"/>
                </ErrorCRP229> 		
              </xsl:if>					
            </xsl:for-each>			
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP229"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP229,'fa'),1,1)">
            <ErrorCRP229>
              <xsl:value-of select="'false'"/>
            </ErrorCRP229>             
          </xsl:if>	
          <!--CRP230-->     
          <xsl:variable name="ErrorCRP230">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@CadPago[. != '']">
              <xsl:variable name="postion" select="position()"/> 
              <xsl:value-of select="$postion"/>
              <xsl:if test="not(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@TipoCadPago) != ''">
                <ErrorCRP230>
                  <xsl:value-of select="'false'"/>
                </ErrorCRP230> 		
              </xsl:if>					
            </xsl:for-each>			
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP230"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP230,'fa'),1,1)">
            <ErrorCRP230>
              <xsl:value-of select="'false'"/>
            </ErrorCRP230>             
          </xsl:if>	
          <!--CRP231-->     
          <xsl:variable name="ErrorCRP231">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@TipoCadPago[. != '']">
              <xsl:variable name="postion" select="position()"/> 
              <xsl:value-of select="$postion"/>
              <xsl:if test="not(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@SelloPago) != ''">
                <ErrorCRP231>
                  <xsl:value-of select="'false'"/>
                </ErrorCRP231> 		
              </xsl:if>					
            </xsl:for-each>			
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP231"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP231,'fa'),1,1)">
            <ErrorCRP231>
              <xsl:value-of select="'false'"/>
            </ErrorCRP231>             
          </xsl:if>	
          <!--CRP232-->     
          <xsl:variable name="ErrorCRP232">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@SelloPago[. != '']">
              <xsl:variable name="postion" select="position()"/> 
              <xsl:value-of select="$postion"/>
              <xsl:if test="not(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@TipoCadPago) != ''">
                <ErrorCRP232>
                  <xsl:value-of select="'false'"/>
                </ErrorCRP232> 		
              </xsl:if>					
            </xsl:for-each>			
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP232"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP232,'fa'),1,1)">
            <ErrorCRP232>
              <xsl:value-of select="'false'"/>
            </ErrorCRP232>             
          </xsl:if>	
          <xsl:if test="count(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='DoctoRelacionado']) &gt; 0">
            <!--CRP233--> 
            <xsl:variable name="ErrorCRP233">
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FechaPago[. != '']">
                <xsl:variable name="postionP" select="position()"/> 
                <xsl:value-of select="$postionP"/>			
                <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado']/@MetodoDePagoDR[. = 'PPD']">
                  <xsl:variable name="postion" select="position()"/> 
                  <xsl:value-of select="$postion"/>
                  <xsl:if test="not(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado'][$postion]/@NumParcialidad) != ''">
                    <ErrorCRP233>
                      <xsl:value-of select="'false'"/>
                    </ErrorCRP233> 		
                  </xsl:if>					
                </xsl:for-each>			
              </xsl:for-each>
            </xsl:variable>	
            <xsl:value-of select="$ErrorCRP233"/>												
            
            <xsl:if test="substring(substring-after($ErrorCRP233,'fa'),1,1)">
              <ErrorCRP233>
                <xsl:value-of select="'false'"/>
              </ErrorCRP233>             
            </xsl:if>			
            

            <!--CRP234--> 
            <xsl:variable name="ErrorCRP234">
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FechaPago[. != '']">
                <xsl:variable name="postionP" select="position()"/> 
                <xsl:value-of select="$postionP"/>			
                <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado']/@MetodoDePagoDR[. = 'PPD']">
                  <xsl:variable name="postion" select="position()"/> 
                  <xsl:value-of select="$postion"/>
                  <xsl:if test="not(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoAnt) != ''">
                    <ErrorCRP234>
                      <xsl:value-of select="'false'"/>
                    </ErrorCRP234> 		
                  </xsl:if>					
                </xsl:for-each>			
              </xsl:for-each>
            </xsl:variable>	
            <xsl:value-of select="$ErrorCRP234"/>												
            
            <xsl:if test="substring(substring-after($ErrorCRP234,'fa'),1,1)">
              <ErrorCRP234>
                <xsl:value-of select="'false'"/>
              </ErrorCRP234>             
            </xsl:if>			
           
            <!--CRP235--> 
            <xsl:variable name="ErrorCRP235">
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FechaPago[. != '']">
                <xsl:variable name="postionP" select="position()"/> 
                <xsl:value-of select="$postionP"/>			
                <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado']/@IdDocumento[. != '']">
                  <xsl:variable name="postion" select="position()"/> 
                  <xsl:value-of select="$postion"/>
                  <xsl:if test="count(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado']) &gt; 1">
                    <xsl:if test="not(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado'][$postion]/@ImpPagado) != ''">
                      <ErrorCRP235>
                        <xsl:value-of select="'false'"/>
                      </ErrorCRP235> 	
                    </xsl:if>
                  </xsl:if>	
                  <xsl:if test="count(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado']) = 1">
                    <xsl:if test="(((/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado'][$postion]/@TipoCambioDR) != '') and (not(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado'][$postion]/@ImpPagado) != ''))">
                      <ErrorCRP235>
                        <xsl:value-of select="'false'"/>
                      </ErrorCRP235> 	
                    </xsl:if>
                  </xsl:if>														
                  
                </xsl:for-each>			
              </xsl:for-each>
            </xsl:variable>	
            <xsl:value-of select="$ErrorCRP235"/>												
            
            <xsl:if test="substring(substring-after($ErrorCRP235,'fa'),1,1)">
              <ErrorCRP235>
                <xsl:value-of select="'false'"/>
              </ErrorCRP235>             
            </xsl:if>			

            <!--CRP236-->                                               
            <xsl:variable name="ErrorCRP236">
              <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FechaPago[. != '']">
                <xsl:variable name="postionP" select="position()"/> 
                <xsl:value-of select="$postionP"/>			
                <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado']/@MetodoDePagoDR[. = 'PPD']">
                  <xsl:variable name="postion" select="position()"/> 
                  <xsl:value-of select="$postion"/>
                  <xsl:if test="not(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postionP]/*[local-name()='DoctoRelacionado'][$postion]/@ImpSaldoInsoluto) != ''">
                    <ErrorCRP236>
                      <xsl:value-of select="'false'"/>
                    </ErrorCRP236> 		
                  </xsl:if>					
                </xsl:for-each>			
              </xsl:for-each>
            </xsl:variable>	
            <xsl:value-of select="$ErrorCRP236"/>												
            
            <xsl:if test="substring(substring-after($ErrorCRP236,'fa'),1,1)">
              <ErrorCRP236>
                <xsl:value-of select="'false'"/>
              </ErrorCRP236>             
            </xsl:if>
          </xsl:if> <!--Desde la 33 hasta la 36-->    
          <!--CRP237-->
          <xsl:if test="count(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='Impuestos']) &gt; 0">
            <ErrorCRP237>
              <xsl:value-of select="'false'"/>
            </ErrorCRP237>
          </xsl:if>
          <!--CRP238--> 
          <xsl:variable name="ErrorCRP238">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@FechaPago">
              <xsl:variable name="postion" select="position()"/> 
              <xsl:value-of select="$postion"/>	
              <xsl:variable name="POSPAGO" select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]" />
              <xsl:if test="(($POSPAGO/@FormaDePagoP != '02') and ($POSPAGO/@FormaDePagoP != '03') and ($POSPAGO/@FormaDePagoP != '04') and ($POSPAGO/@FormaDePagoP != '05') and ($POSPAGO/@FormaDePagoP != '06') and ($POSPAGO/@FormaDePagoP != '28') and ($POSPAGO/@FormaDePagoP != '29'))">				             
                <xsl:if test="normalize-space($POSPAGO/@RfcEmisorCtaOrd) != ''">               
                  <ErrorCRP238>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP238>               
                </xsl:if>
              </xsl:if>
            </xsl:for-each>			
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP238"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP238,'fa'),1,1)">
            <ErrorCRP238>
              <xsl:value-of select="'false'"/>
            </ErrorCRP238>             
          </xsl:if>	
          
          <!--StartCRP239--> 			
          <xsl:variable name="ErrorCRP239">
            <xsl:for-each select="/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/@CtaBeneficiario[. != '']">
              <xsl:variable name="postion" select="position()"/> 
              <xsl:value-of select="$postion"/>
              
              <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@FormaDePagoP) = '02'">
                <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@CtaBeneficiario,'^([0-9]{10,11})$|^([0-9]{15,16})$|^([0-9]{18})$|^([A-Z0-9_]{10,50})$'))">
                  <ErrorCRP239>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP239>               
                </xsl:if>
              </xsl:if>
              <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@FormaDePagoP) = '03'">
                <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@CtaBeneficiario,'^([0-9]{10})$|^([0-9]{18})$'))">
                  <ErrorCRP239>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP239>               
                </xsl:if>
              </xsl:if>
              <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@FormaDePagoP) = '04'">
                <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@CtaBeneficiario,'^([0-9]{10,11})$|^([0-9]{15,16})$|^([0-9]{18})$|^([A-Z0-9_]{10,50})$'))">
                  <ErrorCRP239>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP239>               
                </xsl:if>
              </xsl:if>
              <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@FormaDePagoP) = '05'">
                <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@CtaBeneficiario,'^([0-9]{10,11})$|^([0-9]{15,16})$|^([0-9]{18})$|^([A-Z0-9_]{10,50})$'))">
                  <ErrorCRP239>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP239>               
                </xsl:if>
              </xsl:if>
              
              <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@FormaDePagoP) = '28'">
                <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@CtaBeneficiario,'^([0-9]{10,11})$|^([0-9]{15,16})$|^([0-9]{18})$|^([A-Z0-9_]{10,50})$'))">
                  <ErrorCRP239>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP239>               
                </xsl:if>
              </xsl:if>
              <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@FormaDePagoP) = '29'">
                <xsl:if test="not(regexp:test(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago'][$postion]/@CtaBeneficiario,'^([0-9]{10,11})$|^([0-9]{15,16})$|^([0-9]{18})$|^([A-Z0-9_]{10,50})$'))">
                  <ErrorCRP239>
                    <xsl:value-of select="'false'"/>
                  </ErrorCRP239>               
                </xsl:if>
              </xsl:if>
            </xsl:for-each>			
          </xsl:variable>	
          <xsl:value-of select="$ErrorCRP239"/>												
          
          <xsl:if test="substring(substring-after($ErrorCRP239,'fa'),1,1)">
            <ErrorCRP239>
              <xsl:value-of select="'false'"/>
            </ErrorCRP239>             
          </xsl:if>	
          <!--EndCRP239--> 	
          
          
          <!--CRP999-->                  
          <xsl:if test="count(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']) &gt; 0">
            <xsl:if test="normalize-space(/*[local-name()='Comprobante']/*[local-name()='Complemento']/*[local-name()='Pagos']/*[local-name()='Pago']/*[local-name()='Impuestos']/*[local-name()='Traslados']/*[local-name()='Traslado']/@TasaOCuota) != ''">
              <ErrorCRP999>
                <xsl:value-of select="'false'"/>
              </ErrorCRP999>               
            </xsl:if>
          </xsl:if>
      </xsl:if><!--Fin de If para complemento de pago-->
        <!--ENDComplementoDePago-->
        
      </Detail>
      
    </xsl:variable>
  
    <!-- almacenamos el resultado de la validacion -->
    <dp:set-variable name="'var://context/TCore/ResultGenrGen'" value="$ResultGenrGen"/>
    
    <!--ValidaSello302-->	  
    <xsl:if test="normalize-space(dp:variable('var://context/TCore/ResultGenrGen')/Detail/ResultCertif/text()) = 'false'">
      <dp:set-variable name="'var://system/TCore/VariNegocio'" value="'false'"/>      
    </xsl:if>
    <!--Variable que indica si se guarda en la DB error o exitoso-->
    <!--dp:set-variable name="'var://context/TCore/ResultDBT'" value="$ResultDBT"/-->
    
    
    <!-- Validacion del tipoDeComprobante -->
    <!--Cambio en la V3.3 TipoDeComprobante = 'I'-->
    <!--xsl:if test="not(/*[local-name() = 'Comprobante']/@tipoDeComprobante = 'ingreso' and ($CCE/@TipoOperacion = 'A' or $CCE/@TipoOperacion = '2'))"-->
    <xsl:if test="not(/*[local-name() = 'Comprobante']/@TipoDeComprobante = 'I' and ($CCE/@TipoOperacion = 'A' or $CCE/@TipoOperacion = '2'))">
      <comprobante-tipoDeComprobante>
        <xsl:value-of select="'false'"/>
      </comprobante-tipoDeComprobante>
      
    </xsl:if>
    
    
    <!--End New Code-->
    <xsl:variable name="Delta72h" select="date:difference($CFDiDate,$Now)"/>

    <xsl:variable name="AdmitCFDiResult">
      <Detail>
          <xsl:choose>
            <!-- Esta en tiempo de ser procesado ej:2017-01-30T10:30:06-->
              <xsl:when test="starts-with($Delta72h, '-') and (number(substring-before(substring-after($Delta72h,'T'),'H')) &gt;= 1) and (number(substring-before(substring-after(substring-after($Delta72h,'T'),'H'),'M')) &gt;= 4)"><future>false</future></xsl:when>
              <xsl:when test="number(substring-before(substring-after($Delta72h,'P'),'D')) &gt;= 3"><past72>false</past72></xsl:when>
            <xsl:otherwise><inTime>true</inTime></xsl:otherwise>
          </xsl:choose>
        <xsl:call-template name="ParserCFDi"/>
      </Detail>
    </xsl:variable>

    <!-- almacenamos el resultado de la validacion -->
    <dp:set-variable name="'var://context/TCore/AdmitCFDiResult'" value="$AdmitCFDiResult"/>    
    

  </xsl:template>

  <!-- Scan de CFDi -->
  <xsl:template name="ParserCFDi" match="@* | node()">
    <xsl:apply-templates select="@* | node()"/>
  </xsl:template>

  <!-- Ya viene timbrado -->
  <xsl:template name="ProcessTimbreFiscalDigital" match="//*[local-name() = 'TimbreFiscalDigital']">
    <sinTimbre>false</sinTimbre>
  </xsl:template>

 
</xsl:stylesheet>