package com.morgan.factory.types.impl.exchange 
{
	import ui.factory.types.INotify;
	import ui.factory.types.Notification;
	import ui.factory.types.NotificationTypeEnum;
	
	/**
	 * ...
	 * @author Morgan
	 */
	public class ExchangeNotification extends Notification implements INotify 
	{
		private var _sender : String; 
		public function ExchangeNotification(sender : String) 
		{
			super();
			_sender = sender;
			_icon = "pony_tx_state0";
			//_notif = _date + " : Le joueur {player," +_sender + "} a lancé un échange avec vous";
			_notif = _date + " : Le joueur " +_sender + " a lancé un échange avec vous";
		}
		
		/* INTERFACE ui.factory.types.INotify */
		
		public override function getNotificationType():int 
		{
			return NotificationTypeEnum.EXCHANGE_NOTIFICATION;
		}
		public function toString():String 
		{
			return "[ExchangeNotification _date=" + _date + " notification : " + _notif + "]";
		}
	}

}