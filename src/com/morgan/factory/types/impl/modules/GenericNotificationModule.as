package com.morgan.factory.types.impl.modules 
{
	import com.morgan.factory.types.INotify;
	import com.morgan.factory.types.Notification;
	import com.morgan.factory.types.NotificationTypeEnum;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class GenericNotificationModule extends Notification implements INotify 
	{
		
		public function GenericNotificationModule(pMessage:String, pIcone:String = null) 
		{
			super();
			_notif = pMessage;
			_icon = pIcone;
		}
		
		/* INTERFACE com.morgan.factory.types.INotify */
		
		public function get icon():String 
		{
			return _icon;
		}
		
		public function get id():uint 
		{
			return _id;
		}
		
		public override function getNotificationType():int 
		{
			NotificationTypeEnum.MODULE_GENERIC_NOTIFICATION;
		}		
	}

}