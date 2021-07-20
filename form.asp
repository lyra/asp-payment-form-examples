<!--
/**
 * Copyright © Lyra Network.
 * This file is part of Lyra ASP payment form example. See COPYING.md for license details.
 *
 * @author    Lyra Network <https://www.lyra.com>
 * @copyright Lyra Network
 * @license   http://www.gnu.org/licenses/gpl.html GNU General Public License (GPL v3)
 */
-->

<% @ Language="VBSCRIPT" CodePage=65001 %>
<!--#include file="lyra_api.asp"-->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="Keywords" content="ASP, payment, secure" /> 
    <meta name="Description" content="V2 payment form example implementation" />
    <meta name="Author" content="Lyra Network" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <title>Lyra - Payment form example</title>

    <link rel="stylesheet" href="./css/lyra.css" type="text/css" />
</head>
<body>
<div id="content">
    <div id="logo">
        <img alt="LYRA" src="./images/lyra.png" />
        <div>
            <h2>Payment script example in ASP<br /><br />Exemple de script de paiement en ASP</h2>
        </div>
    </div>

    <div id="main">
        <p><b>When using for the first time, do not forget to modify the shop ID and the key inside form.asp file.</b></p>
        <p><b>Lors de votre première utilisation, n'oubliez pas de modifier l'identifiant de la boutique et la clé dans le fichier form.asp.</b></p>
        <br /><br />
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

data.Add "vads_site_id", "12345678" 'Store identifier. IMPORTANT: Do not forget to modifiy this field.
key = "1111111111111111" 'PRODUCTION or TEST SHA key. IMPORTANT: Do not forget to modifiy this field.

data.Add "vads_version", "V2" 'Payment form version: V2 is the only possible value.
data.Add "vads_contrib", "ASP_Form_Examples_v2.3.0"
data.Add "vads_ctx_mode", "TEST" 'Context mode : TEST, PRODUCTION.

'Get current UNIX time stamp.
timestamp = getCurrentTime()

data.Add "vads_trans_date", formatDate(timestamp) 'Generate UTC payment date in the format expected by the payment gateway: yyyyMMddHHmmss.
data.Add "vads_page_action", "PAYMENT" 'This field define the action executed by the payment gateway. See gateway documentation for more information.
data.Add "vads_action_mode", "INTERACTIVE" 'This allows to define the bank data acquisition mode: INTERACTIVE, IFRAME.'

'Payment configuration.
'Configuration du paiement.

data.Add "vads_validation_mode", "" 'Validation mode: 0 for automatic, 1 for manual. Let empty to use the Back Office setting.
data.Add "vads_capture_delay", "" 'Capture delay.
data.Add "vads_payment_cards", "" 'List of payment means codes separated by semicolon.

'Payment information.
'Informations du paiement.

data.Add "vads_trans_id", generateTransId(timestamp)
data.Add "vads_amount","1500" 'Set amount as string.
data.Add "vads_currency", "978" 'Currency code in ISO-4217 standard.
data.Add "vads_payment_config", "SINGLE" 'Payment type : SINGLE, MULTI, MULTI_EXT. See the integration documentation for more details.
'data.Add "vads_payment_config", "MULTI:first=5000;count=3;period=30" 'Example of payment in installments.
'data.Add "vads_payment_config", "MULTI_EXT:20120705=3250;20120801=3250;20130105=3250" 'Example of an extended payment in installments.

'Payment page customization.
'Personnalisation de la page de paiement.

'data.Add "vads_language", ""
'data.Add "vads_available_languages", ""
'data.Add "vads_shop_name", ""
'data.Add "vads_shop_url", ""

'Return to shop.
'Retour à la boutique.

data.Add "vads_return_mode", "POST" 'GET, POST.
data.Add "vads_url_return", "http://www.monsite.com/lyra/return.asp"
'data.Add "vads_url_refused", ""
'data.Add "vads_url_referral", ""
'data.Add "vads_url_error", ""
'data.Add "vads_url_success", ""
'data.Add "vads_url_cancel", ""
'data.Add "vads_redirect_success_timeout", "5" 'Time in seconds (0-300) before the buyer is automatically redirected to your website after a successful payment.
'data.Add "vads_redirect_success_message", "Redirection to the shop in few seconds..." 'Message displayed on the payment page prior to redirection after a successful payment.
'data.Add "vads_redirect_error_timeout", "5" 'Time in seconds (0-300) before the buyer is automatically redirected to your website after a declined payment.
'data.Add "vads_redirect_error_message", "Redirection to the shop in few seconds..." 'Message displayed on the payment page prior to redirection after a declined payment.

'Information about customer.
'Informations du client.

'data.Add "vads_cust_email", ""
'data.Add "vads_cust_status", "" 'PRIVATE, COMPANY'
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

'data.Add "vads_ship_to_status", "" 'PRIVATE, COMPANY.
'data.Add "vads_ship_to_type", "" 'RECLAIM_IN_SHOP, RELAY_POINT, RECLAIM_IN_STATION, PACKAGE_DELIVERY_COMPANY, ETICKET.
'data.Add "vads_ship_to_delivery_company_name", "" 'Ex: UPS, La Poste, etc.
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

data.Add "vads_order_id", "CMD-145236" 'ID of the order on your site.
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

sign = Join(BubbleSort(data.Keys, data.Items), "+") & "+" & key 'Test or production key.

data.Add "signature", Hash.hmacSha256(sign, key) 'Encode signature string in HMAC-SHA256. Recommended.
'data.Add "signature", Hash.sha1(sign) 'Encode signature string in SHA1.

'If there is a signature problem during the test phase, uncomment the following line to display the signature in clear.
'En cas de problème de signature durant la phase de test, décommentez la ligne suivante pour afficher la signature en clair.

'response.write(sign)

'Gateway URL. Uncomment the line corresponding to the desired domain.
'URL de la plateforme de paiement. Décommenter la ligne correspondante au domaine souhaité.

'gatewayurl = "https://secure.lyra.com/vads-payment/" 'Lyra gateway URL.
'gatewayurl = "https://e-paiement-securite-bici.com/vads-payment/" 'BNPP IRB gateway URL.
'gatewayurl = "https://clicandpay.groupecdn.fr/vads-payment/" 'Clic&Pay By groupe Crédit du Nord gateway URL.
'gatewayurl = "https://secure.cobroinmediato.tech/vads-payment/" 'Cobro Inmediato gateway URL.
'gatewayurl = "https://epaync.nc/vads-payment/" 'EpayNC gateway URL.
'gatewayurl = "https://secure.innopay.ch/vads-payment/" 'Innopay gateway URL.
'gatewayurl = "https://secure.micuentaweb.pe/vads-payment/" 'Mi Cuenta Web gateway URL.
'gatewayurl = "https://secure.osb.pf/vads-payment/" 'OSB gateway URL.
'gatewayurl = "https://secure.payty.com/vads-payment/" 'Payty gateway URL.
'gatewayurl = "https://secure.payzen.co.in/vads-payment/" 'PayZen In gateway URL.
'gatewayurl = "https://secure.payzen.lat/vads-payment/" 'PayZen Lat gateway URL.
'gatewayurl = "https://secure.payzen.eu/vads-payment/" 'PayZen gateway URL.
'gatewayurl = "https://secure.payzen.com.br/vads-payment/" 'PayZen Brazil gateway URL.
'gatewayurl = "https://scelliuspaiement.labanquepostale.fr/vads-payment/" 'Scellius gateway URL.
'gatewayurl = "https://sogecommerce.societegenerale.eu/vads-payment/" 'Sogecommerce gateway URL.
'gatewayurl = "https://paiement.systempay.fr/vads-payment/" 'Systempay gateway URL.

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
                    <input type="submit" value="Payment by credit card / Paiement par carte bancaire" />
                </td>
            </tr>
            <tr>
                <td align="center">
                    <img class="visuel" alt="VISA" src="./images/visa.png" />
                    <img class="visuel" alt="CB" src="./images/cb.png" />
                    <img class="visuel" alt="MASTERCARD" src="./images/mastercard.png" />
                </td>
            </tr>
        </table>
    </form>
</div>
</div>
</body>
</html>