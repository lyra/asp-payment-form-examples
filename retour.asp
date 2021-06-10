<% @ Language="VBSCRIPT" CodePage=65001 %>
<!--#include file="lyra_api.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr-fr" lang="fr-fr">
<head>
	<title>LYRA: Exemple de Formulaire de paiement V2</title>
	<meta name="Keywords" content="ASP"/> 
	<meta name="Description" content="Exemple d'implémentation en ASP du Formulaire de paiement V2"/> 
	<meta name="Author" content="Lyra Network"/>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
	<link rel="stylesheet" href="./css/lyra.css" type="text/css" />
</head>
<body>
<div id="top">
	<div id="logo">
		<img alt="logo_lyra" src="./images/logo_Lyra.png"/>
		<br/>Exemple de Script de paiement en ASP
	</div >
	<div id="result">
<%
Response.CodePage = 65001
Response.CharSet = "utf-8"
' valeur du certificat'  
'Ici cette valeur est ecrite en dur mais vous devez la lire depuis votre base de données'
certif="1111111111111111"
Session.Contents.RemoveAll()

'-----------------------------------------------------------------------------------' 
'Calcul de la signature avec les paramètres reçus
'-----------------------------------------------------------------------------------'
'Initialisation de la variable 'sign' qui contiendra la signature en clair
signature_shop=""

'-----------------------------------------------------------------------------------' 
'Determination du mode de retour 
'-----------------------------------------------------------------------------------'
IF isEmpty (Request.form("vads_site_id")) THEN
	'L'appel du fichier est en mode GET (retour à la boutique uniquement)'
	
	
	'Boucle qui construit deux tableaux:
	'arrName contenant le nom des champs commencant par 'vads_'
	'arrValue contenant les valeurs des paramètres 'vads_'
	j=0
	For Each i In Request.QueryString 
			IF Left(i, 5) = "vads_" THEN
				
				redim preserve arrName (j)
				redim preserve arrValue (j)
				arrName (j) = i			
				arrValue (j) = Request.QueryString(i)
				j=j+1			
			end if
	Next
ELSE
	'L'appel du fichier est en mode POST (URL serveur ou retour à la boutique)'

	'Boucle qui construit deux tableaux:
	'arrName contenant le nom des champs commencant par 'vads_'
	'arrValue contenant les valeurs des paramètres 'vads_'

	j=0
	For Each i In Request.form 
			IF Left(i, 5) = "vads_" THEN
				
				redim preserve arrName (j)
				redim preserve arrValue (j)
				arrName (j) = i			
				arrValue (j) = Request.form(i)
				j=j+1			
			end if
	Next
END IF

'-----------------------------------------------------------------------------------'
'Construction de la chaîne
'-----------------------------------------------------------------------------------'
'concaténation des paramètres 'vads_' avec le séparateur '+' et ajout du certificat en fin de chaine
signature_shop= Join(BubbleSort(arrName,arrValue),"+") & "+" & certif

' En cas de problème de signature durant la phase de test, décommentez la ligne suivante pour afficher la signature en clair.
'response.write (signature_shop & "<br/>") 		

'Appel de la fonction sha1.hash pour encoder la signature
signature_shop = sha1.hash(signature_shop)

'-----------------------------------------------------------------------------------'
'Comparaison de la signature reçue et celle calculée'
'-----------------------------------------------------------------------------------'
 
IF Request("signature")= signature_shop THEN
	' ok traitement de la commande'
	Response.Write ("Controle Signature ok - Traitement du résultat: <br/>") 
		'le paiement est-il accepté? '
		IF Request("vads_result")= "00" THEN
			Response.Write ("Votre paiement a été accepté <br/>") 
		ELSE 
			Response.Write ("Votre paiement a été refusé (echec autorisation) <br/>")     
   		END IF
 
ELSE  
	'nok ne pas traiter la commande risque de fraude'
	Response.Write ("Controle signature Nok - risque de fraude <br/>Avez-vous bien modifié le certificat dans le fichier retour_V2.asp?") 
		
END IF 
%>
</div>
</div>
</body>
</html> 
