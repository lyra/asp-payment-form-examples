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

﻿<% @ Language="VBSCRIPT" CodePage=65001 %>
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
        <div id="result">
<%
Response.CodePage = 65001
Response.CharSet = "utf-8"

'Key value. Here the value is written in clear but you have to read it from your database.
'Valeur du certificat. Ici la valeur est ecrite en dur mais vous devez la lire depuis votre base de données.

shakey = "1111111111111111"
Session.Contents.RemoveAll()

'Computing the signature with the received parameters.
'Calcul de la signature avec les paramètres reçus.

signature_shop = ""

'Determination of the return mode.
'Détermination du mode de retour.

IF isEmpty (Request.form("vads_site_id")) THEN
    'The call to this file is in GET mode (return to the store only).
    'L'appel du fichier est en mode GET (retour à la boutique uniquement).

    'Loop that builds two arrays:
    'arrName containing the name of fields starting with 'vads_'.
    'arrValue containing the values of the 'vads_' parameters.

    'Boucle qui construit deux tableaux:
    'arrName contenant le nom des champs commencant par 'vads_'.
    'arrValue contenant les valeurs des paramètres 'vads_'.

    j = 0
    For Each i In Request.QueryString
        IF Left(i, 5) = "vads_" THEN
            redim preserve arrName (j)
            redim preserve arrValue (j)
            arrName(j) = i
            arrValue(j) = Request.QueryString(i)
            j = j+1
        end if
    Next
ELSE
    'The file call is in POST mode (server URL or return to the store).
    'L'appel du fichier est en mode POST (URL serveur ou retour à la boutique).

    'Loop that builds two arrays:
    'arrName containing the name of fields starting with 'vads_'.
    'arrValue containing the values of the 'vads_' parameters.

    'Boucle qui construit deux tableaux:
    'arrName contenant le nom des champs commencant par 'vads_'.
    'arrValue contenant les valeurs des paramètres 'vads_'.

    j = 0
    For Each i In Request.form
        IF Left(i, 5) = "vads_" THEN
            redim preserve arrName(j)
            redim preserve arrValue(j)
            arrName(j) = i
            arrValue(j) = Request.form(i)
            j = j+1
        end if
    Next
END IF

'Concatenation of the 'vads_' parameters with the separator '+' and addition of the SHA key at the end of the string.
'Concaténation des paramètres 'vads_' avec le séparateur '+' et ajout de la clé SHA en fin de chaine.

signature_shop = Join(BubbleSort(arrName, arrValue), "+") & "+" & shakey

'If there is a signature problem during the test phase, uncomment the following line to display the signature in clear.
'En cas de problème de signature durant la phase de test, décommentez la ligne suivante pour afficher la signature en clair.

'response.write(signature_shop & "<br />")

'Call of SHA1 or HMAC-SHA256 hash function to encode the signature.
'Appel de la fonction d'encodage SHA1 or HMAC-SHA256 pour encoder la signature.

'Uncomment the line corresponding to the desired signature algorithm. By default, HMAC-SHA256 is used to compute signature.
'Décommenter la ligne correspondante à l'algorithme de signature souhaité. Par défaut, HMAC-SHA256 est utilisé pour calculer la signature.

signature_shop = Hash.hmacSha256(signature_shop, shakey)
'signature_shop = Hash.sha1(signature_shop)

'Comparison of the signature received and the one computed.
'Comparaison de la signature reçue et celle calculée.

IF Request("signature") = signature_shop THEN
    Response.Write("Signature check is OK - Process the payment result:<br />")
    Response.Write("Contrôle de signature OK - Traitement du résultat du paiement:<br />")

    'Is the payment successfull?
    'Le paiement est-il accepté?
    IF Request("vads_result") = "00" THEN
        Response.Write("Your payment is accepted.<br />")
        Response.Write("Votre paiement a été accepté<br />")
    ELSE
        Response.Write("Your payment is refused.<br />")
        Response.Write("Votre paiement a été refusé.<br />")
    END IF
ELSE
    'Do not process the order, fraud risk.
    'Ne pas traiter la commande, risque de fraude.
    Response.Write("Signature check is KO - fraud risk. Did you modify the SHA key in file return.asp?<br />")
    Response.Write("Controle signature KO - risque de fraude. Avez-vous bien modifié la clé SHA dans le fichier return.asp?<br />")
END IF
%>
</div>
</div>
</body>
</html>