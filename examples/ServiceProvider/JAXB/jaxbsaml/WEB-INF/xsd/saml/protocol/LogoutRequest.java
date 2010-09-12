//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.10 in JDK 6 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2010.09.09 at 05:58:24 PM CEST 
//


package saml.protocol;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;
import saml.assertion.BaseID;
import saml.assertion.EncryptedElementType;
import saml.assertion.NameIDType;


/**
 * <p>Java class for LogoutRequestType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="LogoutRequestType">
 *   &lt;complexContent>
 *     &lt;extension base="{urn:oasis:names:tc:SAML:2.0:protocol}RequestAbstractType">
 *       &lt;sequence>
 *         &lt;choice>
 *           &lt;element ref="{urn:oasis:names:tc:SAML:2.0:assertion}BaseID"/>
 *           &lt;element ref="{urn:oasis:names:tc:SAML:2.0:assertion}NameID"/>
 *           &lt;element ref="{urn:oasis:names:tc:SAML:2.0:assertion}EncryptedID"/>
 *         &lt;/choice>
 *         &lt;element ref="{urn:oasis:names:tc:SAML:2.0:protocol}SessionIndex" maxOccurs="unbounded" minOccurs="0"/>
 *       &lt;/sequence>
 *       &lt;attribute name="Reason" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="NotOnOrAfter" type="{http://www.w3.org/2001/XMLSchema}dateTime" />
 *     &lt;/extension>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "LogoutRequestType", propOrder = {
    "encryptedID",
    "nameID",
    "baseID",
    "sessionIndices"
})
@XmlRootElement(name = "LogoutRequest")
public class LogoutRequest
    extends RequestAbstractType
{

    @XmlElement(name = "EncryptedID", namespace = "urn:oasis:names:tc:SAML:2.0:assertion")
    protected EncryptedElementType encryptedID;
    @XmlElement(name = "NameID", namespace = "urn:oasis:names:tc:SAML:2.0:assertion")
    protected NameIDType nameID;
    @XmlElement(name = "BaseID", namespace = "urn:oasis:names:tc:SAML:2.0:assertion")
    protected BaseID baseID;
    @XmlElement(name = "SessionIndex")
    protected List<String> sessionIndices;
    @XmlAttribute(name = "Reason")
    protected String reason;
    @XmlAttribute(name = "NotOnOrAfter")
    @XmlSchemaType(name = "dateTime")
    protected XMLGregorianCalendar notOnOrAfter;

    /**
     * Gets the value of the encryptedID property.
     * 
     * @return
     *     possible object is
     *     {@link EncryptedElementType }
     *     
     */
    public EncryptedElementType getEncryptedID() {
        return encryptedID;
    }

    /**
     * Sets the value of the encryptedID property.
     * 
     * @param value
     *     allowed object is
     *     {@link EncryptedElementType }
     *     
     */
    public void setEncryptedID(EncryptedElementType value) {
        this.encryptedID = value;
    }

    /**
     * Gets the value of the nameID property.
     * 
     * @return
     *     possible object is
     *     {@link NameIDType }
     *     
     */
    public NameIDType getNameID() {
        return nameID;
    }

    /**
     * Sets the value of the nameID property.
     * 
     * @param value
     *     allowed object is
     *     {@link NameIDType }
     *     
     */
    public void setNameID(NameIDType value) {
        this.nameID = value;
    }

    /**
     * Gets the value of the baseID property.
     * 
     * @return
     *     possible object is
     *     {@link BaseID }
     *     
     */
    public BaseID getBaseID() {
        return baseID;
    }

    /**
     * Sets the value of the baseID property.
     * 
     * @param value
     *     allowed object is
     *     {@link BaseID }
     *     
     */
    public void setBaseID(BaseID value) {
        this.baseID = value;
    }

    /**
     * Gets the value of the sessionIndices property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the sessionIndices property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getSessionIndices().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link String }
     * 
     * 
     */
    public List<String> getSessionIndices() {
        if (sessionIndices == null) {
            sessionIndices = new ArrayList<String>();
        }
        return this.sessionIndices;
    }

    /**
     * Gets the value of the reason property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getReason() {
        return reason;
    }

    /**
     * Sets the value of the reason property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setReason(String value) {
        this.reason = value;
    }

    /**
     * Gets the value of the notOnOrAfter property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getNotOnOrAfter() {
        return notOnOrAfter;
    }

    /**
     * Sets the value of the notOnOrAfter property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setNotOnOrAfter(XMLGregorianCalendar value) {
        this.notOnOrAfter = value;
    }

}
