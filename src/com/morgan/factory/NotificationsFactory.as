package com.morgan.factory 
{
	import d2hooks.JobLevelUp;
	import com.morgan.factory.types.impl.dofus.DofusMaintenanceNotification;
	import com.morgan.factory.types.impl.dofus.DofusSoundDisabledNotification;
	import com.morgan.factory.types.impl.levels.JobLevelUpNotification;
	import com.morgan.factory.types.impl.party.GroupeInvitationNotification;
	import com.morgan.factory.types.impl.party.KolizeumInvitationNotification;
	import com.morgan.factory.types.impl.social.FriendConnectionNotification;
	import com.morgan.factory.types.impl.social.MPNotification;
	import com.morgan.factory.types.Notification;
	import com.morgan.factory.types.impl.fight.DeadInFightNotification;
	import com.morgan.factory.types.impl.levels.PlayerLevelUpNotification;
	import com.morgan.factory.types.impl.social.GuildInvitationNotification;
	import com.morgan.factory.types.INotify;
	import com.morgan.factory.types.NotificationTypeEnum;
	/**
	 * ...
	 * @author Morgan
	 */
	public class NotificationsFactory 
	{
		
		public function NotificationsFactory() 
		{
			
		}
		/**
		 * 
		 * @param	int type l'id de la notification dans NotificationTypeEnum
		 * @param	...rest paramètres pour le constructeur de la notification
		 * @return renvoie un élément INotify implémentée par toutes les sous classes de Notification
		 */
		public static function getNotification(type:int, ...rest):INotify {
			var notification : INotify;
			
			switch(type) {
				case NotificationTypeEnum.ANKABOX_MAIL_NOTIFICATION : {
					throw new Error("Not Implemented Yet");
					break;
				}
				case NotificationTypeEnum.DIARY_EVENT_NOTIFICATION : {
					throw new Error("Not Implemented Yet");
					break;
				}
				case NotificationTypeEnum.DOFUS_MAINTENANCE_NOTIFICATION : {
					if (rest.length !=  1) {
						throw new Error("Impossible de créer la notification DofusMaintenanceNotification pas assez d'arguments");
					}
					notification = new DofusMaintenanceNotification(rest[0]);
					break;
				}
				case NotificationTypeEnum.DOFUS_SOUND_DISABLED_NOTIFICATION : {
					if (rest.length < 1) {
						throw new Error("Impossible de créer la notification DofusSoundDisable, pas assez d'arguments");
					}
					notification = new DofusSoundDisabledNotification(rest[0]);
					break;
				}
				case NotificationTypeEnum.EXCHANGE_NOTIFICATION : {
					throw new Error("Not Implemented Yet");
					break;
				}
				case NotificationTypeEnum.DEAD_IN_FIGHT_NOTIFICATION : {
					notification = new DeadInFightNotification();
					break;
				}
				case NotificationTypeEnum.FRIEND_CONNECTION_NOTIFICATION : {
					if (rest.length != 1) {
						throw new Error("Impossible de créer la notification FriendConnectionNotification, nombre d'arguments incorrect");
					}
					notification = new FriendConnectionNotification(rest[0]);
					break;
				}
				case NotificationTypeEnum.GROUP_INVITATION_NOTIFICATION : {
					if (rest.length != 1) {
						throw new Error("Impossible de créer la notification GroupeInvitationNotification, nombre d'arguments incorrect");
					}
					notification = new GroupeInvitationNotification(rest[0]);
					break;
				}
				case NotificationTypeEnum.GUILDE_INVITATION_NOTIFICATION : {
					if (rest.length < 2) {
						throw new Error("Impossible de créer la notification Player Level UP, pas assez d'arguments");
					}
					notification = new GuildInvitationNotification(rest[0], rest[1]);
					break;
				}
				case NotificationTypeEnum.JOB_LEVEL_UP_NOTIFICATION : {
					if (rest.length != 2) {
						throw new Error("Impossible de créer la notification Job Level UP, pas assez d'arguments");
					}
					notification = new JobLevelUpNotification(rest[1], rest[2]);
					break;
				}
				case NotificationTypeEnum.KAMAS_IO_NOTIFICATION : {
					break;
				}
				case NotificationTypeEnum.KOLIZEUM_INVITATION_NOTIFICATION : {
					if (rest.length != 1) {
						throw new Error("Impossible de créer la notification KolizeumInvitationNotification, nombre d'arguments incorrect");
					}
					notification = new KolizeumInvitationNotification(rest[0]);
					break;
				}
				case NotificationTypeEnum.MP_NOTIFICATION : {
					notification = new MPNotification(rest[0], rest[1]);
					break;
				}
				case NotificationTypeEnum.PET_NOTIFICATION : {
					throw new Error("Not Implemented Yet");
					break;
				}
				case NotificationTypeEnum.PLAYER_LEVEL_UP_NOTIFICATION : {
					if (rest.length < 1 ) {
						throw new Error("Impossible de créer la notification Player Level UP, pas assez d'arguments");
					}
					notification = new PlayerLevelUpNotification(rest[0]);
					break;
				}
				default : {
					return new Notification();
				}
			}
			
			return notification;
		}
		
	}

}