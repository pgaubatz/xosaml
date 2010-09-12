import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.xml.bind.*;
import javax.xml.datatype.*;

import saml.assertion.*;
import saml.protocol.*;

import org.apache.commons.codec.binary.Base64;


public class AssertionConsumer extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		try {
			JAXBContext jc = JAXBContext.newInstance("saml.assertion:saml.protocol:saml.xmldsig:saml.xenc");
            Unmarshaller u = jc.createUnmarshaller();
			
			String res = new String(Base64.decodeBase64(request.getParameter("SAMLResponse").getBytes()));
			Response samlResponse = (Response) u.unmarshal(new StringReader(res));
			
			Assertion samlAssertion = (Assertion) samlResponse.getAssertionsAndEncryptedAssertions().get(0);
			
			List<StatementAbstractType> statements = samlAssertion.getStatementsAndAuthnStatementsAndAuthzDecisionStatements();
			
			AuthnStatement authnStatement = null;
			for (StatementAbstractType statement : statements) {
				if (statement instanceof AuthnStatement) {
					authnStatement = (AuthnStatement) statement;
					break;
				}
			}
			
			AuthnContext ctx = authnStatement.getAuthnContext();
			
			String mechanism = "unknown mechanism";
			if (!ctx.getAuthnContextClassRef().isEmpty()) {
				mechanism = ctx.getAuthnContextClassRef();
			} else if (ctx.getAuthnContextDecl() != null) {
				mechanism = ctx.getAuthnContextDecl().toString();
			} else if (!ctx.getAuthnContextDeclRef().isEmpty()) {
				mechanism = ctx.getAuthnContextDeclRef();
			} 
			
			out.println("<html><body><h1>AssertionConsumer</h1>");
			out.println("<ol>");
			out.println("<li>The SAML Response's StatusCode is: <i>" + samlResponse.getStatus().getStatusCode().getValue() + "</i></li>");
			out.println("<li>The Subject has been authenticated via: <i>" + mechanism + "</i></li>");
			out.println("<li>The Session is valid till: <i>" + samlAssertion.getConditions().getNotOnOrAfter() + "</i></li>");
			out.println("</ol>");
			
			out.println("The following Attributes have been found:<ul>");
			for (StatementAbstractType statement : statements) {
				if (statement instanceof AttributeStatement) {
					AttributeStatement attributeStatement = (AttributeStatement) statement;
					for (Object a : attributeStatement.getAttributesAndEncryptedAttributes()) {
						Attribute attribute = (Attribute) a;
						out.println("<li> " + attribute.getName() + ":<ul>");
						for (Object value : attribute.getAttributeValues()) {
							out.println("<li>Value: <i>" + value.toString() + "</i></li>");
						}
						out.println("</ul></li>");
					}
				}
			}
			out.println("</ul>");
			
			String relayState = request.getParameter("RelayState");
			if (!relayState.isEmpty()) {
				out.println("<b>You may now access the restricted resource: <a href=\"" + relayState + "\">" + relayState + "</a></b>");							
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



