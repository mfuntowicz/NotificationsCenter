package com.morgan.factory.types.impl.exchange 
{
	import ui.factory.types.INotify;
	import ui.factory.types.Notification;
	import ui.factory.types.NotificationTypeEnum;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class KamasIONotification extends Notification implements INotify 
	{
		private var _kamas : String; 
		private var _earn : Boolean;
		public function KamasIONotification(kamas : String, earn : Boolean) 
		{
			super();
			_kamas = kamas;
			_earn = earn;
			_icon = "kamastack";
			if (!earn) {
				_notif =  _date + " : Vous avez perdu " + _kamas + " kamas";
			}else {
				_notif = _date + " : Vous avez gagné " + _kamas + " kamas";
			}
		}
		
		/* INTERFACE ui.factory.types.INotify */
		
		public override function getNotificationType():int 
		{
			return NotificationTypeEnum.KAMAS_IO_NOTIFICATION;
		}
		
		public function get earn():Boolean 
		{
			return _earn;
		}
		
		public function get kamas():String 
		{
			return _kamas;
		}
		public function toString():String 
		{
			return "[KamasIONotification date=" + _date + " earn=" + earn + " kamas=" + kamas + "]";
		}
	}

}