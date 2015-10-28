package utils
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class mxpTalk extends EventDispatcher
	{
		private var socket:Link=Link.instant;
		
		public function mxpTalk(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function cutMVTalk1():void{
			var s:String="切切成功[emot:dy003]，直播有延时，稍等片刻";
			socket.sendMsg(s);
		}
		public function cutMVTalkError2():void{
			var s:String="你不能切切哦[emot:dy003]想切歌就上土豪榜吧[emot:dy123]";
			socket.sendMsg(s);
		}
		
		public function cutMVTalkError1():void{
			var s:String="你不能切掉比你还大的土豪的歌哦[emot:dy003]";
			socket.sendMsg(s);
		}
		
		private static var _instant:mxpTalk;
		
		public static function get instant():mxpTalk
		{
			if( null == _instant )
			{
				_instant = new mxpTalk();
			}
			return _instant;
		}
	}
}