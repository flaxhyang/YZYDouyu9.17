package utils
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import vo.InfoData;
	
	
	
	public class Authority extends EventDispatcher
	{
		public function Authority(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		private var infoData:InfoData=InfoData.instant;
		private var mxptalk:mxpTalk=mxpTalk.instant;
		
		/**
		 *  是否拥有特权：1.点歌不扣鱼丸，2.能点隐藏歌曲
		 * @param id
		 * @return 
		 */		
		public function privilege(id:int):Boolean{
			if(infoData.isGM(id)){
				return true;
			};
			
			if(isYWTop(id)>-1){
				return true;
			}
			return false;
		}
		
		public function isNext(id:int):Boolean{
			if(infoData.isGM(id)){
				mxptalk.cutMVTalk1();
				return true;
			};
			var currywNum:int=isYWTop(id);
			if(currywNum<0){
				mxptalk.cutMVTalkError2();
				return false;
			}
			if(infoData.currSelectPeople==null){
			   mxptalk.cutMVTalk1();
			   return true;
			}else{
				var currPlayNum:int=isYWTop(infoData.currSelectPeople.id);
				if(currywNum>=currPlayNum){
					mxptalk.cutMVTalk1();
					return true;
				}else{
					mxptalk.cutMVTalkError1();
				}
			}
			return false;
		}
		
		
		
		private function isYWTop(id:int):int{
			var num:int=-1;
			for (var i:int = 0; i < infoData.topYWVector.length; i++) 
			{
				if(id==infoData.topYWVector[i].id){
					return i;
				}
			}
			
			return num;	
		}
		
		private static var _instant:Authority;
		
		public static function get instant():Authority
		{
			if( null == _instant )
			{
				_instant = new Authority();
			}
			return _instant;
		}
	}
}