package com.morgan.factory.types.impl.diary 
{
	import ui.factory.types.INotify;
	import ui.factory.types.Notification;
	import ui.factory.types.NotificationTypeEnum;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class DiaryEventNotification extends Notification implements INotify 
	{
		private var _eventName : String;
		private var _msg : String; 
		
		public function DiaryEventNotification(eventName:String, msg:String) 
		{
			super();
			_eventName = eventName;
			_msg = msg;
			_icon = "Quetes_tx_PictoLivre";
			_notif = _date + " : Rappel " + _eventName + " " +_msg;
		}
		
		/* INTERFACE ui.factory.types.INotify */
		
		public override function getNotificationType():int 
		{
			return NotificationTypeEnum.DIARY_EVENT_NOTIFICATION;
		}
		
		public function get eventName():String 
		{
			return _eventName;
		}
		
		public function get msg():String 
		{
			return _msg;
		}
		public function toString():String 
		{
			return "[DiaryEventNotification date=" + _date + " eventName=" + eventName + " msg=" + msg + "]";
		}
	}

}