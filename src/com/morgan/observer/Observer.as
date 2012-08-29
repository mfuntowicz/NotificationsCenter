package com.morgan.observer 
{
	import com.morgan.factory.types.INotify;
	
	
	/**
	 * ...
	 * @author Morgan
	 */
	public interface Observer 
	{
		function update(notification:INotify):void;
	}
	
}