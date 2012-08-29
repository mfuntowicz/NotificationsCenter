package com.morgan.factory.types.impl.social 
{
	import ui.api.API;
	import com.morgan.factory.types.INotify;
	import com.morgan.factory.types.Notification;
	import com.morgan.factory.types.NotificationTypeEnum;
	import com.morgan.utils.StringUtils;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class FriendConnectionNotification extends Notification implements INotify 
	{
		private var _friendName : String
		public function FriendConnectionNotification(friendName:String) 
		{
			super();
			_friendName = friendName;
			//_notif = _date + " : Votre amis "+StringUtils.escapeChatString("{player," + _friendName + "}")+" c'est connecté";
			_notif = _date + " : " + _friendName + " s'est connecté";
			_icon = "btn_friend";
		}
		
		/* INTERFACE com.morgan.factory.types.INotify */
		
		public override function getNotificationType():int 
		{
			return NotificationTypeEnum.FRIEND_CONNECTION_NOTIFICATION;
		}
		
		public function get friendName():String 
		{
			return _friendName;
		}
		public function toString():String 
		{
			return "[FriendConnectionNotification date=" + _date + " friendName=" + friendName + "]";
		}
	}

}