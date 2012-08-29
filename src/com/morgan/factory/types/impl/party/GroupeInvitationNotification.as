package com.morgan.factory.types.impl.party 
{
	import com.morgan.factory.types.INotify;
	import com.morgan.factory.types.Notification;
	import com.morgan.factory.types.NotificationTypeEnum;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class GroupeInvitationNotification extends Notification implements INotify 
	{
		private var _sender : String;
		
		public function GroupeInvitationNotification(sender: String) 
		{
			super();
			_sender = sender;
			//_notif = _date + " : Le joueur {player," + _sender + "} vous a invité à rejoindre son groupe";
			_icon = "btn_friend";
			_notif = _date + " : " + _sender + " vous a invité à rejoindre son groupe";
		}
		
		/* INTERFACE com.morgan.factory.types.INotify */
		
		public override function getNotificationType():int 
		{
			return NotificationTypeEnum.GROUP_INVITATION_NOTIFICATION;
		}
		
		override public function get date():String 
		{
			return _date;
		}
		
		public function get sender():String 
		{
			return _sender;
		}
		public function toString():String 
		{
			return "[GroupeInvitationNotification date=" + _date + " sender=" + _sender + "]";
		}
	}

}