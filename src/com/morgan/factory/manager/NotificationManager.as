package com.morgan.factory.manager 
{
	import com.morgan.utils.As3PerformancesAnalyzer;
	import d2data.ItemWrapper;
	import d2hooks.ActivateSound;
	import d2hooks.ArenaRegistrationStatusUpdate;
	import d2hooks.AttackPlayer;
	import d2hooks.CharacterLevelUp;
	import d2hooks.ChatServer;
	import d2hooks.ChatServerWithObject;
	import d2hooks.ExchangeRequestCharacterToMe;
	import d2hooks.FriendWarningState;
	import d2hooks.GuildInvited;
	import d2hooks.JobLevelUp;
	import d2hooks.NewMessage;
	import d2hooks.Notification;
	import d2hooks.PartyInvitation;
	import d2hooks.PlayerIsDead;
	import d2hooks.TextInformation;
	import d2network.EntityLook;
	import d2network.ObjectItem;
	import d2data.Notification;
	import d2enums.NotificationTypeEnum;
	import d2utils.ModuleFilestream;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import ui.api.API;
	import com.morgan.factory.NotificationsFactory;
	import com.morgan.factory.types.INotify;
	import com.morgan.factory.types.NotificationTypeEnum;
	import com.morgan.observer.Observable;
	import com.morgan.observer.Observer;
	import com.morgan.utils.StringUtils;
	/**
	 * ...
	 * @author Morgan
	 */
	public class NotificationManager implements Observable
	{
		private static var _self : NotificationManager;
		private var _observers : Vector.<Observer> = new Vector.<Observer>(0, false);
		private var _notifications:Vector.<INotify>;
		private var _notificationsFilters : Dictionary;
		private var _saved : Boolean = false;
		public function NotificationManager() 
		{
			if (_self) {
				throw new Error("NotificationManager is a singleton, use getInstance()");
			}
		}	
		public function init():void {
			_notifications = new Vector.<INotify>();
			_notificationsFilters = new Dictionary(false);
			
			setListeners();
			
		}
		public function setListeners():void {
			API.systApi.addHook(CharacterLevelUp, onLevelUp);
			API.systApi.addHook(ChatServer, onMessage);
			//API.systApi.addHook(ChatServerWithObject, onMessageWithObject);
			API.systApi.addHook(JobLevelUp, onJobLevelUp);
			API.systApi.addHook(CharacterLevelUp, onPlayerLevelUp);
			API.systApi.addHook(GuildInvited, onGuildInvit);
			API.systApi.addHook(ExchangeRequestCharacterToMe, onExchangeRequest);
			API.systApi.addHook(d2hooks.Notification, onNotification);
			API.systApi.addHook(PlayerIsDead, onPlayerDead);
			API.systApi.addHook(ActivateSound, onSoundStateChange);
			API.systApi.addHook(TextInformation, onFriendConnection)
		}
		public function removeListeners():void {
			API.systApi.removeHook(CharacterLevelUp);
			API.systApi.removeHook(ChatServer);
			//API.systApi.removeHook(ChatServerWithObject);
			API.systApi.removeHook(JobLevelUp);
			API.systApi.removeHook(CharacterLevelUp);
			API.systApi.removeHook(GuildInvited);
			API.systApi.removeHook(ExchangeRequestCharacterToMe);
			API.systApi.removeHook(d2hooks.Notification);
			API.systApi.removeHook(PlayerIsDead);
			API.systApi.removeHook(ActivateSound);
			API.systApi.removeHook(TextInformation)
		}
		private function onNotification(notification : Object):void 
		{
			if (notification["type"] == d2enums.NotificationTypeEnum.INVITATION) {
				//Nom de l'emetteur toujours en première position dans la notification => substring jusqu'au premier espace
				var sender : String = String(notification["contentText"]).substring(0, String(notification["contentText"]).indexOf(" ") + 1);
				var n: INotify;
				if (String(notification["contentText"]).lastIndexOf("Kolizéum") == -1) {
					n = NotificationsFactory.getNotification(com.morgan.factory.types.NotificationTypeEnum.GROUP_INVITATION_NOTIFICATION, sender);
				}else {
					n = NotificationsFactory.getNotification(com.morgan.factory.types.NotificationTypeEnum.KOLIZEUM_INVITATION_NOTIFICATION, sender);
				}
				notify(n);
			}
		}
		
		private function onExchangeRequest(myName : String, yourName : String):void 
		{
			var notification : INotify = NotificationsFactory.getNotification(com.morgan.factory.types.NotificationTypeEnum.EXCHANGE_NOTIFICATION, yourName);
			notify(notification);
		}
		
		private function onFriendConnection(content:String, channel:uint, timestamp:Number, saveMessage:Boolean=false):void 
		{
			if (content.indexOf("player") != -1) {
				var friendName : String = content.match(/\{player,(.*)\}/)[1];
				if(friendName && friendName.length > 0){
					var notification : INotify = NotificationsFactory.getNotification(com.morgan.factory.types.NotificationTypeEnum.FRIEND_CONNECTION_NOTIFICATION, friendName);
					notify(notification);
				}
			}
		}
		private function onPlayerLevelUp(playerLook:EntityLook, newLevel : uint, spellPointEarned : uint, caraPointEarned : uint, healPointEarned : uint, newSpell : Array) :void 
		{
			var notification : INotify = NotificationsFactory.getNotification(com.morgan.factory.types.NotificationTypeEnum.PLAYER_LEVEL_UP_NOTIFICATION, newLevel);
			notify(notification);
		}
		
		private function onJobLevelUp(jobName:String, jobLevel:uint):void 
		{
			var notification : INotify = NotificationsFactory.getNotification(com.morgan.factory.types.NotificationTypeEnum.JOB_LEVEL_UP_NOTIFICATION, [jobName, jobLevel]);
			notify(notification);
		}
		
		private function onMessageWithObject(channel : uint, content : String, senderName : String,fingerprint : String,senderId : uint,timestamp : Number,objects : Object):void 
		{
			if (channel == 9) {
				var notification : INotify = NotificationsFactory.getNotification(com.morgan.factory.types.NotificationTypeEnum.MP_NOTIFICATION, [senderName, content]);
				notify(notification);
			}
		}
		
		private function onMessage(channel : uint, senderId : uint, senderName : String, content : String, timestamp : Number, fingerprint : String, isAdminMsg : Boolean) :void 
		{
			if (channel == 9) {
				var notification : INotify = NotificationsFactory.getNotification(com.morgan.factory.types.NotificationTypeEnum.MP_NOTIFICATION, new Array(senderName, content));
				notify(notification);
			}
		}
		
		private function onSoundStateChange(enable : Boolean):void 
		{
			//TODO demander à mrfourbasse d'ajouter un hook ActiveSound lorsqu'on change via les modules
			var notification : INotify = NotificationsFactory.getNotification(com.morgan.factory.types.NotificationTypeEnum.DOFUS_SOUND_DISABLED_NOTIFICATION,[enable]);
			notify(notification);
		}
		
		private function onPlayerDead():void 
		{
			var notification : INotify = NotificationsFactory.getNotification(com.morgan.factory.types.NotificationTypeEnum.DEAD_IN_FIGHT_NOTIFICATION);
			notify(notification);
		}
		
		private function onGuildInvit(guildName:String, recruterId:uint, recruterName:String):void 
		{
			var notification : INotify = NotificationsFactory.getNotification(com.morgan.factory.types.NotificationTypeEnum.GUILDE_INVITATION_NOTIFICATION, [recruterName, guildName]);
			notify(notification);
		}
		
		private function onLevelUp(playerLook:Object,newLevel:uint,spellPointEarned:uint, caraPointEarned:uint,healPointEarned:uint, newSpell:Array ):void 
		{
			var notification : INotify = NotificationsFactory.getNotification(com.morgan.factory.types.NotificationTypeEnum.PLAYER_LEVEL_UP_NOTIFICATION, newLevel);
			notify(notification);
		}
		public function seekInNotification(keyWords : String):Vector.<INotify> {
			var notificationsMatches : Vector.<INotify> = new Vector.<INotify>();
			var notifLength : int = _notifications.length;
			keyWords = StringUtils.noAccent(keyWords);
			for (var i:int = 0; i < notifLength; i++) 
			{
				if (StringUtils.noAccent(_notifications[i].getNotification()).indexOf(keyWords) != -1) {
					notificationsMatches.push(_notifications[i]);
				}
			}
			return notificationsMatches;
		}
		public function getNotificationBufferSize():uint {
			return _notifications.length;
		}
		public function registerNotificationType(type:Vector.<int>, alert:Boolean):void{
			var n : int = type.length;
			while(--n >= 0){
				_notificationsFilters[type[n]] = alert;
			}
		}
		/* INTERFACE ui.observer.Observable */
		public function isTypeRegistered(type:int):Boolean {
			if (_notificationsFilters[type]) {
				return _notificationsFilters[type];
			}
			return false;
		}
		public function notify(notification:INotify):void 
		{
			if(_notificationsFilters[notification.getNotificationType()]){
				_notifications.unshift(notification);
				var observersLength : int = _observers.length;
				for (var i:int = 0; i < observersLength; i++) 
				{
					_observers[i].update(notification);
				}	
			}
		}
		
		public function addObserver(observer:Observer):void 
		{
			_observers.push(observer);
		}
		
		public function removeObserver(observer:Observer):void 
		{
			var index : int = _observers.indexOf(observer);
			if (index != -1) {
				_observers.splice(index, 1);
			} 
		}
		
		public function finalize():void {
			if (OptionsManager.getInstance().getEntry("btn_saveLog")) {
				saveLog();
			}
			removeListeners();
			
			_observers = null;
			_notifications = null;
			_notificationsFilters = null;
			_self = null;
			
		}
		public function saveLog():void {
			if (!_saved && _notifications && _notifications.length > 0) {
				var date : Date = new Date();
				var stream : ModuleFilestream = API.fileApi.openFile("save" + File.separator + date.toDateString(), FileMode.UPDATE);
				if (stream) {
					try {
						//TODO : sPositionner la tête de lecture a la fin du fichier.
						stream.writeUTF("DEBUT DE LA SESSION DU : " + date.toDateString() + date.toTimeString());
						for (var i:int = 0; i < _notifications.length; i++) 
						{
							stream.writeUTF(_notifications[i].getNotification() + "\n");
						}
					}catch (e:Error) {
						_saved = false;
						var notif : INotify = NotificationsFactory.getNotification(com.morgan.factory.types.NotificationTypeEnum.MODULE_GENERIC_NOTIFICATION, "Impossible de sauvegarder les données" + e);
						notify(notif);
						
					}finally {
						stream.close();
					}
				}
				_saved = true;
			}
		}
		public static function getInstance():NotificationManager {
			if (!_self) {
				_self = new NotificationManager();
			}
			return _self;
		}
	}

}