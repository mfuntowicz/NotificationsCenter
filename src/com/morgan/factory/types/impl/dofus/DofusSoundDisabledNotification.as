package com.morgan.factory.types.impl.dofus 
{
	import com.morgan.factory.types.INotify;
	import com.morgan.factory.types.Notification;
	import com.morgan.factory.types.NotificationTypeEnum;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class DofusSoundDisabledNotification extends Notification implements INotify 
	{
		/**
		 * 
		 * @param	actived inverser dans dofus actived = désactivé ...
		 */
		private var _actived : Boolean;
		public function DofusSoundDisabledNotification(actived :Boolean) 
		{
			super();
			_actived = actived;
			_icon = "btn_sound";
			if (!_actived) {
				_notif = _date + " : Le son est maintenant activé"
			}else{
				_notif = _date + " : Le son est maintenant désactivé";
			}
		}
		
		/* INTERFACE com.morgan.factory.types.INotify */
		
		public override function getNotificationType():int 
		{
			return NotificationTypeEnum.DOFUS_SOUND_DISABLED_NOTIFICATION;
		}
		public function toString():String 
		{
			return "[DofusSoundDisabledNotification" +_date + " " + _notif +" ]";
		}
	}

}