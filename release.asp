<div id="release">

<div id="version">version du pack: v2.2	
</div>
<hr/>
	<div id="historique" >
		<h2>Historique des versions</h2>
		<label>V2.2 <i>07/2012</i></label>
		<ul>
			<li>Le fichier vads.asp est remplacé par le fichier payzen_api.asp.</li>
			<li>Amélioration de la gestion des caractères spéciaux (' et ") qui généraient une erreur lors de la construction du formulaire.</li>
			<li>Ajout des répertoires images et css</li>
		</ul>
		<label>V2.1 <i>02/2012</i></label>
		<ul>
			<li>Correction du fichier de retour: la détermination du mode de retour se basait sur le champ site_id au lieu de vads_site_id</li>
		</ul>
		<label>V2 <i>01/2012</i></label>
		<ul>
			<li>Utilisation de la fonction sha1.hash qui amène une meilleure gestion des caractères spéciaux.</li>
			<li>Modification de la gestion des dates afin de les envoyer au format UTC.</li>
			<li>Mise à jour de l'URL de la page de paiement.</li>
			<li>Prise en charge du retour en mode GET dans le fichier de retour.</li>
			<li>Ajout du suivi des versions.</li>
		</ul>
		
		<label>V1 <i>05/2011 - version initiale</i></label>
		<br/><p>Contenu du pack:</p>
		<ul> 
			<li>form_V2.asp : Génération du formulaire de paiement V2 à destination de la plateforme Payzen</li>
			<li>retour_V2.asp : Analyse de la réponse du paiement. Ce Fichier ne gère que le mode POST (mode URL serveur)</li>
			<li>vads.asp : Contient les classes utilisées par le script de paiement (notamment la fonction de cryptage sha1)</li>
		</ul>
	</div>
	<div id="footer" align="center">
		Contact: support@payzen.eu 
	</div>
</div>