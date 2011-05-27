<cfsavecontent variable="soapEnvelope">
<SOAP-ENV:Envelope
   xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
   SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"> 
   <SOAP-ENV:Body>
      <m:OrderItem xmlns:m="Some-URI">
      <RetailerID>123456</RetailerID>
      <ItemNumber>789</ItemNumber>
      <ItemName>Really Cool Item</ItemName>
      <ItemDesc>This item is the coolest</ItemDesc>
      <OrderQuantity>100</OrderQuantity>
      <WholesalePrice>14.99</WholeSalePrice>
      <OrderDateTime><cfoutput>#dateFormat(now(),"MM/DD/yyyy")# #timeFormat(now(),"HH:DD TT")#</cfoutput></OrderDateTime>
      </m:OrderItem>
   </SOAP-ENV:Body>  
</SOAP-ENV:Envelope>	
</cfsavecontent>

<cfset wsAuth = createObject("component","src.WSAuthenticator").init()>
<cfset signedSOAPEnvelope = wsAuth.addWSAuthentication(soapEnvelope,"username","password")>
<cfdump var="#soapEnvelope#">
<cfdump var="#signedSOAPEnvelope#">