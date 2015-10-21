package textboard
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import utils.Tools;
	import utils.Util;
	
	import vo.InfoData;
	import vo.MTVInfo;
	import vo.SelectMTVPeople;
	
	
	public class TextBoard extends Sprite
	{
		public static const fontNames:String = "Microsoft YaHei,微软雅黑,MSYaHei,SimHei,Roboto,Arial,_sans";
		
		private var thisW:int;
		private var thisH:int;
		
		private var selectName:TextField;
		private var selectNameStr:String;
		
		public var zhufu:TextField;
		
		private var TempTextArr:Array=new Array();
		
		private var tf1:TextFormat;
		private var tf2:TextFormat;
		
		private var timeline:TimelineMax;
			
//		private var nameMax:Array;
		
		public function TextBoard()
		{
			super();
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.addEventListener(Event.ADDED_TO_STAGE,addTostagehandle);
		}
		
		protected function addTostagehandle(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,addTostagehandle);
			thisW=this.stage.stageWidth-InfoData.TopListWidth;
			thisH=this.stage.stageHeight;
			//
			tf1=new TextFormat(fontNames);
			tf1.size=20;
			tf1.color=0xffffff;
			tf1.align=TextFormatAlign.LEFT;
			tf1.bold=true;
			selectName=new TextField();
			selectName.width=thisW-200;
			selectName.height=35;
			this.addChild(selectName);
			selectName.x=50;
			selectName.y=30;
			selectName.defaultTextFormat=tf1;
			
			//
			tf2=new TextFormat(InfoData.HeitiSC.fontName);
			tf2.size=30;
			tf2.color=0xc118e5;
			tf2.align=TextFormatAlign.CENTER;
			tf2.bold=true;
			zhufu=new TextField();
			zhufu.width=thisW-200;
			zhufu.height=100;
			zhufu.wordWrap=true;
			this.addChild(zhufu);
			zhufu.x=100;
			zhufu.y=thisH-zhufu.height;
			zhufu.defaultTextFormat=tf2;
			zhufu.filters = new Array( new GlowFilter(0Xffffff,1,2,2,255));
			
			
			
//			for (var i:int = 0; i < 80; i++) 
//			{
//				var currtf:TextField=new TextField();
//				this.addChild(currtf);
//				currtf.width=32;
//				if(i<40){
//					currtf.x=selectName.x+(i*20);
//					currtf.y=selectName.y;
//				}else{
//					currtf.x=selectName.x+((i-40)*20);
//					currtf.y=selectName.y+30;
//				}
//				currtf.defaultTextFormat=tf1;
//				TempTextArr.push(currtf);
//			}
			
			timeline = new TimelineMax({repeat:-1, yoyo:true, repeatDelay:2});
			
//			nameMax=TweenMax.allFrom( TempTextArr, 1, {y:"-30", alpha:0, ease:Elastic.easeOut}, 0.04);
//			timeline.insertMultiple(nameMax, 1.4);
//			timeline.append( TweenLite.from(zhufu, 4, {scaleX:0,alpha:0,tint:0x00ff00,ease:Elastic.easeOut}) );
			timeline.insert(TweenLite.from(zhufu, 4, {alpha:0,ease:Elastic.easeOut}) );
		}
		
		public function setText(selectpeople:SelectMTVPeople=null,mv:MTVInfo=null):void{
//			selectName.text="";
//			if(!selectpeople){
//				selectName.text="随机播放: "+mv.name+" No:"+mv.No;
//				zhufu.text="";
//				
//				for (var i:int = 0; i < 80; i++) 
//				{
//					(TempTextArr[i] as TextField).text ="";
//				}
//				timeline.stop();
//				return;
//			}
//
//			
//			if(selectpeople.currYw){
//				selectNameStr="由 "+selectpeople.name+" 点播: "+mv.name+" No："+mv.No+"  本次鱼丸："+selectpeople.currYw*100+"个";
//			}else{
//				selectNameStr="由 "+selectpeople.name+" 点播: "+mv.name+" No："+mv.No;
//			}
//			
//			for (var j:int = 0; j < 80; j++) 
//			{
//				
//				if(j<selectNameStr.length){
//					(TempTextArr[j] as TextField).text = selectNameStr.charAt(j);
//				}else{
//					(TempTextArr[j] as TextField).text ="";
//				}
//				
//			}
//			timeline.play();
//			
//
//			
//			if(selectpeople.message!=null && selectpeople.message!="" && selectpeople.message!="null"){
//				zhufu.text=selectpeople.message;
//			}else{
//				zhufu.text="";
//			}
			if(!selectpeople){
				zhufu.text="";
				timeline.stop();
				return;
			}
			if(selectpeople.message!=null && selectpeople.message!="" && selectpeople.message!="null"){
				zhufu.text=selectpeople.message;
				timeline.play();
			}else{
				zhufu.text="";
				timeline.stop();
			}
		}
		
		
		public function setZhufu(s:String):void{
			var dianbotishi:TextField=new TextField();
			dianbotishi.width=thisW;
			dianbotishi.height=50;
			this.addChild(dianbotishi);
			var tf3:TextFormat=new TextFormat(fontNames,35,0xFF18e5);
			dianbotishi.defaultTextFormat=tf3;
			dianbotishi.text=s;
			dianbotishi.y=Tools.getRandom(100,300);
			dianbotishi.x=thisW;
			dianbotishi.filters = new Array( new GlowFilter(0Xffffff,1,2,2,255));
		    TweenLite.to(dianbotishi,40,{x:-thisW,onComplete:function ():void{
				dianbotishi.parent.removeChild(dianbotishi);	
			}});
		}
		
		//textTextField pool
		
//		private function getTF():TextField
//		{
//			if(textPool.length>0){
//				return textPool.shift();
//			}else{
//				var currtf:TextField=new TextField();
//				currtf.defaultTextFormat=tf1;
//			}
//			return currtf;
//		}
//		
//		private function backTF():void{
//			for each (var i:TextField in TempTextArr) 
//			{
//				var temptext:TextField=TempTextArr.shift();
//				this.removeChild(temptext);
//				textPool.push(temptext);	
//			}
//			
//			
//		}
		
		
		private static var _instant:TextBoard;
		
		public static function get instant():TextBoard
		{
			if( null == _instant )
			{
				_instant = new TextBoard();
			}
			return _instant;
		}
	}
}