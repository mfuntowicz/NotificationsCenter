package com.morgan.factory.types.impl.social 
{
	import com.morgan.factory.types.INotify;
	import com.morgan.factory.types.Notification;
	import com.morgan.factory.types.NotificationTypeEnum;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class GuildInvitationNotification extends Notification implements INotify 
	{
		private var _sender : String;
		private var _guildName : String;
		
		public function GuildInvitationNotification(sender : String, guildName : String) 
		{
			super();
			_sender = sender;
			_guildName = guildName;
			//_notif = _date + " :  Le joueur {player," + _sender + "} vous a inviter à rejoindre la guilde " + _guildName;
			_notif = _date + " : " + _sender + " vous a inviter à rejoindre la guilde " + _guildName;
			_icon = "btn_guild";
		}
		
		/* INTERFACE com.morgan.factory.types.INotify */
		
		public override function getNotificationType():int 
		{
			return NotificationTypeEnum.GUILDE_INVITATION_NOTIFICATION;
		}
		
		public function get sender():String 
		{
			return _sender;
		}
		
		public function get guildName():String 
		{
			return _guildName;
		}
		public function toString():String 
		{
			return "[GuildInvitationNotification date=" + _date + " sender=" + sender + " guildName=" + guildName + "]";
		}
		
	}

}