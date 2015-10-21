package utils
{
	public class Tools
	{
		public function Tools()
		{
		}
		public static function getRandom(min:int,max:int):int{
			return Math.floor(Math.random()*(max-min+1)+min);
		} 
		
		public static function randomArr(arr:*):*
		{
			var outputArr:Vector.<*> = arr.slice();
			var i:int = outputArr.length;
			var temp:*;
			var indexA:int;
			var indexB:int;
			
			while (i)
			{
				indexA = i-1;
				indexB = Math.floor(Math.random() * i);
				i--;
				
				if (indexA == indexB) continue;
				temp = outputArr[indexA];
				outputArr[indexA] = outputArr[indexB];
				outputArr[indexB] = temp;
			}
			
			return outputArr;
		}
		
	}
}