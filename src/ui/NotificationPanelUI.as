package ui 
{

	import com.morgan.factory.manager.OptionsManager;
	import com.morgan.utils.As3PerformancesAnalyzer;
	import d2api.DataApi;
	import d2api.PlayedCharacterApi;
	import d2api.SoundApi;
	import d2api.SystemApi;
	import d2api.UiApi;
	import d2components.ButtonContainer;
	import d2components.ComboBox;
	import d2components.EntityDisplayer;
	import d2components.GraphicContainer;
	import d2components.Grid;
	import d2components.Input;
	import d2components.Label;
	import d2components.Slot;
	import d2components.TextArea;
	import d2components.Texture;
	import d2enums.ComponentHookList;
	import d2enums.LocationEnum;
	import d2enums.SelectMethodEnum;
	import d2enums.StatesEnum;
	import d2enums.UISoundEnum;
	import d2hooks.KeyUp;
	import d2network.EntityLook;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.profiler.showRedrawRegions;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import flash.utils.IDataOutput;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import ui.api.API;
	import com.morgan.factory.types.INotify;
	import com.morgan.factory.types.Notification;
	import com.morgan.factory.types.NotificationTypeEnum;
	import com.morgan.factory.manager.NotificationManager;
	import com.morgan.observer.Observer
	/**
	 * ...
	 * @author Morgan
	 */
	public class NotificationPanelUI implements Observer
	{
		
		/* Constantes ou presque ... */
		public static const UI_POSITION_X_CACHE : String = "notificationCenterX";
		public static const UI_POSITION_Y_CACHE : String = "notificationCenterY";
		public static const MODULE_TITLE  :String = "Centre de Notifications";
		public static var CONFIG_UI_SKIN:String;
		
		
		/* Variables d'API */
		public var systApi :SystemApi;
		public var playerApi : PlayedCharacterApi;		
		public var uiApi : UiApi;
		public var soundApi : SoundApi;
		
		/* Variables d'interfaces */
		public var mainCtr : GraphicContainer;
		public var notifContainer : GraphicContainer;
		private var _cancelDrag : Boolean = false;
		
		public var avatar : EntityDisplayer;
		
		public var title : Label;
		
		public var btn_close : ButtonContainer;
		public var minimizedPanel :GraphicContainer;
		public var thumbnailsGrid :Grid;
		public var lastNotificationLabel : TextArea;
		public var doNotDisturbBtn : ButtonContainer;
		public var btn_lbl_doNotDisturbBtn : Label;
		public var clearNotificationsBtn : ButtonContainer;
		
		public var btnOptions : ButtonContainer;
		public var btnSearch:ButtonContainer;
		public var searchInput:Input;
		public var searchCtr : GraphicContainer
		public var notificationGrid:Grid;
		
		
		/* CheckBox de l'interface */
		public var checkboxContainer : GraphicContainer;
		
		public var ankamaCheckBox :ButtonContainer;
		private var ankamaTypeEnum : Vector.<int>;
		
		public var exchangeCheckbox :ButtonContainer;
		private var exchangeTypeEnum : Vector.<int>;
		
		public var fightCheckbox :ButtonContainer;
		private var fightTypeEnum : Vector.<int>;
		
		public var levelCheckbox :ButtonContainer;
		private var levelTypeEnum : Vector.<int>;
		
		public var partyCheckbox :ButtonContainer;
		private var partyTypeEnum : Vector.<int>;
		
		public var socialCheckbox :ButtonContainer;
		
		private var socialTypeEnum : Vector.<int>;
		
		/* Variables internes */
		private var _notificationsProvider:Vector.<INotify>;
		private var _notificationTimer:Timer;
		private var _btnGridList : Dictionary;
		private var _doNotDisturb : Boolean = false;
		private var _loadLastConfig : Boolean = false;
		private var _verticalMode : Boolean;
		private var _saveLog : Boolean;
		private var _showTooltipOnRollOver : Boolean;
		private static var _self:NotificationPanelUI;

		public function main(...rest):void {
			_self = this;
			var x:int, y:int;
			
			API.systApi = systApi;
			API.uiApi = uiApi;
			
			CONFIG_UI_SKIN = API.systApi.getConfigEntry("config.ui.skin");
			minimizedPanel.filters = new Array(new GlowFilter(0xFFFFFF,1,8,8));
			btnSearch.checkBox = true;

			
			//var lastConfig : Vector.<Object> = OptionsManager.getInstance().init(uiApi.me().getConstant("optionsEntries"));
			//var lastConfigLength : int = lastConfig.length;
			//
			//for (var i:int = 0; i < lastConfigLength; i++) 
			//{
				//updateOptions(lastConfig[i].name, lastConfig[i].value);
			//}
			
			if ((x = systApi.getData(UI_POSITION_X_CACHE, true)) && (y = systApi.getData(UI_POSITION_Y_CACHE, true))) {
				mainCtr.x = x;
				mainCtr.y = y;
			}else {
				minimizedPanel.x = (API.uiApi.getStageWidth() - minimizedPanel.width) >> 1;
				lastNotificationLabel.x = (minimizedPanel.width - lastNotificationLabel.width) >> 1;
				mainCtr.x = (API.uiApi.getStageWidth() - mainCtr.width) >> 1;
				mainCtr.y = minimizedPanel.y + minimizedPanel.height;
			}
			thumbnailsGrid.vertical = _verticalMode;
			
			NotificationManager.getInstance().init();
			NotificationManager.getInstance().addObserver(this);
			
			ankamaTypeEnum = Vector.<int>([NotificationTypeEnum.DOFUS_MAINTENANCE_NOTIFICATION, NotificationTypeEnum.DOFUS_SOUND_DISABLED_NOTIFICATION]);
			exchangeTypeEnum = Vector.<int>([NotificationTypeEnum.EXCHANGE_NOTIFICATION, NotificationTypeEnum.KAMAS_IO_NOTIFICATION]);
			fightTypeEnum = Vector.<int>([NotificationTypeEnum.AGRESSION_NOTIFICATION, NotificationTypeEnum.DEAD_IN_FIGHT_NOTIFICATION]);
			levelTypeEnum = Vector.<int>([NotificationTypeEnum.JOB_LEVEL_UP_NOTIFICATION, NotificationTypeEnum.PLAYER_LEVEL_UP_NOTIFICATION]);
			partyTypeEnum = Vector.<int>([NotificationTypeEnum.GROUP_INVITATION_NOTIFICATION, NotificationTypeEnum.KOLIZEUM_INVITATION_NOTIFICATION]);
			socialTypeEnum = Vector.<int>([NotificationTypeEnum.MP_NOTIFICATION, NotificationTypeEnum.FRIEND_CONNECTION_NOTIFICATION, NotificationTypeEnum.ANKABOX_MAIL_NOTIFICATION, NotificationTypeEnum.GUILDE_INVITATION_NOTIFICATION]);
			
			NotificationManager.getInstance().registerNotificationType(ankamaTypeEnum, true);
			NotificationManager.getInstance().registerNotificationType(exchangeTypeEnum, true);
			NotificationManager.getInstance().registerNotificationType(fightTypeEnum, true);
			NotificationManager.getInstance().registerNotificationType(levelTypeEnum, true);
			NotificationManager.getInstance().registerNotificationType(partyTypeEnum, true);
			NotificationManager.getInstance().registerNotificationType(socialTypeEnum, true);
			NotificationManager.getInstance().registerNotificationType(Vector.<int>([NotificationTypeEnum.MODULE_GENERIC_NOTIFICATION]), true);
			
			_notificationTimer = new Timer(2000, 1);
			
			_notificationsProvider = new Vector.<INotify>();
			notificationGrid.dataProvider = _notificationsProvider;
			
			_btnGridList = new Dictionary(true);
			
			uiApi.addComponentHook(minimizedPanel, ComponentHookList.ON_RELEASE);
			uiApi.addComponentHook(btnSearch, ComponentHookList.ON_ROLL_OVER);
			uiApi.addComponentHook(btnSearch, ComponentHookList.ON_ROLL_OUT);
			uiApi.addComponentHook(btnOptions, ComponentHookList.ON_RELEASE);
			uiApi.addComponentHook(btnOptions, ComponentHookList.ON_ROLL_OVER);
			uiApi.addComponentHook(btnOptions, ComponentHookList.ON_ROLL_OUT);
			uiApi.addComponentHook(ankamaCheckBox, ComponentHookList.ON_RELEASE);
			uiApi.addComponentHook(doNotDisturbBtn, ComponentHookList.ON_ROLL_OVER);
			uiApi.addComponentHook(doNotDisturbBtn, ComponentHookList.ON_ROLL_OUT);
			uiApi.addComponentHook(doNotDisturbBtn, ComponentHookList.ON_RELEASE);
			uiApi.addComponentHook(clearNotificationsBtn, ComponentHookList.ON_ROLL_OVER);
			uiApi.addComponentHook(clearNotificationsBtn, ComponentHookList.ON_ROLL_OUT);
			uiApi.addComponentHook(clearNotificationsBtn, ComponentHookList.ON_RELEASE);
			uiApi.addComponentHook(searchInput, ComponentHookList.ON_ITEM_ROLL_OVER);
			uiApi.addComponentHook(searchInput, ComponentHookList.ON_ITEM_ROLL_OUT);
			if(_showTooltipOnRollOver){
				uiApi.addComponentHook(notificationGrid, ComponentHookList.ON_ITEM_ROLL_OVER);
				uiApi.addComponentHook(notificationGrid, ComponentHookList.ON_ITEM_ROLL_OUT);
			}
			systApi.addHook(KeyUp, OnKeyUp);
			
			updateUI();
			
			//uiApi.addComponentHook(searchInput, ComponentHookList.ON_CHANGE);
			//uiApi.addComponentHook(mainCtr, ComponentHookList.ON_PRESS); TODO: Revoir déplacement UI
		}
		/**
		 * Mets à jour les options d'affichage, puis rafraichi l'UI
		 * @param	name
		 * @param	value
		 */
		public function updateOptions(name:String, value:Boolean):void 
		{
			systApi.log(16, "NotificationPanelUi updateOptions => " + name + " : " + value);
				switch(name) {
					case "btn_lastConfig" : {
						_loadLastConfig = value;
						break;
					}
					case "btn_orientation" : {
						_verticalMode = value;
						break;
					}
					case "btn_survol" : {
						_showTooltipOnRollOver = value;
						break;
					}
					case "btn_saveLog" : {
						_saveLog = value;
						break;
					}
				}
		}
		/**
		 * Ecouteur pour les appuis long, non relaché sur un élément d'affichage
		 * @param	target l'objet d'affichage concerné
		 */
		public function onPress(target:GraphicContainer):void {
			setTimeout(dragUi, 50);
		}
		
		/**
		 * Drag l'UI
		 */
		private function dragUi():void 
		{
			if(!_cancelDrag) mainCtr.startDrag();
			else stopDragUi();
				
			_cancelDrag = false;
		}
		/**
		 * Stop le drag de l'UI
		 */
		private function stopDragUi():void 
		{
			mainCtr.stopDrag();
			systApi.setData(UI_POSITION_X_CACHE, mainCtr.x, true);
			systApi.setData(UI_POSITION_Y_CACHE, mainCtr.y, true);
		}
		/**
		 * Ecouter des entrées clavier, permet d'alimenter l'Input de la zone de recherche
		 * @param	target L'input où sont entrés les caractères
		 * @param	key le charCode du caractère
		 */
		public function OnKeyUp(target:Object, key:uint):void {
			if (searchCtr.visible && searchInput.haveFocus && searchInput.text.length > 2 && NotificationManager.getInstance().getNotificationBufferSize() > 0) {
				var result : Vector.<INotify> = NotificationManager.getInstance().seekInNotification(searchInput.text);
				notificationGrid.dataProvider = result;
			}else {
				notificationGrid.dataProvider = _notificationsProvider;
			}
		}
		/**
		 * Ecouteur pour les cliques de souriss
		 * @param	target éléments venant d'être cliqué
		 */
		public function onRelease(target:GraphicContainer):void {
			switch(target) {
				case btn_close : {
					mainCtr.visible = false;
					btn_close.visible = false;
					break;
				}
				case minimizedPanel : {
					mainCtr.visible = !mainCtr.visible;
					btn_close.visible = mainCtr.visible;
					break;
				}
				case btnOptions : {
					checkboxContainer.visible = !checkboxContainer.visible;
					break;
				}
				case ankamaCheckBox : {
					NotificationManager.getInstance().registerNotificationType(ankamaTypeEnum, ankamaCheckBox.selected);
					notificationGrid.updateItems();
					break;
				}
				case exchangeCheckbox : {
					NotificationManager.getInstance().registerNotificationType(exchangeTypeEnum, exchangeCheckbox.selected);
					notificationGrid.updateItems();
					break;
				}
				case socialCheckbox : {
					NotificationManager.getInstance().registerNotificationType(socialTypeEnum, socialCheckbox.selected);
					notificationGrid.updateItems();
					break;
				}
				case partyCheckbox : {
					NotificationManager.getInstance().registerNotificationType(partyTypeEnum, partyCheckbox.selected);
					notificationGrid.updateItems();
					break;
				}
				
				case levelCheckbox : {
					NotificationManager.getInstance().registerNotificationType(levelTypeEnum, levelCheckbox.selected);
					notificationGrid.updateItems();
					break;
				}
				case fightCheckbox : {
					NotificationManager.getInstance().registerNotificationType(fightTypeEnum, fightCheckbox.selected);
					notificationGrid.updateItems();
					break;
				}
				case doNotDisturbBtn: {
					_doNotDisturb = !_doNotDisturb;
					if (!_doNotDisturb) {
						NotificationManager.getInstance().setListeners();
						btn_lbl_doNotDisturbBtn.text = "Suspendre";
					}else {
						NotificationManager.getInstance().removeListeners();
						btn_lbl_doNotDisturbBtn.text = "Reprendre";
					}
					break;
					
				}
				case clearNotificationsBtn : {
					_notificationsProvider = new Vector.<INotify>();
					notificationGrid.dataProvider = _notificationsProvider;
					thumbnailsGrid.dataProvider = _notificationsProvider;
					updateUI();
					break;
				}
				case btnSearch : {
					if(!searchInput.haveFocus) searchInput.focus();
					if (btnSearch.state == StatesEnum.STATE_NORMAL) {
						notificationGrid.dataProvider = _notificationsProvider;
						searchInput.text = "";
					}
					break;
				}
				default : {
					if (target.name.indexOf("delete") != -1) {
						deleteEntry(_btnGridList[target.name]);
					}
				}
			}
			_cancelDrag = true;
		}
		/**
		 * RollOver sur un élément d'affichage
		 * @param	target  l'objet venant d'être survolé
		 */
		public function onRollOver(target:Object):void {
			if (!_showTooltipOnRollOver) return;
			var text : String;
			switch(target) {
				case btnSearch : {
					text = uiApi.getText("ui.common.sortOrSearch");
					break;
				}
				case searchInput: {
					text = uiApi.getText("ui.common.searchFilterTooltip");
					break;
				}
				case btnOptions : {
					text = uiApi.getText("ui.common.optionsMenu");
					break;
				}
				case doNotDisturbBtn : {
					text = "Arrête le flux de notifications";
					break;
				}
				case clearNotificationsBtn : {
					text = "Supprime toutes les notifications";
					break;
				}
			}
			if (text && text != "") {
				uiApi.showTooltip(uiApi.textTooltipInfo(text), target, false, "standard", LocationEnum.POINT_BOTTOM, LocationEnum.POINT_TOP, 3, null, null, null, "TextInfo");
			}
		}
		/**
		 * RollOut sur les éléments d'affichages
		 * @param	target l'objet venant d'être survolé
		 */
		public function onRollOut(target:Object):void {
			uiApi.hideTooltip();
		}
		/**
		 * RollOver sur un item de la grid, permet d'afficher le texte de la notification à l'aide d'un tooltip
		 * @param	target La grille visée
		 * @param	item L'item en question
		 */
		public function onItemRollOver(target:Grid, item:Object):void {
			if(_showTooltipOnRollOver){
				uiApi.showTooltip(uiApi.textTooltipInfo(notificationGrid.dataProvider[item.index].getNotification()), item.container, false, "standard", LocationEnum.POINT_BOTTOM, LocationEnum.POINT_TOP, 3, null, null, null, "NotifDetails");
			}
		}
		/**
		 * RollOut sur un item de la grid, permet de cacher la description affichée au survol
		 * @param	target La grille visée
		 * @param	item L'item en question
		 */
		public function onItemRollOut(target:Grid, item:Object):void {
			uiApi.hideTooltip();
		}
		/**
		 * Fonction appeller automatiquement par la grille notificationsGrid pour mettre à jour ses entrées
		 * @param	data Donnée à afficher
		 * @param	componentsRef reférence vers le conteneur de la ligne courante dans la grille
		 * @param	selected S'il s'agit du nouvelle selection
		 */
		public function updateEntry(data : * , componentsRef : * , selected : Boolean) : void {
			if (data && NotificationManager.getInstance().isTypeRegistered(data.getNotificationType())) {
				if(!_btnGridList[componentsRef.deleteNotifBtn.name]){
					uiApi.addComponentHook(componentsRef.notifContainer, ComponentHookList.ON_ROLL_OVER);
					uiApi.addComponentHook(componentsRef.notifContainer, ComponentHookList.ON_ROLL_OUT);
					uiApi.addComponentHook(componentsRef.deleteNotifBtn, ComponentHookList.ON_RELEASE);
				}
				_btnGridList[componentsRef.deleteNotifBtn.name] = data;
				
				var uri : String = systApi.getConfigEntry("config.ui.skin") + "assets.swf|" + data.icon;
				componentsRef.notifLabel.text = data.notification;
				componentsRef.itemTxt.uri = uiApi.createUri(uri);
			}else {
				if(componentsRef && componentsRef.notifContainer){
					componentsRef.notifContainer.visible = false;
				}
			}
		}
		/**
		 * Fonction appeller automatiquement par la grille thumbnailsgrid pour mettre à jour ses entrées
		 * @param	data Donnée à afficher
		 * @param	componentsRef reférence vers le conteneur de la ligne courante dans la grille
		 * @param	selected S'il s'agit du nouvelle selection
		 */
		public function updateEntryThumbnails(data : * , componentsRef : * , selected : Boolean) : void {
			if (data) {
				var uri : String = CONFIG_UI_SKIN + "assets.swf|" + data.icon;
				componentsRef.thumbnail.uri = uiApi.createUri(uri);
			}else {
				if (componentsRef && componentsRef.notifContainer) {
					componentsRef.notifContainer.visible = false;
				}
			}
		}
		/**
		 * Supprime une entrée du provider des grilles
		 * @param	notification Object INotify => devenu ReadOnlyObject 
		 */
		private function deleteEntry(notification:Object):void {
			var n : int = _notificationsProvider.length;
			var found : Boolean = false;
			while (--n >= 0 && !found) {
				if (_notificationsProvider[n].id == notification["id"]) {
					_notificationsProvider.splice(n, 1);
					found = true;
				}
			}
			if (found) {
				notificationGrid.dataProvider = _notificationsProvider;
				thumbnailsGrid.dataProvider = _notificationsProvider;
				updateUI();
			}
		}
		/**
		 * Mets à jour les informations et la disposition de l'UI
		 */
		private function updateUI():void {
			if (_notificationsProvider.length > 0 ) {
				title.text = MODULE_TITLE + (" (" + _notificationsProvider.length + ")");
				clearNotificationsBtn.disabled = false;
			}else {
				title.text = MODULE_TITLE;
				clearNotificationsBtn.disabled = true;
			}
			if (_verticalMode != thumbnailsGrid.vertical) {
				if (_verticalMode) {
					thumbnailsGrid.width = 30;
					thumbnailsGrid.height = 400;
				}else {
					thumbnailsGrid.width = 400;
					thumbnailsGrid.height = 30;
				}
			}
		}
		/* INTERFACE ui.observer.Observer */
		/**
		 * Recoit les notifications du NotificationManager pour alimenter la zone d'affichage des notifications
		 * @param	notificaton Nouvelle notification reçue
		 */
		public function update(notification :INotify):void 
		{
			soundApi.playSoundById(UISoundEnum.OK_BUTTON);
			_notificationsProvider.unshift(notification);
			notificationGrid.dataProvider = _notificationsProvider;
			
			updateUI();
			
			lastNotificationLabel.text = notification.getNotification();
			lastNotificationLabel.visible = true;
			thumbnailsGrid.visible = false;
			thumbnailsGrid.dataProvider = _notificationsProvider;
			
			_notificationTimer.addEventListener(TimerEvent.TIMER_COMPLETE, hideNotificationLabel);
			_notificationTimer.start();
		}
		/**
		 * Handler du timer permet de cacher le texte de la notification, et de réafficher les icones dans la barre d'affichage réduite
		 * @param	e TimerEvent
		 */
		private function hideNotificationLabel(e:TimerEvent):void {
			_notificationTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, hideNotificationLabel);
			_notificationTimer.reset();
			lastNotificationLabel.visible = false;
			thumbnailsGrid.visible = true;
		}
		/**
		 * Décharge le module
		 */
		public function unload():void {
			if (_notificationTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)) {
				_notificationTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, hideNotificationLabel);
			}
			_notificationsProvider = null;
			_notificationTimer = null;
			
			ankamaTypeEnum = null;
			socialTypeEnum = null;
			partyTypeEnum = null;
			levelTypeEnum = null;
			fightTypeEnum = null;
			exchangeTypeEnum = null;
			
			notificationGrid.free();
			thumbnailsGrid.free();
			
			NotificationManager.getInstance().saveLog();
			NotificationManager.getInstance().finalize();
		}
		public static function getInstance():NotificationPanelUI {
			return _self;
		}
	}

}