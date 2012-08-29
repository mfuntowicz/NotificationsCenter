package com.morgan.factory.types.impl.social 
{
	import ui.factory.types.INotify;
	import ui.factory.types.Notification;
	import ui.factory.types.NotificationTypeEnum;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class AnkaboxNotification extends Notification implements INotify 
	{
		private var _sender : String;
		private var _msg : String;
		public function AnkaboxNotification(sender:String, msg:String) 
		{
			super();
			_sender = sender;
			_msg = msg;
			_notif = _date + " Vous avez reçu un email de " + _sender + " : " + _msg;
			_icon = "btn_mp";
		}
		
		/* INTERFACE ui.factory.types.INotify */
		
		public function getNotificationType():int 
		{
			return NotificationTypeEnum.ANKABOX_MAIL_NOTIFICATION;
		}
		public function get date():String 
		{
			return _date;
		}
		
		public function get msg():String 
		{
			return _msg;
		}
		
		public function get sender():String 
		{
			return _sender;
		}
		public function toString():String 
		{
			return "[AnkaboxNotification date=" + date + " msg=" + msg + " sender=" + sender + "]";
		}
	}

}