package ui.api 
{
	import d2api.CaptureApi;
	import d2api.ChatApi;
	import d2api.ConfigApi;
	import d2api.DataApi;
	import d2api.ExchangeApi;
	import d2api.FightApi;
	import d2api.FileApi;
	import d2api.JobsApi;
	import d2api.PartyApi;
	import d2api.PlayedCharacterApi;
	import d2api.SocialApi;
	import d2api.SystemApi;
	import d2api.UiApi;
	/**
	 * ...
	 * @author Morgan
	 */
	public class API 
	{
		public static var systApi : SystemApi;
		public static var uiApi : UiApi;
		public static var chatApi : ChatApi;
		public static var socialApi : SocialApi;
		public static var fightApi : FightApi;
		public static var exchangeApi : ExchangeApi;
		public static var jobsApi : JobsApi;
		public static var playerApi : PlayedCharacterApi;
		public static var partyApi : PartyApi;
		public static var dataApi : DataApi;
		public static var fileApi : FileApi;
		public static var captureApi:CaptureApi;
		public static var configApi:ConfigApi;
		
		public function API() 
		{
			
		}
		
	}

}