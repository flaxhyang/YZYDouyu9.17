package utils
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class mxpTalk extends EventDispatcher
	{
		private var socket:Link=Link.instant;
		private var time:Timer;
	    private var setTime:Boolean=true;
		private var msgs:Vector.<String>=new Vector.<String>();
		private var lastmsg:String="";
		
		public function mxpTalk(target:IEventDispatcher=null)
		{
			super(target);
			time=new Timer(5000);
			time.addEventListener(TimerEvent.TIMER,timerCompletefun);
		}
		
		
		//-----------------------------------------------------------------------
		public function cutMVTalk1():void{
			var s:String="切切成功[emot:dy003]，直播有延时，稍等片刻";
			addNewMsg(s);
		}
		
		//-----------------------------------------------------------------------
		public function cutMVTalkError3():void{
			var s:String="在大也不能切房主的歌哦[emot:dy003]";
			addNewMsg(s);
		}
		
		//-----------------------------------------------------------------------
		public function cutMVTalkError2():void{
			var s:String="你不能切切哦[emot:dy003]想切歌就上土豪榜吧[emot:dy123]";
			addNewMsg(s);
		}
		
		//-----------------------------------------------------------------------
		public function cutMVTalkError1():void{
			var s:String="你不能切掉比你还大的土豪的歌哦[emot:dy003]";
			addNewMsg(s);
		}
		
		
		public function addNewMsg(s:String):void{
			msgs.push(s);
			if(!time.running){
				time.start();
				sendMsg();
			}
		}
		
		private function timerCompletefun(event:TimerEvent):void
		{
			if(msgs.length>0){
				time.reset();
				sendMsg();
			}else{
				time.stop();
			}
			
		}
		
		private function sendMsg():void{
			var s:String=checkAgain(msgs.shift());
			socket.sendMsg(s);
		}
		
		
		
		private function checkAgain(s:String):String{
		    if(s==lastmsg){
				return "[emot:dy123]"+s;
			}
			
			return s;
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