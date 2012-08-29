package com.morgan.factory.types.impl.pets 
{
	import ui.factory.types.INotify;
	import ui.factory.types.Notification;
	import ui.factory.types.NotificationTypeEnum;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class PetsNotification extends Notification implements INotify 
	{
		private var _petsName  : String; 
		private var _msg : String; 
		public function PetsNotification(petsName:String, msg:String) 
		{
			super();
			_petsName = petsName;
			_msg = msg;
			_icon = "btn_mount";
			_notif = _date + " : Votre familier " + _petsName + " " +_msg;
		}
		
		/* INTERFACE ui.factory.types.INotify */
		
		public function getNotificationType():int 
		{
			return NotificationTypeEnum.PET_NOTIFICATION;
		}
		
		public function get msg():String 
		{
			return _msg;
		}
		
		public function get petsName():String 
		{
			return _petsName;
		}
		public function toString():String 
		{
			return "[PetsNotification date=" + _date + "msg=" + msg + " petsName=" + petsName + "]";
		}
		
	}

}