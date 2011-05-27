<cfcomponent output="false">
	<cffunction name="init" access="public" output="false">
		<cfscript>
		// Create Java Objects from xmlsec and wss4j
		variables.WSConstantsObj = CreateObject("Java","org.apache.ws.security.WSConstants");
		variables.messagePkg = CreateObject("Java","org.apache.ws.security.message.WSSAddUsernameToken");
		return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="getMessage" access="private" output="false">
		<cfscript>
		if (!structKeyExists(variables,"messagePkg")){
			init();
		}	
		return variables.messagePkg;
		</cfscript>
	</cffunction>
	
	<cffunction name="getWSConstants" access="private" output="false">
		<cfscript>
		if (!structKeyExists(variables,"WSConstantsObj")){
			init();
		}	
		return variables.WSConstantsObj;
		</cfscript>
	</cffunction>	
	
	<cffunction name="addWSAuthentication"  access="public" output="false" hint="I sign SOAP envelope using WS Authentication">
		<cfargument name="soapEnvelope" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="false">
		<cfscript>
		// Get Soap Envlope document for Java processing
		var msg = getMessage();
		var WSConstants = getWSConstants();
		var soapEnv = arguments.soapEnvelope;
		var env = soapEnv.getDocumentElement(); 
		var e = "";
		// Set Password type to TEXT (default is DIGEST)
		msg.setPasswordType(WSConstants.PASSWORD_TEXT);
		// Create WS-Security SOAP header using the build method from WSAddUsernameToken
		e = msg.build(env.GetOwnerDocument(),arguments.username,arguments.password);
		// Add the Nonce and Created elements
		msg.addNonce(e);
		msg.addCreated(e);
		// Return the secure xml object 
		return soapEnv;
		</cfscript>
	</cffunction>
	
	<cffunction name="sendSoapRequest" access="public" output="false" hint="I send the SOAP request off retrun the SOAP response">
		<cfargument name="endpoint" type="string" required="true">
		<cfargument name="soapEnvelope" type="any" required="true">
		<cfargument name="soapAction" type="string" required="false" default="">
		<cfset var result = "">
		<cfset var soapEnv = "">
		
		<cfhttp url="#arguments.endpoint#" method="POST" result="result" >
			<cfhttpparam type="Header" name="Accept-Encoding" value="deflate;q=0">
			<cfhttpparam type="Header" name="TE" value="deflate;q=0"> 
			<cfhttpparam type="header" name="SOAPAction" value="""#arguments.soapAction#""">
			<cfhttpparam type="xml" value="#toString(xmlParse(arguments.soapEnvelope))#"/>
		</cfhttp>
		
		<cfreturn result.fileContent>		
	</cffunction>

</cfcomponent>