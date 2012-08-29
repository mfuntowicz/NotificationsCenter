package com.morgan.factory.types.impl.dofus 
{
	import com.morgan.factory.types.INotify;
	import com.morgan.factory.types.Notification;
	import com.morgan.factory.types.NotificationTypeEnum;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class DofusMaintenanceNotification extends Notification implements INotify 
	{
		private var _remainingTime : String;
		
		public function DofusMaintenanceNotification(remainingTime:String) 
		{
			super();
			_remainingTime = remainingTime;
			_icon = "Quetes_tx_PictoSablier";
			_notif = _date + " : Une maintenance est prévue dans " + _remainingTime;
		}
		
		/* INTERFACE com.morgan.factory.types.INotify */
		
		public override function getNotificationType():int 
		{
			return NotificationTypeEnum.DOFUS_MAINTENANCE_NOTIFICATION;
		}
		
		public function get remainingTime():String 
		{
			return _remainingTime;
		}
		public function toString():String 
		{
			return "[DofusMaintenanceNotification date=" + _date + " remainingTime=" + remainingTime + "]";
		}
		
	}

}