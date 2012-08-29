package com.morgan.factory.types.impl.party 
{
	import com.morgan.factory.types.INotify;
	import com.morgan.factory.types.Notification;
	import com.morgan.factory.types.NotificationTypeEnum;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class KolizeumInvitationNotification extends Notification implements INotify 
	{
		private var _leader : String;
		
		public function KolizeumInvitationNotification(leader : String) 
		{
			super();
			_leader = leader;
			//_notif = _date + " : Le joueur {player," + _leader + "} vous a inviter en Kolizeum";
			_icon = "btn_conquest";
			_notif = _date + " : " + _leader + " vous a inviter en Kolizeum";
		}
		
		/* INTERFACE com.morgan.factory.types.INotify */
		
		public override function getNotificationType():int 
		{
			return NotificationTypeEnum.KOLIZEUM_INVITATION_NOTIFICATION;
		}
		
		public function get leader():String 
		{
			return _leader;
		}
		public function toString():String 
		{
			return "[KolizeumInvitationNotification date=" + _date + " leader=" + _leader + "]";
		}
	}

}