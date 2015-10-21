package selectBoard
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import textboard.TextBoard;
	
	import vo.InfoData;
	
	public class Notice extends Sprite
	{
		private var noticeArr:Array;
		private var niticeTxt:TextField;
		
		private var currnum:int=0;
		private var showTime:Timer=new Timer(10000);
		
		public function Notice()
		{
			super();
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.cacheAsBitmap=true;
		}
		
		
		public function init():void{
			var textload:URLLoader=new URLLoader();
			var txtURLRequest:URLRequest=new URLRequest(InfoData.noticeURL);
			textload.addEventListener(Event.COMPLETE,noticeHandle);
			textload.load(txtURLRequest);
			//
			niticeTxt=new TextField();
			niticeTxt.width=148;
			niticeTxt.height=115;
			niticeTxt.wordWrap=true;
//			niticeTxt.background=true;
//			niticeTxt.backgroundColor=0xff0000;
			
			var tf:TextFormat=new TextFormat(TextBoard.fontNames,18,0xffff66,true);
			tf.align=TextFormatAlign.CENTER;
			tf.leading=3; 
			niticeTxt.defaultTextFormat=tf;
			this.addChild(niticeTxt);
			
			showTime.addEventListener(TimerEvent.TIMER,showtimeHandle);
		}
		
		
		protected function noticeHandle(event:Event):void
		{
			noticeArr=String(event.target.data).split(";");
			niticeTxt.text=noticeArr[0];
			currnum++;
			showTime.start();
		}
		
		
		protected function showtimeHandle(event:TimerEvent):void
		{
			niticeTxt.text=noticeArr[currnum];
//			trace(niticeTxt.text);
//			trace(niticeTxt.numLines);
			switch(niticeTxt.numLines)
			{
				case 5:
				{
					niticeTxt.y=0;
					break;
				}
				case 4:
				{
					niticeTxt.y=5;
					break;
				}
				case 3:
				{
					niticeTxt.y=15;
					break;
				}
				case 2:
				{
					niticeTxt.y=30;
					break;
				}
				default:
				{
					niticeTxt.y=0;
					break;
				}
			}
			currnum++;
			if(currnum>=noticeArr.length){
				currnum=0;
			}
		}
		
		
		private static var _instant:Notice;
		
		public static function get instant():Notice
		{
			if( null == _instant )
			{
				_instant = new Notice();
			}
			return _instant;
		}
	}
}