package com.morgan.factory.types.impl.levels 
{
	import com.morgan.factory.types.INotify;
	import com.morgan.factory.types.Notification;
	import com.morgan.factory.types.NotificationTypeEnum;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class JobLevelUpNotification extends Notification implements INotify 
	{
		private var _jobName: String; 
		private var _newLevel:uint; 
		
		public function JobLevelUpNotification(jobName:String, newLevel : uint) 
		{
			super();
			_jobName = jobName;
			_newLevel = newLevel;
			_icon = "btn_job";
			_notif = _date + " : Votre métier de " + _jobName + " passe niveau " + _newLevel;
		}
		
		/* INTERFACE com.morgan.factory.types.INotify */
		
		override public function getNotificationType():int 
		{
			return NotificationTypeEnum.JOB_LEVEL_UP_NOTIFICATION;
		}
		
		public function get jobName():String 
		{
			return _jobName;
		}
		
		public function get newLevel():String 
		{
			return _newLevel.toString();
		}
		
		public function toString():String 
		{
			return "[JobLevelUpNotification date=" + _date + " jobName=" + jobName + " newLevel=" + newLevel + "]";
		}
	}

}