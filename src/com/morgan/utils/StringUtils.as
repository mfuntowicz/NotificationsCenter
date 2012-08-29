package com.morgan.utils 
{
	/**
	 * ...
	 * @author Morgan
	 */
	public class StringUtils 
	{
		public static function noAccent(source : String) : String
		{
			source = source.replace(/[àáâãäå]/g, "a");
			source = source.replace(/[ÀÁÂÃÄÅ]/g, "A");
			source = source.replace(/[èéêë]/g, "e");
			source = source.replace(/[ËÉÊÈ]/g, "E");
			source = source.replace(/[ìíîï]/g, "i");
			source = source.replace(/[ÌÍÎÏ]/g, "I");
			source = source.replace(/[ðòóôõöø]/g, "o");
			source = source.replace(/[ÐÒÓÔÕÖØ]/g, "O");
			source = source.replace(/[ùúûü]/g, "u");
			source = source.replace(/[ÙÚÛÜ]/g, "U");
			source = source.replace(/[ýýÿ]/g, "y");
			source = source.replace(/[ÝÝŸ]/g, "Y");
			source = source.replace(/[ç]/g, "c");
			source = source.replace(/[Ç]/g, "C");
			source = source.replace(/[ñ]/g, "n");
			source = source.replace(/[Ñ]/g, "N");
			source = source.replace(/[š]/g, "s");
			source = source.replace(/[Š]/g, "S");
			source = source.replace(/[ž]/g, "z");
			source = source.replace(/[Ž]/g, "Z");
			source = source.replace(/[æ]/g, "ae");
			source = source.replace(/[Æ]/g, "AE");
			source = source.replace(/[œ]/g, "oe");
			source = source.replace(/[Œ]/g, "OE");
			return source;
		}
		public static function escapeChatString(s:String):String {
			var pattern : RegExp = new RegExp("&", "g");
			s = s.replace(pattern, "&amp;");
			pattern = new RegExp("{", "g");
			s = s.replace(pattern, "&#123;");
			pattern = new RegExp("}", "g");
			s = s.replace(pattern, "&#125;");
			return s;
		}
	}

}