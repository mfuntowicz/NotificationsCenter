package com.morgan.factory.types 
{
	/**
	 * ...
	 * @author Morgan
	 */
	public class Notification implements INotify 
	{
		private var _unformatedDate : Date;
		private var _id : uint;
		protected var _date : String;
		protected var _icon : String = "btn_all";
		protected var _notif : String;
		
		private static var NOTIFICATION_ID_AUTOINCREMENT : uint = 0;
		public function Notification() 
		{		
			_id = NOTIFICATION_ID_AUTOINCREMENT;
			++NOTIFICATION_ID_AUTOINCREMENT;
			
			_unformatedDate = new Date();
			_date = _unformatedDate.getHours() + ":" + (_unformatedDate.getMinutes() < 10 ? "0" + _unformatedDate.getMinutes() : _unformatedDate.getMinutes());
		}
		/* INTERFACE ui.factory.types.INotify */
		
		public function getNotificationType():int 
		{
			return -1;
		}
		
		public function getNotification():String 
		{
			return _notif;
		}
		public function get id():uint {
			return _id;
		}
		public function get date():String 
		{
			return _date;
		}
		
		public function get icon():String 
		{
			return _icon;
		}
		public function set icon(value:String):void 
		{
			_icon = value;
		}
		public function get notification():String 
		{
			return _notif;
		}
	}

}