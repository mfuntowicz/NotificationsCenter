package com.morgan.observer 
{
	import com.morgan.config.types.ConfigEntry;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public interface ConfigObservable 
	{
		function addObserver(observer : ConfigObserver):void;
		function removeObserver(observer:ConfigObserver):void;
		function notify(notification:ConfigEntry):void;
	}
	
}