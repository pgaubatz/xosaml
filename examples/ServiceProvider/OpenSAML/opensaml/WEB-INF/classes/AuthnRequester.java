import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;

import org.joda.time.DateTime;

import org.apache.velocity.*;
import org.apache.velocity.app.*;
import org.apache.velocity.runtime.*;

import org.opensaml.*;
import org.opensaml.common.*;
import org.opensaml.common.binding.*;
import org.opensaml.saml2.common.*;
import org.opensaml.saml2.core.*;
import org.opensaml.saml2.core.impl.*;
import org.opensaml.saml2.binding.encoding.*;
import org.opensaml.saml2.metadata.*;
import org.opensaml.saml2.metadata.impl.*;
import org.opensaml.ws.transport.http.*;
import org.opensaml.xml.io.*;

import org.w3c.dom.*;

import org.apache.velocity.app.VelocityEngine;
import org.apache.velocity.runtime.RuntimeConstants;

import org.opensaml.DefaultBootstrap;
import org.opensaml.xml.ConfigurationException;


public class AuthnRequester extends HttpServlet {
	
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        //res.setContentType("text/html");

		try {
			DefaultBootstrap.bootstrap();
			
			IssuerBuilder ib = new IssuerBuilder();
			Issuer issuer = ib.buildObject();
			
			issuer.setValue("http://localhost:8080/opensaml/Metadata.xml");
			
			AuthnRequestBuilder ab = new AuthnRequestBuilder();
			AuthnRequest request = ab.buildObject();
			
			request.setVersion(SAMLVersion.VERSION_20);
			request.setIssueInstant(new DateTime());
			request.setID("identifier_1");
			request.setForceAuthn(true);
			request.setIssuer(issuer);
			
			AssertionConsumerServiceBuilder eb = new AssertionConsumerServiceBuilder();
			Endpoint endpoint = eb.buildObject();
			
			endpoint.setLocation("http://localhost/~patailama/simplesaml/saml2/idp/SSOService.php");
			
			SAMLMessageContext<SAMLObject, AuthnRequest, NameID> context = new BasicSAMLMessageContext<SAMLObject, AuthnRequest, NameID>();
			
			context.setOutboundMessageTransport(new HttpServletResponseAdapter(res, false));
			context.setPeerEntityEndpoint(endpoint);
			context.setOutboundSAMLMessage(request);
			context.setRelayState(req.getRequestURI());
			
			VelocityEngine velocityEngine = new VelocityEngine();
			velocityEngine.setProperty(RuntimeConstants.RESOURCE_LOADER, "classpath");
			velocityEngine.setProperty("classpath.resource.loader.class", "org.apache.velocity.runtime.resource.loader.ClasspathResourceLoader");
			velocityEngine.init();
			
			HTTPPostEncoder encoder = new HTTPPostEncoder(velocityEngine, "/templates/saml2-post-binding.vm");
			encoder.encode(context);
		}
		catch (Exception e) {
			PrintWriter out = res.getWriter();
			for (StackTraceElement stack : e.getStackTrace()) {
				out.println(stack + "\n");
			}
			out.close();
		}
    }
}



