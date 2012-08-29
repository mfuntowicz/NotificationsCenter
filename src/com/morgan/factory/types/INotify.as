package com.morgan.factory.types 
{
	
	/**
	 * ...
	 * @author Morgan
	 */
	public interface INotify 
	{
		function getNotificationType():int;
		function getNotification():String;
		function get icon():String;
		function get id():uint;
	}
	
}