package {
	import com.morgan.factory.manager.NotificationManager;
	import com.morgan.factory.manager.OptionsManager;
	import d2api.*
	import d2enums.StrataEnum;
	import d2hooks.CharacterStatsList;
	import d2hooks.GameStart;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import ui.api.API;
	import ui.NotificationConfigUI;
	import ui.NotificationPanelUI;

	public class NotificationsPanel extends Sprite
	{
		//::///////////////////////////////////////////////////////////
		//::// Variables
		//::///////////////////////////////////////////////////////////
		public var systApi : SystemApi;
		public var uiApi : UiApi;
		public var chatApi : ChatApi;
		public var socialApi : SocialApi;
		public var fightApi : FightApi;
		public var exchangeApi : ExchangeApi;
		public var jobsApi : JobsApi;
		public var dataApi : DataApi;
		public var playerApi : PlayedCharacterApi;
		public var partyApi : PartyApi;
		public var fileApi :FileApi;
		public var captureApi : CaptureApi;
		public var configApi : ConfigApi;
		
		public var _include_UI : NotificationPanelUI;
		public var _include_Config_UI: NotificationConfigUI;
		//::///////////////////////////////////////////////////////////
		//::// Méthodes publiques
		//::///////////////////////////////////////////////////////////
		[Module (name = "Ankama_Common")]
		public var module_common : Object;
		
		
		public function main(...params) : void
		{			
			API.chatApi = chatApi;
			API.exchangeApi = exchangeApi;
			API.fightApi = fightApi;
			API.jobsApi = jobsApi;
			API.partyApi = partyApi;
			API.socialApi = socialApi;
			API.systApi = systApi;
			API.uiApi = uiApi;
			API.dataApi = dataApi;
			API.fileApi = fileApi;
			API.captureApi = captureApi;
			API.configApi = configApi;
			API.playerApi = playerApi;
			
			OptionsManager.module_common = module_common;

			systApi.addHook(GameStart, onStarted);
			
		}
		public function destroy():void {
			NotificationManager.getInstance().finalize();
		}
		public function unload():void {
			NotificationManager.getInstance().finalize();
		}
		public function onStarted():void 
		{
			systApi.removeHook(GameStart);
	
			uiApi.loadUi("notificationPanel", "NotificationPanelInstance", null);
			OptionsManager.getInstance();
			module_common.addOptionItem("notifications", "Notifications", "Ces options permettent de paramétrer le centre de notifications", "NotificationsPanel::NotificationConfig" );
		}
		//::///////////////////////////////////////////////////////////
		//::// Evenements
		//::///////////////////////////////////////////////////////////
	}
}
