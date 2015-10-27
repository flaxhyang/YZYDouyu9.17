package mmBoard
{
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import utils.Tools;
	
	import vo.InfoData;
	import vo.MTVInfo;
	import vo.SelectMTVPeople;
	
	
	public class MMBoard extends Sprite
	{
        private var mmVecs:Vector.<MMVo>=new Vector.<MMVo>();	
		private var mmlength:int;
		
		private var TextWord:TextField;
		private var tf:TextFormat;
		
		
		private var imagaLoader:Loader;
		
		private var currNum:int;
		private var currMMvo:MMVo;
		
		private var infodata:InfoData=InfoData.instant;
		
		public function MMBoard()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandle);
		}
		
		protected function addToStageHandle(event:Event):void
		{
			
			imagaLoader=new Loader();
			this.addChild(imagaLoader);
			//
			TextWord=new TextField();
			TextWord.wordWrap=true;
			TextWord.multiline=true;
			this.addChild(TextWord);
			tf=new TextFormat("",22,0xffffff);
			TextWord.defaultTextFormat=tf;
			//
			var textload:URLLoader=new URLLoader();
			var txtURLRequest:URLRequest=new URLRequest(InfoData.mmURL);
			textload.addEventListener(Event.COMPLETE,noticeHandle);
			textload.load(txtURLRequest);
			
			
		}
		
		protected function noticeHandle(event:Event):void
		{
			var mmdataArr:Array=String(event.target.data).split("\r\n");	
//			trace(mmdataArr.length);
//			trace(mmdataArr[1]);
			for (var i:int = 0; i < mmdataArr.length; i++) 
			{
				var mmdata:Array=mmdataArr[i].split(",");
				var mmvo:MMVo=new MMVo();
				mmvo.name=mmdata[0];
				mmvo.xp=mmdata[1];
				mmvo.yp=mmdata[2];
				mmvo.w=mmdata[3];
				mmvo.h=mmdata[4];
				mmVecs.push(mmvo);
			}
			mmlength=mmVecs.length-1;
		}
		
		
		public function titleWord(thName:String=null,selectpeople:SelectMTVPeople=null,mv:MTVInfo=null):void{
			var str:String="";
			var fontName:String=InfoData.HeitiSC.fontName;
			
			if(thName!=null){
				str="<b><font face='"+fontName+"'><font  color='#ffffff'>热泪欢迎:</font>  <font color='#FFFF00'>"+thName+"！</font> <font color='#FFFFFF' size='15'><br/>大土豪! 光临！</font></font></b>";
			}else if(!selectpeople){
				str="<b><font face='"+fontName+"'> 随机播放: <br/><font size='15'>"+mv.name+"</font> <font color='#ffff00'><br/>No:"+mv.No+"</font></font></b>";
			}else{
				
				if(int(selectpeople.currYw)>0){
					str="<b><font face='"+fontName+"' size='18'><font color='#0000ff'>"+ selectpeople.name+"</font> 点播: <br/><font size='12'>"+mv.name+"</font><br/>No.<font color='#ffff00'>"+mv.No+" </font><br/>本次鱼丸:<font color='#ffff00'>"+selectpeople.currYw*100+"</font>个 </font> </b>";
				}else{
					str="<b><font face='"+fontName+"' size='20'><font color='#000000ff'>"+selectpeople.name+"</font> 点播: <font size='15'><br/>"+mv.name+"</font> <br/><font color='#ffff00'>No："+mv.No +"</font></font></b>";
				}
				
			}
			setWord(str);
			
			//设置当前点歌的人的信息
			if(thName==null){
				if(selectpeople){
					infodata.currSelectPeople=selectpeople;
				}else{
					infodata.currSelectPeople=null;
				}
			}
		}
		
		public function setWord(s:String):void{
			currNum=Tools.getRandom(0,mmlength);
			currMMvo=mmVecs[currNum];
			imagaLoader.removeChildren();
			imagaLoader.load(new URLRequest(InfoData.mmImage+currMMvo.name));
			TextWord.x=currMMvo.xp;
			TextWord.y=currMMvo.yp;
			TextWord.width=currMMvo.w;
			TextWord.height=currMMvo.h;
			TextWord.htmlText=s;
		}
		
		
		private function setWord2(s1:String,s2:String,s3:String,s4:String):void{
			
		}
		
		private static var _instant:MMBoard;
		public static function get instant():MMBoard
		{
			if( null == _instant )
			{
				_instant = new MMBoard();
			}
			return _instant;
		}
	}
}