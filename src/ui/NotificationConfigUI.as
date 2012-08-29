package ui 
{
	import com.morgan.config.types.ConfigProperty;
	import com.morgan.factory.manager.ConfigManager;
	import com.morgan.factory.manager.OptionsManager;
	import com.morgan.factory.types.INotify;
	import com.morgan.observer.ConfigObservable;
	import com.morgan.observer.ConfigObserver;
	import com.morgan.observer.Observable;
	import com.morgan.observer.Observer;
	import d2api.SystemApi;
	import d2api.UiApi;
	import d2components.ButtonContainer;
	import d2enums.ComponentHookList;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Morgan
	 */
	public class NotificationConfigUI extends ConfigManager
	{		
		
		public var btn_orientation : ButtonContainer;
		public var btn_survol : ButtonContainer;
		public var btn_lastConfig : ButtonContainer;
		public var btn_saveLog : ButtonContainer;
		public var systApi:SystemApi;
		
		private static var _lastConfig : Vector.<Object>;
		private static var _initialized : Boolean = false;
		
		public function NotificationConfigUI() 
		{
			super();
		}
		public function main(...rest):void {
			
			systApi.log(16, "Constructor ConfigUI");
			var initializer : Vector.<ConfigProperty> = new Vector.<ConfigProperty>(4, true);
			initializer[0] = new ConfigProperty("notificationcenter", btn_lastConfig, "loadLastConfig");
			initializer[1] = new ConfigProperty("notificationcenter", btn_orientation, "changeOrientation");
			initializer[2] = new ConfigProperty("notificationcenter", btn_saveLog, "saveLocalLog");
			initializer[3] = new ConfigProperty("notificationcenter", btn_survol, "showTooltipOnRollOver");
			

			init(initializer);
			//showDefaultBtn(true);
			updateUi()
			
		}
		
		private function updateUi():void 
		{
			systApi.log(16, "NotificationConfigUI::updateUi()");
			systApi.log(16, "NotificationConfigUI::updateUi() value loadLastConfig : " + systApi.getOption("loadLastConfig", "notificationcenter"));
			btn_lastConfig.selected = systApi.getOption("loadLastConfig", "notificationcenter");
			btn_orientation.selected = systApi.getOption("changeOrientation", "notificationcenter");
			btn_saveLog.selected = systApi.getOption("saveLocalLog", "notificationcenter");
			btn_survol.selected = systApi.getOption("showTooltipOnRollOver", "notificationcenter");
		}
		override public function onRelease(target:Object):void 
		{
			super.onRelease(target);
			switch(target) {
				case btn_lastConfig : {
					setProperty("notificationcenter", "loadLastConfig", btn_lastConfig.selected);
					break;
				}case btn_orientation : {
					setProperty("notificationcenter", "changeOrientation", btn_orientation.selected);
					break;
				}case btn_saveLog : {
					setProperty("notificationcenter", "saveLocalLog", btn_saveLog.selected);
					break;
				}case btn_survol : {
					setProperty("notificationcenter", "showTooltipOnRollOver", btn_survol.selected);
					break;
				}
			}
		}
		public function unload():void {
			_lastConfig = null;
		}		
	}

}