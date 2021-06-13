<%--
' Copyright (C) 2011 - 2021 Lyra Network.
' This file is part of Lyra ASP payment form sample.
' See COPYING.md for license details.
'
' @author    Lyra Network <https://www.lyra.com>
' @copyright 2011 - 2021 Lyra Network
' @license   http://www.gnu.org/licenses/gpl.html GNU General Public License (GPL v3)
--%>

<% @ Language="VBSCRIPT" CodePage=65001 %>
<!--#include file="lyra_api.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr-fr" lang="fr-fr">
<head>
	<title>LYRA: Exemple de Formulaire de paiement V2</title>
	<meta name="Keywords" content="ASP" /> 
	<meta name="Description" content="Exemple d'implémentation en ASP du Formulaire de paiement V2" />
	<meta name="Author" content="Lyra Network" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" href="/css/lyra.css" type="text/css" />
</head>
<body>
<div id="top">
	<div id="logo">
		<img alt="LYRA" src="/images/lyra.png" />
		<br/>Exemple de script de paiement en ASP
	</div>

	<div id="button">
	<p><b>Lors de votre première utilisation,<br/>n'oubliez pas de modifier l'identifiant de la boutique et le certificat dans le fichier form.asp </b></p>
	<br/><br/>
<%
Response.CodePage = 65001
Response.CharSet = "utf-8"

'***********************************************************************'
'Prepare form data to be posted to payment gateway.
'Préparation des données du formulaire à poster à la plateforme de paiement.

Dim data
Set data = createObject("Scripting.Dictionary")

'Mandatory parameters.
'Les champs obligatoires.

data.Add "vads_site_id", "11111111" 'Store identifier.
certificate = "1111111111111111" 'Certificate value.

data.Add "vads_version", "V2" 'Payment form version : V2 is the only possible value.'
data.Add "vads_contrib", "ASP_Form_Sample_v2.3.0"
data.Add "vads_ctx_mode", "TEST" 'Context mode : TEST | PRODUCTION.'

'Get current UNIX time stamp.
timestamp = getCurrentTime()

data.Add "vads_trans_date", formatDate(timestamp) 'Generate UTC payment date in the format expected by the payment gateway : yyyyMMddHHmmss.
data.Add "vads_page_action", "PAYMENT" 'This field define the action executed by the payment gateway. See gateway documentation for more information.
data.Add "vads_action_mode", "INTERACTIVE" 'This allows to define the bank data acquisition mode : INTERACTIVE | SILENT.'

'Payment configuration.
'Configuration du paiement.

data.Add "vads_validation_mode", "" 'Validation mode : Automatic | Manual.'
data.Add "vads_capture_delay", "" 'Capture delay.'
data.Add "vads_payment_cards", ""
 
'Payment information.
'Informations du paiement.

data.Add "vads_trans_id", generateTransId(timestamp)
data.Add "vads_amount","1500" 'Set amount as string.
data.Add "vads_currency", "978" 'Currency code in ISO-4217 standard.
data.Add "vads_payment_config", "SINGLE" 'Payment type : SINGLE | MULTI | MULTI_EXT.'
'data.Add "vads_payment_config", "MULTI:first=5000;count=3;period=30" 'Example of payment in installments.
'data.Add "vads_payment_config", "MULTI:20120705=3250;20120801=3250;20130105=3250" 'Example of definition of an installment.

'Payment page customization.
'Personnalisation de la page de paiement.

'data.Add "vads_language", ""
'data.Add "vads_available_languages", ""
'data.Add "vads_shop_name", ""
'data.Add "vads_shop_url", ""

'Return to shop.
'Retour à la boutique.

data.Add "vads_return_mode", "POST" 'GET | POST.
data.Add "vads_url_return", "http://localhost:81/lyra/retour.asp"
'data.Add "vads_url_return", "http://www.monsite.com/lyra/retour.asp"
'data.Add "vads_url_refused", ""
'data.Add "vads_url_referral", ""
'data.Add "vads_url_error", ""
'data.Add "vads_url_success", ""
'data.Add "vads_url_cancel", ""
'data.Add "vads_redirect_success_timeout", "5" 'Time in seconds (0-300) before the buyer is automatically redirected to your website after a successful payment.
'data.Add "vads_redirect_success_message", "Redirection vers la boutique dans quelques instants" 'Message displayed on the payment page prior to redirection after a successful payment.
'data.Add "vads_redirect_error_timeout", "5" 'Time in seconds (0-300) before the buyer is automatically redirected to your website after a declined payment.
'data.Add "vads_redirect_error_message", "Redirection" 'Message displayed on the payment page prior to redirection after a declined payment.

'Information about customer.
'Informations du client.

'data.Add "vads_cust_email", ""
'data.Add "vads_cust_status", "" 'PRIVATE | COMPANY'
'data.Add "vads_cust_id", ""
'data.Add "vads_cust_title", ""
'data.Add "vads_cust_name", ""
'data.Add "vads_cust_first_name", ""
'data.Add "vads_cust_last_name", ""
'data.Add "vads_cust_number_address", ""
'data.Add "vads_cust_address", ""
'data.Add "vads_cust_phone", ""
'data.Add "vads_cust_cell_phone", ""
'data.Add "vads_cust_district", ""
'data.Add "vads_cust_zip", ""
'data.Add "vads_cust_city", ""
'data.Add "vads_cust_state", ""
'data.Add "vads_cust_country", ""

'Delivery method.
'Méthode de livraison.

'data.Add "vads_ship_to_status", "" 'PRIVATE | COMPANY.
'data.Add "vads_ship_to_type", "" 'RECLAIM_IN_SHOP | RELAY_POINT | RECLAIM_IN_STATION | PACKAGE_DELIVERY_COMPANY | ETICKET.
'data.Add "vads_ship_to_delivery_company_name", "" 'ex:UPS, La Poste, etc.
'data.Add "vads_shipping_amount", ""
'data.Add "vads_tax_amount", ""
'data.Add "vads_insurance_amount", ""

'Delivery address.
'Adresse de livraison.

'data.Add "vads_ship_to_name", ""
'data.Add "vads_ship_to_first_name", ""
'data.Add "vads_ship_to_last_name", ""
'data.Add "vads_ship_to_address_number", ""
'data.Add "vads_ship_to_street", ""
'data.Add "vads_ship_to_street2", ""
'data.Add "vads_ship_to_district", ""
'data.Add "vads_ship_to_zip", ""
'data.Add "vads_ship_to_city", ""
'data.Add "vads_ship_to_state", ""
'data.Add "vads_ship_to_country", ""
'data.Add "vads_ship_to_phone_num", ""

'Order information.
'Informations de la commande.

data.Add "vads_order_id", ""
'data.Add "vads_order_info", ""
'data.Add "vads_order_info2", ""
'data.Add "vads_order_info3", ""

'Compute signature.
'Calcul de la signature.

sign = "" 'Not encoded signature string.
For Each key in data
		data.Item(key) = EncodeUTF8(data.Item(key))
	Next

'Uncomment the line corresponding to the desired signature algorithm. By default, HMAC-SHA256 is used to compute signature.
'Décommenter la ligne correspondante à l'algorithme de signature souhaité. Par défaut, HMAC-SHA256 est utilisé pour calculer la signature.

sign = Join(BubbleSort(data.Keys, data.Items), "+") & "+" & certificate 'Test or production certificate.

data.Add "signature", Hmacsha256.hash(sign, certificate) 'Encode signature string.
'data.Add "signature", Sha1.hash(sign, true)

'If there is a signature problem during the test phase, uncomment the following line to display the signature in clear.
'En cas de problème de signature durant la phase de test, décommentez la ligne suivante pour afficher la signature en clair.

'response.write (sign)

'Gateway URL.
'URL de la plateforme de paiement.

'Uncomment the line corresponding to the desired domain. By default, this is the Lyra domain.
'Décommenter la ligne correspondante au domaine souhaité. Par défaut, c'est le domaine Lyra.

gatewayurl = "https://secure.lyra.com/vads-payment/" 'Lyra Gateway URL.
'gatewayurl = "https://e-paiement-securite-bici.com/vads-payment/" 'BNPP IRB Gateway URL.
'gatewayurl = "https://clicandpay.groupecdn.fr/vads-payment/" 'Clic&Pay By groupe Crédit du Nord Gateway URL.
'gatewayurl = "https://secure.cobroinmediato.tech/vads-payment/" 'Cobro Inmediato Gateway URL.
'gatewayurl = "https://epaync.nc/vads-payment/" 'EpayNC Gateway URL.
'gatewayurl = "https://secure.innopay.ch/vads-payment/" 'Innopay Gateway URL.
'gatewayurl = "https://secure.micuentaweb.pe/vads-payment/" 'Mi Cuenta Web Gateway URL.
'gatewayurl = "https://secure.osb.pf/vads-payment/" 'OSB Gateway URL.
'gatewayurl = "https://secure.payty.com/vads-payment/" 'Payty Gateway URL.
'gatewayurl = "https://secure.payzen.co.in/vads-payment/" 'PayZen In Gateway URL.
'gatewayurl = "https://secure.payzen.lat/vads-payment/" 'PayZen Lat Gateway URL.
'gatewayurl = "https://secure.payzen.eu/vads-payment/" 'PayZen Gateway URL.
'gatewayurl = "https://scelliuspaiement.labanquepostale.fr/vads-payment/" 'Scellius Gateway URL.
'gatewayurl = "https://sogecommerce.societegenerale.eu/vads-payment/" 'Sogecommerce Gateway URL.
'gatewayurl = "https://paiement.systempay.fr/vads-payment/" 'Systempay Gateway URL.

'Build payment form and redirect to payment gateway.
'Créer le formulaire de paiement et rediriger vers la plateforme de paiement.
%>
		<form method="post" action="<%=gatewayurl%>">
			<% For Each key in data %>
			<input type="hidden" name="<%=key%>" value="<%=data.Item(key)%>" />
			<% Next %>
			<table>
				<tr>
					<td>
						<input type="submit" name="Paiement sécurisé" value="Paiement sécurisé par Carte Bancaire" />
					</td>
				</tr>
				<tr>
					<td align="center">
						<img class="visuel" alt="VISA" src="/images/visa.png" />
						<img class="visuel" alt="CB" src="/images/cb.png" />
						<img class="visuel" alt="MASTERCARD" src="/images/mastercard.png" />
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>
</body>
</html>
