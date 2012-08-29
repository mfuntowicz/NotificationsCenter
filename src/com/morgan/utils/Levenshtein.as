package com.morgan.utils 
{
	/**
	 * Morgan
	 * @author Morgan
	 */
	public class Levenshtein 
	{
		
		public function Levenshtein() 
		{
		}
		public static function distance(s1:String, s2:String):int {
			if (s1 == null || s2 == null) {
				return;
			}
			if (s1.length < s2.length) {
				var temp : String = s1;
				s1 = s2;
				s2 = temp;
			}
			
			var m : int = s1.length;
			var n : int = s2.length;
			var currentRow : int = 0;
			var previousRow : int = 0;
			
			var distance :Vector.<Vector.<int>> = new Vector.<Vector.<int>>(m + 1,true);
			for (var i:int = 1; i <= m ; i++) distance[0, i] = i;
			
			for (var i:int = 1; i <= n; i++) 
			{
				currentRow = i & 1;
				distance[currentRow] = i;
				previousRow = i ^ 1;
				for (var j:int = 1; j <= m ; j++) 
				{
					var d : int = (s2.charAt(j - 1) == s1.charAt(i - 1) ? 0 : 1);
					distance[currentRow, j] = Math.min(Math.min(distance[previousRow, j] +1, distance[currentRow, j - 1] + 1), distance[previousRow, j - 1] + d);
				}
			}
			
			return distance[currentRow, m];
		}
	}
}