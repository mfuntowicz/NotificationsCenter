package com.morgan.factory.types.impl.fight 
{
	import ui.api.API;
	import ui.factory.types.INotify;
	import ui.factory.types.Notification;
	import ui.factory.types.NotificationTypeEnum;
	import ui.utils.StringUtils;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class AgressionNotification extends Notification implements INotify 
	{
		private var _agressor : String;
		public function AgressionNotification(agressor:String) 
		{
			super();
			_agressor = agressor;
			_icon = "btn_conquest";
			_notif = _date + " : Vous avez été agressé par " + API.chatApi.getStaticHyperlink(StringUtils.escapeChatString("{player," + _agressor +"}"));
		}
		/* INTERFACE ui.factory.types.INotify */
		
		public function getNotificationType():int 
		{
			NotificationTypeEnum.AGRESSION_NOTIFICATION;
		}
		public function toString():String 
		{
			return "[AgressionNotification  " +_date + " " + _notif + "]";
		}
		
	}

}