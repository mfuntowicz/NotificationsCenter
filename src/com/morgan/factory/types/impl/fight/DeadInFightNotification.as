package com.morgan.factory.types.impl.fight 
{
	import com.morgan.factory.types.INotify;
	import com.morgan.factory.types.Notification;
	import com.morgan.factory.types.NotificationTypeEnum;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class DeadInFightNotification extends Notification implements INotify 
	{
		
		public function DeadInFightNotification() 
		{
			super();
			_icon = "type_1";
			_notif = _date + " : Vous êtes mort en combat";
		}
		
		/* INTERFACE com.morgan.factory.types.INotify */
		public override function getNotificationType():int 
		{
			return NotificationTypeEnum.DEAD_IN_FIGHT_NOTIFICATION;
		}
		public function toString():String 
		{
			return "[DeadInFightNotification _date= " + _date + " notification : " + _notif + "]";
		}
	}

}