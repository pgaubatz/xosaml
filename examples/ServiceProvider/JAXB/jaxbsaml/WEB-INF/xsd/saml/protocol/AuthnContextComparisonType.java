//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.10 in JDK 6 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2010.09.09 at 05:58:24 PM CEST 
//


package saml.protocol;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for AuthnContextComparisonType.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="AuthnContextComparisonType">
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *     &lt;enumeration value="exact"/>
 *     &lt;enumeration value="minimum"/>
 *     &lt;enumeration value="maximum"/>
 *     &lt;enumeration value="better"/>
 *   &lt;/restriction>
 * &lt;/simpleType>
 * </pre>
 * 
 */
@XmlType(name = "AuthnContextComparisonType")
@XmlEnum
public enum AuthnContextComparisonType {

    @XmlEnumValue("exact")
    EXACT("exact"),
    @XmlEnumValue("minimum")
    MINIMUM("minimum"),
    @XmlEnumValue("maximum")
    MAXIMUM("maximum"),
    @XmlEnumValue("better")
    BETTER("better");
    private final String value;

    AuthnContextComparisonType(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static AuthnContextComparisonType fromValue(String v) {
        for (AuthnContextComparisonType c: AuthnContextComparisonType.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
