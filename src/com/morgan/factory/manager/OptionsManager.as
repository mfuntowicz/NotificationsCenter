package com.morgan.factory.manager 
{
	import adobe.utils.CustomActions;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import ui.api.API;
	import ui.NotificationPanelUI;
	/**
	 * ...
	 * @author Morgan
	 */
	public class OptionsManager 
	{
		private static const DOFUS_OPTIONS_MANAGER_NAME : String = "notificationcenter";
		private static var _module_common : Object;
		private static var _self : OptionsManager;
		
		
		private var _dofusOptionsManager : Object;
		private var _dofusOptionsManagerAvailable : Boolean;
		private var _entrySet:Dictionary;
		private var _configUiDisplayed : Boolean;
		private var _lastStartConfig : Vector.<Object>
		public function OptionsManager() 
		{
			_configUiDisplayed = false;
			_dofusOptionsManagerAvailable = false;
			_dofusOptionsManager = API.configApi.createOptionManager(DOFUS_OPTIONS_MANAGER_NAME);
			if (_dofusOptionsManager) {
				_dofusOptionsManagerAvailable = true;
			}
			_entrySet = new Dictionary(true);
		}
		public function init(optionsModifiers:String):Vector.<Object> {
			if(_dofusOptionsManagerAvailable){
				var options : Array= optionsModifiers.split("|");
				var n : int = options.length;
				var lastOptions : Vector.<Object> = new Vector.<Object>(n, true);
				
				while (--n >= 0) {
					var name : String = options[n];
					registerOptions(name, false, true);
					var saveEntry : Boolean;
					var o : Object = new Object();
					
					registerOptions(name, false, true);
					saveEntry = _dofusOptionsManager[name];
					o["name"] = name;
					saveEntry ? o["value"] = saveEntry : o["value"] = false;
					lastOptions[n] = o;
				}
				return (_lastStartConfig = lastOptions);
			}
			return null;
		}
		public function addConfigUi():void {
			if (!_configUiDisplayed) {
				_configUiDisplayed = true;
				_module_common.addOptionItem("notifications", "Notifications", "Ces options permettent de paramétrer le centre de notifications", "NotificationsPanel::NotificationConfig" );
			}
		}
		public function registerOptions(name:String, value:Boolean, useCache:Boolean = true):void {
			if (_dofusOptionsManagerAvailable) {
				//Provoque une erreur si on ne le fait pas 
				//TODO : Demander à Fourbasse why ?
				_dofusOptionsManager.add(name, false, useCache);
			}
		}
		public function updateOptions(name:String, value:Boolean):void {
			if(_dofusOptionsManagerAvailable){
				//_dofusOptionsManager[name] = value;
				API.configApi.setConfigProperty(DOFUS_OPTIONS_MANAGER_NAME, name, value);
			}
		}
		public function getEntry(name:String):*{
			return _dofusOptionsManager[name];
		}
		public static function getInstance():OptionsManager {
			if (!_self) {
				_self = new OptionsManager();
			}
			return _self;
		}
		
		static public function set module_common(value:Object):void 
		{
			_module_common = value;
		}
		
		public function get lastStartConfig():Vector.<Object> 
		{
			if (!_lastStartConfig) {
				throw new Error("lastConfig n'est pas définie dans OptionsManager, appel trop tot ? ");
			}
			return _lastStartConfig;
		}
	}

}