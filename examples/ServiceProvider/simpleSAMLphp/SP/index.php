<?php
require_once('../_include.php');

$port = ($_SERVER['SERVER_PORT'] == 80) ? "" : (":" . $_SERVER['SERVER_PORT']);
$hostPort = "http://" . $_SERVER['SERVER_NAME'] . $port;
$scriptUrl = $hostPort . $_SERVER['SCRIPT_NAME'];

$metadataUrl = $scriptUrl . "?Metadata";
$assertionConsumerUrl = $scriptUrl . "?AssertionConsumer";

if (array_key_exists("Metadata", $_REQUEST)) {
?>

	<?xml version="1.0"?>
	<EntityDescriptor xmlns="urn:oasis:names:tc:SAML:2.0:metadata" entityID="<?php echo $metadataUri ?>">
		<SPSSODescriptor protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
			<NameIDFormat>urn:oasis:names:tc:SAML:2.0:nameid-format:transient</NameIDFormat>
			<AssertionConsumerService index="0" Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="<?php echo $assertionConsumerUrl ?>"/>
		</SPSSODescriptor>
	</EntityDescriptor>

<?php
} elseif (array_key_exists("AssertionConsumer", $_REQUEST)) {

	$binding = new SAML2_HTTPPost();
	$response = $binding->receive();

	$status = $response->getStatus();
	$assertions = $response->getAssertions();
	$assertion = $assertions[0];

	echo "<html><body><h1>AssertionConsumer</h1>";
	echo "<ol>";
	echo "<li>The SAML Response's StatusCode is: <i>" . $status['Code'] . "</i></li>";
	echo "<li>The Subject has been authenticated via: <i>" . $assertion->getAuthnContext() . "</i></li>";
	echo "<li>The Session is valid till: <i>" . SimpleSAML_Utilities::generateTimestamp($assertion->getNotOnOrAfter()) . "</i></li>";
	echo "</ol>";

	if (count($assertion->getAttributes())) {
		echo "The following Attributes have been found:<ul>";
		foreach ($assertion->getAttributes() as $name => $values) {
			echo "<li>$name:<ul>";
			foreach ($values as $value) {
				echo "<li>Value: <i>$value</i></li>";
			}
			echo "</ul></li>";
		}
		echo "</ul>";
	}

	if (strlen($response->getRelayState())) {
		echo "<b>You may now access the restricted resource: <a href=\"" . $response->getRelayState() . "\">" . $response->getRelayState() . "</a></b>";
	}
	echo "</body></html>";

} else {

	$IdPUrl = "http://localhost/~patailama/simplesaml/saml2/idp/SSOService.php";

	$request = new SAML2_AuthnRequest();
	$request->setIssuer($metadataUrl);
	$request->setID("identifier_1");
	$request->setForceAuthn(true);
	$request->setRelayState($hostPort . $_SERVER['REQUEST_URI']);

	$binding = new SAML2_HTTPPost();
	$binding->setDestination($IdPUrl);
	$binding->send($request);
}
?>
