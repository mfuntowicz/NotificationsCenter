package com.morgan.factory.types.impl.modules 
{
	import com.morgan.factory.types.Notification;
	import com.morgan.factory.types.INotify;
	import com.morgan.factory.types.NotificationTypeEnum;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class NotificationsSavingDisable extends Notification implements INotify 
	{
		
		private var _message :String;
		private var _notif : String;
		
		public function NotificationsSavingDisable(message:String) 
		{
			super();
			_message = message;
			_notif = _date + " : " + _message;
			_icon = "tx_warning";
		}
		
		override public function getNotificationType():int {
			return NotificationTypeEnum.MODULE_NOTIFICATION_SAVE_DISABLED;
		}
		
		override public function toString():String 
		{
			return "[NotificationsSavingDisable _date=" + _date + " message=" + _message + "]";
		}
	}

}