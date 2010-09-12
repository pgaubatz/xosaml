import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.xml.bind.*;
import javax.xml.datatype.*;

import saml.assertion.*;
import saml.protocol.*;

import org.apache.commons.codec.binary.Base64;


public class AuthnRequester extends HttpServlet {
	
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		
		try {
			saml.assertion.ObjectFactory assertionFactory = new saml.assertion.ObjectFactory();
			saml.protocol.ObjectFactory protocolFactory = new saml.protocol.ObjectFactory();
			
			NameIDType issuer = assertionFactory.createNameIDType();
			issuer.setValue("http://localhost:8080/jaxbsaml/Metadata.xml");
			
			GregorianCalendar now = new GregorianCalendar(TimeZone.getTimeZone("UTC"));  
			XMLGregorianCalendar xmlNow = DatatypeFactory.newInstance().newXMLGregorianCalendar(now);  
			
			AuthnRequest req = protocolFactory.createAuthnRequest();
			req.setVersion("2.0");
			req.setID("identifier_1");
			req.setForceAuthn(true);
			req.setIssuer(issuer);
			req.setIssueInstant(xmlNow);
			
			JAXBContext jc = JAXBContext.newInstance("saml.assertion:saml.protocol:saml.xmldsig:saml.xenc");
            Marshaller m = jc.createMarshaller();
			StringWriter w = new StringWriter();
            m.marshal(req, w);
			
			String SAMLRequest = new String(Base64.encodeBase64(w.toString().getBytes()));
			
			out.println("<html><body onload=\"document.forms[0].submit()\">"); 
			out.println("<form method=\"POST\" action=\"http://localhost/~patailama/simplesaml/saml2/idp/SSOService.php\">");
			out.println("<input type=\"hidden\" name=\"SAMLRequest\" value=\"" + SAMLRequest + "\">");
			out.println("<input type=\"hidden\" name=\"RelayState\" value=\"" + request.getRequestURI() + "\">");
			out.println("</form></body></html>");
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



