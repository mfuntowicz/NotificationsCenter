package com.morgan.observer 
{
	import com.morgan.factory.types.INotify;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public interface Observable 
	{
		function addObserver(observer : Observer):void;
		function removeObserver(observer:Observer):void;
		function notify(notification:INotify):void;
	}
	
}