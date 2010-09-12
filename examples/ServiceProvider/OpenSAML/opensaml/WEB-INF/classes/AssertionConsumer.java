import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.xml.namespace.QName;
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
import org.opensaml.saml2.binding.decoding.*;
import org.opensaml.saml2.metadata.*;
import org.opensaml.saml2.metadata.impl.*;
import org.opensaml.ws.transport.http.*;
import org.opensaml.xml.io.*;
import org.opensaml.xml.XMLObject;
import org.opensaml.xml.schema.XSAny;

import org.w3c.dom.*;

import org.apache.velocity.app.VelocityEngine;
import org.apache.velocity.runtime.RuntimeConstants;

import org.opensaml.DefaultBootstrap;
import org.opensaml.xml.ConfigurationException;

public class AssertionConsumer extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		try {
			SAMLMessageContext<Response, SAMLObject, NameID> context = new BasicSAMLMessageContext<Response, SAMLObject, NameID>();
		
			context.setInboundMessageTransport(new HttpServletRequestAdapter(request));
			HTTPPostDecoder decoder = new HTTPPostDecoder();
			decoder.decode(context);
		
			Response samlResponse = context.getInboundSAMLMessage();
			Assertion samlAssertion = samlResponse.getAssertions().get(0);
			
			AuthnContext ctx = samlAssertion.getAuthnStatements().get(0).getAuthnContext();
			
			String mechanism = "unknown mechanism";
			if (ctx.getAuthnContextClassRef() != null) {
				mechanism = ctx.getAuthnContextClassRef().getAuthnContextClassRef();
			} else if (ctx.getAuthContextDecl() != null) {
				mechanism = ctx.getAuthContextDecl().getTextContent();
			} else if (ctx.getAuthnContextDeclRef() != null) {
				mechanism = ctx.getAuthnContextDeclRef().getAuthnContextDeclRef();
			} 
			
			out.println("<html><body><h1>AssertionConsumer</h1>");
			out.println("<ol>");
			
			out.println("<li>The SAML Response's StatusCode is: <i>" + samlResponse.getStatus().getStatusCode().getValue() + "</i></li>");
			out.println("<li>The Subject has been authenticated via: <i>" + mechanism + "</i></li>");
			out.println("<li>The Session is valid till: <i>" + samlAssertion.getConditions().getNotOnOrAfter() + "</i></li>");
			out.println("</ol>");
			
			out.println("The following Attributes have been found:<ul>");
			for (Statement statement : samlAssertion.getStatements()) {
				if (statement instanceof AttributeStatement) {
					AttributeStatement attributeStatement = (AttributeStatement) statement;
					List<Attribute> attributes = attributeStatement.getAttributes();
					for (Attribute attribute : attributes) {
						out.println("<li> " + attribute.getName() + ":<ul>");
						for (XMLObject value : attribute.getAttributeValues()) {
							out.println("<li>Value: <i>" + value.getDOM().getTextContent() + "</i></li>");
						}
						out.println("</ul></li>");
					}
				}
			}
			out.println("</ul>");
			
			if (!context.getRelayState().isEmpty()) {
				out.println("<b>You may now access the restricted resource: <a href=\"" + context.getRelayState() + "\">" + context.getRelayState() + "</a></b>");							
			}
			
			out.println("</body></html>");
		} 
		catch (Exception e) {
			for (StackTraceElement stack : e.getStackTrace()) {
				out.println(stack + "\n");
			}
		}
		finally {
			out.close();
		}
	}

}



