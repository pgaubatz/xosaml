all:
	xjc -b saml.xjb -extension *.xsd
	javac saml/assertion/*.java saml/xmldsig/*.java saml/protocol/*.java saml/xenc/*.java

jar:
	jar -cf saml.jar saml/*
	cp saml.jar ../lib/