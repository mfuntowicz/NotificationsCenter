<module>

    <!-- Information sur le module -->
    <header>
        <!-- Nom affiché dans la liste des modules -->
        <name>NotificationsPanel</name>        
        <!-- Version du module -->
        <version>0.6.5</version>
        <!-- Dernière version de dofus pour laquelle ce module fonctionne -->
        <dofusVersion>2.6.0</dofusVersion>
        <!-- Auteur du module -->
        <author>Morgan</author>
        <!-- Courte description -->
        <shortDescription>Centre de Notifications</shortDescription>
        <!-- Description détaillée -->
        <description>Centre de notifications, qui affiche les évènements durant la session de jeu dans </description>
	</header>

    <!-- Liste des interfaces du module, avec nom de l'interface, nom du fichier squelette .xml et nom de la classe script d'interface -->
    <uis>
        <ui name="notificationPanel" file="xml/interface.xml" class="ui::NotificationPanelUI" />
		<ui name="NotificationConfig" file="xml/config.xml" class="ui::NotificationConfigUI"/>
    </uis>
    
    <script>NotificationsPanel.swf</script>
    
</module>
