package com.morgan.factory.types.impl.levels 
{
	import com.morgan.factory.types.INotify;
	import com.morgan.factory.types.Notification;
	import com.morgan.factory.types.NotificationTypeEnum;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class PlayerLevelUpNotification extends Notification implements INotify 
	{
		private var _newLevel : String;
		
		public function PlayerLevelUpNotification(newLevel:String) 
		{
			super();
			_newLevel = newLevel;
			_icon = "levelUp_tx_pictoCarac";
			_notif = _date +" : Votre niveau est désormais " + _newLevel;
		}
		
		/* INTERFACE com.morgan.factory.types.INotify */
		
		public override function getNotificationType():int 
		{
			return NotificationTypeEnum.PLAYER_LEVEL_UP_NOTIFICATION;
		}
		
		public function get newLevel():String 
		{
			return _newLevel;
		}
		public function toString():String 
		{
			return "[PlayerLevelUpNotification date=" + _date + " newLevel=" + newLevel + "]";
		}
		
	}

}