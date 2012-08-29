package com.morgan.utils 
{
	/**
	 * ...
	 * @author Morgan
	 */
	public class ArrayUtils 
	{
		
		public function ArrayUtils() 
		{
			
		}
		
		public static function removeFromArray(a:Array, value:*):Array {
			var n : int = a.length - 1;
			var found : Boolean = false;
			do {
				if (a[n] == value) {
					a.splice(n, 1);
					found = true;
				}
			}while (--n >= 0 && !found);
		}
	}

}