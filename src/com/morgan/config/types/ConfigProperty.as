package com.morgan.config.types 
{
	import d2components.GraphicContainer;
	/**
	 * ...
	 * @author ...
	 */
	public class ConfigProperty 
	{
		public var associedComponent : Object;
		public var associedConfigModule : String;
		public var associedProperty : String;
		public function ConfigProperty(associedConfigModule:String, associedComponent:Object, associedProperty:String) 
		{
			this.associedComponent = associedComponent;
			this.associedConfigModule = associedConfigModule;
			this.associedProperty = associedProperty;
		}
		
	}

}