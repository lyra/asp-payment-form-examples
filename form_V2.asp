<% @ Language="VBSCRIPT" CodePage=65001 %>
<!--#include file="payzen_api.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr-fr" lang="fr-fr">
<head>
	<title>PAYZEN: Exemple de Formulaire de paiement V2</title>
	<meta name="Keywords" content="ASP"/> 
	<meta name="Description" content="Exemple d'implémentation en ASP du Formulaire de paiement V2"/> 
	<meta name="Author" content="Lyra Network"/>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
	<link rel="stylesheet" href="./css/payzen.css" type="text/css" />
</head>
<body>
<div id="top">
	<div id="logo">
		<img alt="logo_payzen" src="./images/logo_Payzen.png"/>
		<br/>Exemple de Script de paiement en ASP
	</div >

	<div id="button">
	<p><b>Lors de votre première utilisation,<br/>n'oubliez pas de modifier l'identifiant de la boutique et le certificat dans le fichier form_V2.asp </b></p>
	<br/><br/>
 <%
Response.CodePage = 65001
Response.CharSet = "utf-8"
 
'***********************************************************************'
'Initialisation de l'objet qui contiendra l'ensemble des variables du formulaire
Dim data 
Set data = createObject("Scripting.Dictionary")

'***********************************************************************'
'identification du la boutique
'***********************************************************************'
data.Add "vads_site_id", "11111111" 					'identifiant boutique'  	
certif="1111111111111111" 								' valeur du certificat'  	
'***********************************************************************'
'Initialisation des variables d'environnement'
'***********************************************************************'
data.Add "vads_version", "V2"							'Version du formulaire de paiement'
data.Add "vads_ctx_mode", "TEST"						'mode de fonctionnement TEST | PRODUCTION'
data.Add "vads_page_action", "PAYMENT" 
data.Add "vads_validation_mode", ""						'Laisser à vide pour utiliser les paramètres de l'outil de gestion de caisse'
data.Add "vads_capture_delay", ""						'Laisser à vide pour utiliser les paramètres de l'outil de gestion de caisse'
data.Add "vads_payment_cards", ""						'Laisser à vide pour utiliser les paramètres de l'outil de gestion de caisse'
data.Add "vads_contrib", "PACK_ASP_V2.2"
'***********************************************************************'
'Informations sur la transaction'
data.Add "vads_action_mode", "INTERACTIVE" 'INTERACTIVE | SILENT'
data.Add "vads_amount","1500"
data.Add "vads_currency", "978"
data.Add "vads_payment_config", "SINGLE" 'SINGLE | MULTI | MULTI_EXT'
'data.Add "vads_payment_config", "MULTI:first=5000;count=3;period=30" 'Exemple de définition d'un paiement multiple"
'data.Add "vads_payment_config", "MULTI:20120705=3250;20120801=3250;20130105=3250" 'Exemple de définition d'un échéancier"
data.Add "vads_order_id", ""
'data.Add "vads_order_info", ""
'data.Add "vads_order_info2", ""
'data.Add "vads_order_info3", ""
'*****************************************************************'
'Acquisition des données cartes réalisée par le commercant 
'*****************************************************************'
'data.Add "vads_card_number", "4970100000000000"
'data.Add "vads_cvv", "123"
'data.Add "vads_expiry_month", "05"
'data.Add "vads_expiry_year", "2013"
'data.Add "vads_birth_day", "15" 
'data.Add "vads_birth_month", "3" 
'data.Add "vads_birth_year", "1950" 
'***********************************************************************'
'Configuration du retour à la boutique' (facultatif)
'***********************************************************************' 
data.Add "vads_return_mode", "POST" 'GET | POST'
data.Add "vads_url_return", "http://localhost:81/payzen/retour_V2.asp"
'data.Add "vads_url_return", "http://www.monsite.com/payzen/retour_V2.asp"
'data.Add "vads_url_refused", ""
'data.Add "vads_url_referral", ""
'data.Add "vads_url_error", ""
'data.Add "vads_url_success", ""
'data.Add "vads_url_cancel", ""
'data.Add "vads_redirect_success_timeout", "5"
'data.Add "vads_redirect_success_message", "Redirection vers la boutique dans quelques instants"
'data.Add "vads_redirect_error_timeout", "5"
'data.Add "vads_redirect_error_message", "Redirection"
'***********************************************************************' 
'Informations client (facultatif)
'***********************************************************************' 
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
'***********************************************************************' 
'Méthode de livraison (facultatif)
'***********************************************************************' 
'data.Add "vads_ship_to_status", "" 'PRIVATE | COMPANY'
'data.Add "vads_ship_to_type", "" 'RECLAIM_IN_SHOP | RELAY_POINT | RECLAIM_IN_STATION | PACKAGE_DELIVERY_COMPANY | ETICKET'
'data.Add "vads_ship_to_delivery_company_name", "" 'ex:UPS,La Poste, etc..'
'data.Add "vads_shipping_amount", ""
'data.Add "vads_tax_amount", ""
'data.Add "vads_insurance_amount", ""
'***********************************************************************' 
'Adresse de livraison (facultatif)
'***********************************************************************' 
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
'***********************************************************************' 
'Personnalisation de la page de paiement (facultatif)
'***********************************************************************' 
'data.Add "vads_language", ""
'data.Add "vads_available_languages", ""
'data.Add "vads_shop_name", ""
'data.Add "vads_shop_url", ""
'data.Add "vads_theme_config", "CANCEL_FOOTER_MSG_RETURN=Annuler et retourner à la boutique;SUCCESS_FOOTER_MSG_RETURN=retourner à la boutique"
'***********************************************************************'             
'Génération du trans_id et trans_date en fonction de la date et heure'
'***********************************************************************'

' get current UNIX time stamp
timestamp = getCurrentTime() 

data.Add "vads_trans_id", generateTransId(timestamp)
data.Add "vads_trans_date", formatDate(timestamp)

'***********************************************************************'
'Calcul de la signature'	
'***********************************************************************'
sign = "" ' non encoded signature string
For Each key in data
		data.Item(key) = EncodeUTF8(data.Item(key))
	Next
sign = Join(BubbleSort(data.Keys, data.Items), "+") & "+" & certif ' test or prod certificate

data.Add "signature", Sha1.hash(sign, true) ' encode signature string 


'En cas de problème de signature durant la phase de test, décommentez la ligne suivante pour afficher la signature en clair.
'response.write (sign) 		


%>
		<form method="post" action="https://secure.payzen.eu/vads-payment/">
			<% For Each key in data %> 
			<input type="hidden" name="<%=key%>"  value="<%=data.Item(key)%>"/>
			<% Next %>
			<table>					
				<tr>
					<td>
						<input type="submit" name="Paiement sécurisé" value="Paiement sécurisé par Carte Bancaire"/>
					</td>
				</tr>
				<tr>
					<td align="center">
						<img class="visuel" alt="logo_visa.gif" src="images/logo_visa.gif"/>
						<img class="visuel" alt="logo_cb.gif" src="images/logo_cb.gif"/>					
						<img class="visuel" alt="logo_mastercard.gif" src="images/logo_mastercard.gif"/>
						<img class="visuel" alt="e-cartebleue.gif" src="images/e-cartebleue.gif"/>
					</td>
				</tr>
			</table>
		</form>

	</div>
</div>

<!--#include file="release.asp"-->
</body>
</html>