package com.morgan.observer 
{
	import com.morgan.config.types.ConfigEntry;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public interface ConfigObserver 
	{
		function update(entry:ConfigEntry):void;
	}
	
}