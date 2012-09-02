package com.morgan.factory.manager 
{
	import com.morgan.config.types.ConfigProperty;
	import d2api.UiApi;
	import d2components.GraphicContainer;
	import d2enums.ComponentHookList;
	import d2hooks.ConfigPropertyChange;
	import ui.api.API;
	/**
	 * ...
	 * @author Morgan
	 */
	public dynamic class ConfigManager 
	{
		public var uiApi : UiApi;
		
		protected var _properties : Vector.<ConfigProperty>;
		
		/**
		 * Utilisation d'un prototype afin de prendre en compte le polymorphisme de la fonction et notamment du paramètre value.
		 
		prototype.setProperty = function(moduleName:String, property:String, value:Boolean):void {
			API.systApi.log(16, "ConfigManager::setProperty");
			for each(var p : ConfigProperty in this._properties) {
				if (property == p.associedProperty && moduleName == p.associedConfigModule) {
					API.configApi.setConfigProperty(p.associedConfigModule, p.associedProperty, value);
					this.updateDisplay(p, value);
					break;
				}
			}
		};*/
		
		public function ConfigManager() 
		{
			API.systApi.log(16, "Constructor ConfigManager");
		}
		
		protected function init(properties : Vector.<ConfigProperty>):void 
		{
			API.systApi.log(16, "ConfigUI::init()");
			_properties = properties;
			for each (var p : ConfigProperty in properties)
			{
				if (!p.associedProperty) {
					uiApi.me().getElement(p.associedComponent).disabled = true;
				}
				
				updateDisplay(p.associedComponent, API.configApi.getConfigProperty(p.associedConfigModule,p.associedProperty), true);
			}
			API.systApi.addHook(ConfigPropertyChange, onConfigChange);
		}
		
		protected function setProperty(moduleName:String, property:String, value:Boolean):void {
			API.systApi.log(16, "ConfigManager::setProperty");
			for each(var p : ConfigProperty in _properties) {
				if (property == p.associedProperty && moduleName == p.associedConfigModule) {
					API.configApi.setConfigProperty(p.associedConfigModule, p.associedProperty, value);
					this.updateDisplay(p.associedComponent, value);
					break;
				}
			}
		}
		
		private function updateDisplay(associedComponent:Object, value:Boolean, setListener:Boolean = false):void 
		{
			associedComponent.selected = value;
			if (setListener) {
				uiApi.addComponentHook(associedComponent as GraphicContainer, ComponentHookList.ON_RELEASE);
				API.systApi.log(16, "ConfigManager::updateDisplay, ajout du listener sur " + associedComponent.name);
			}
		}
		private function onConfigChange(className:String, propertyName:String, value:*, oldValue:*):void 
		{
			for each (var p : ConfigProperty in _properties) 
			{
				if (p.associedProperty == propertyName) {
					updateDisplay(p.associedComponent, value);
					break;
				}
			}
		}
		protected function reset():void {
			for each (var p : ConfigProperty in _properties) 
			{
				API.configApi.resetConfigProperty(p.associedConfigModule, p.associedProperty);
			}
		}
		protected function showDefaultBtn(value:Boolean):void {
			var optionContainer : Object = uiApi.getUi("optionContainer");
			if (optionContainer) {
				optionContainer.uiClass.btnDefault.visible = value;
			}
		}
		public function onRelease(target:Object):void {
			for each (var p : ConfigProperty in _properties) {
				if ( target.name == p.associedComponent) {
					API.configApi.setConfigProperty(p.associedConfigModule, p.associedProperty, target.selected);
					updateDisplay(target, target);
				}
			}
		}
	}
}