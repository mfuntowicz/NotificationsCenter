package com.morgan.factory.types.impl.social 
{
	import com.morgan.utils.StringUtils;
	import d2data.Effect;
	import ui.api.API;
	import com.morgan.factory.types.INotify;
	import com.morgan.factory.types.Notification;
	import com.morgan.factory.types.NotificationTypeEnum;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class MPNotification extends Notification implements INotify 
	{
		private var _sender : String;
		private var _msg : String;
		public function MPNotification(sender:String,msg:String) 
		{
			super();
			var splitted : Array = sender.split(",");
			_sender = splitted[0];
			_msg = splitted[1];
			//_notif = _date + " Vous avez reçu un MP de {player," + _sender + "} : " + _msg; 
			if (_msg.indexOf("recipe") != -1) {
				var pattern : RegExp = new RegExp(/\{recipe, ([1-9]+)\}/g);
				var objectID : String = _msg.match(pattern)[1];
				if (objectID && objectID != "") {
					_msg.replace(pattern, API.chatApi.getStaticHyperlink(StringUtils.escapeChatString("{recipe," + objectID + "}"))); 
				}
			}
			_notif = _date + " : Nouveau message de " + _sender + " : " + _msg; 
			_icon = "btn_mp";
		}
		override public function getNotification():String  
		{
			return _notif; 
		}
		override public function getNotificationType():int 
		{
			return NotificationTypeEnum.MP_NOTIFICATION;
		}
		
		/*public function get notification():String {
			return _notif; 
		}*/
		
		public function get msg():String 
		{
			return _msg;
		}		
		public function get sender():String 
		{
			return _sender;
		}
		public function toString():String 
		{
			return "[MPNotification date=" + date + " msg=" + msg + " sender=" + sender + "]";
		}
		
	}

}