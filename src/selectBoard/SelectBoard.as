package selectBoard
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import database.DataBase;
	
	import textboard.TextBoard;
	
	import top.TopList;
	
	import vo.InfoData;
	import vo.MTVInfo;
	
	public class SelectBoard extends Sprite
	{
//		[Embed(source="/videos/back.jpg")]
//		protected static const back:Class;
		
//		[Embed(source="/videos/douyuback0302.png")]
		[Embed(source="/videos/douyuback0310.png")]
		protected static const back:Class;
		
//		private const imageurl:String="/videos/image/";
		
		private var mask1:Shape;
		private var mask2:Shape;
		private var mask3:Shape;
		
		private var mvList1:Sprite;
		private var mvList2:Sprite;
		private var mvList3:Sprite;
		
		private var topList:TopList;
		
		private var infodata:InfoData=InfoData.instant;
		private var db:DataBase=DataBase.instant;
		
		private var tl:TweenLite;
		private var t2:TweenLite;
		private var t3:TweenLite;
		
		private var isInit:Boolean;
		
		private var tm1:TweenMax;
		private var tm2:TweenMax;
		private var tm3:TweenMax;
		
		private var interval:Timer;
		private var currIntervalStep:int=0;
		private var aspect:int=-1;
		
		public function SelectBoard()
		{
			super();
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.cacheAsBitmap=true;
			
			interval=new Timer(3000);
			interval.addEventListener(TimerEvent.TIMER,intervalHandle);
			
			this.addEventListener(Event.ADDED_TO_STAGE,addTohandle);
		}
		
		
		
		protected function addTohandle(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,addTohandle)
			var backimage:Bitmap=new back();
			this.addChild(backimage);
			backimage.height=827;
			
			mvList1=new Sprite();
			mvList2=new Sprite();
			mvList3=new Sprite();
			
			mask1=new Shape();
			mask1.graphics.beginFill(0xff0000);
			mask1.graphics.drawRoundRect(0,0,147,147,10,10);
			mask1.graphics.endFill();
			
			mask2=new Shape();
			mask2.graphics.beginFill(0);
			mask2.graphics.drawRoundRect(0,0,147,147,10,10);
			mask2.graphics.endFill();
			
			mask3=new Shape();
			mask3.graphics.beginFill(0);
			mask3.graphics.drawRect(0,0,195,130);
			mask3.graphics.endFill();
			
			
			this.addChild(mvList1);
			this.addChild(mask1);
			mvList1.x=mask1.x=410;
			mvList1.y=mask1.y=190;
			mvList1.mask=mask1;
			
			this.addChild(mvList2);
			this.addChild(mask2);
			mvList2.x=mask2.x=410;
			mvList2.y=mask2.y=376;
			mvList2.mask=mask2;
			
//			this.addChild(mvList3);
//			this.addChild(mask3);
//			mvList3.x=mask3.x=2;
//			mvList3.y=mask3.y=338;
//			mvList3.mask=mask3;
			
//			get1info();
			
			initTopList();
			
//			var titleTF:TextFormat=new TextFormat(TextBoard.fontNames,15,0xffff99,true);
//			titleTF.align=TextFormatAlign.CENTER;
//			var title1:TextField=new TextField();
//			title1.mouseEnabled=false;
//			this.addChild(title1);
//			title1.defaultTextFormat=titleTF;
//			title1.text="新歌推荐";
//			title1.x=437;
//			title1.y=110;
			
//			var title2:TextField=new TextField();
//			title2.mouseEnabled=false;
//			this.addChild(title2);
//			title2.defaultTextFormat=titleTF;
//			title2.text="热歌榜";
//			title2.x=430;
//			title2.y=343;
			
//			var title3:TextField=new TextField();
//			title3.mouseEnabled=false;
//			this.addChild(title3);
//			title3.defaultTextFormat=titleTF;
//			title3.text="点歌榜";
//			title3.x=424;
//			title3.y=574;
		}
		
		private function initTopList():void
		{
			topList= TopList.instant;
			this.addChild(topList);
			topList.x=407;
			topList.y=575;
			//
			topList.getTopList();
		}		
		
		/**
		 * 
		 * 
		 */		
		public function changeTopList():void{
			topList.getTopList();
		}
		
		
		
		public function get1info():void{
			if(tm1)tm1.kill();
			infodata.addEventListener(InfoData.GETMVINFOS_COMPLETE_EVENT,info1Handle);
			db.selectNewMVinfos()
		}
		private function get2info():void{
			if(tm2)tm2.kill();
			infodata.addEventListener(InfoData.GETMVINFOS_COMPLETE_EVENT,info2Handle);
			db.selectMaxMv()
		}
		private function get3info():void{
			if(tm3)tm3.kill();
			infodata.addEventListener(InfoData.GETMVINFOS_COMPLETE_EVENT,info3Handle);
			db.selectMVinfos(5)
		}
		
		protected function info1Handle(event:Event):void
		{
			infodata.removeEventListener(InfoData.GETMVINFOS_COMPLETE_EVENT,info1Handle);
			
			interval.start();
			
			var num:int=infodata.showMVinfoVes.length;
			var currNum:int=0;
			for (var i:int = 0; i < num; i++) 
			{
				
					var info:MTVInfo=infodata.showMVinfoVes[currNum];
					var im:ImageMv=new ImageMv();
					im.setImaageMV(info.No,info.name,InfoData.MTVImage+info.image);
//					im.setImaageMV(info.No,info.name,"/videos/606.jpg");
					mvList1.addChild(im);
					
					im.x=i*(im.width+2);
					currNum++;
				
			}
			
			
			mvList1.x=mask1.x;
			//
			get2info();
		}
		protected function info2Handle(event:Event):void
		{
			infodata.removeEventListener(InfoData.GETMVINFOS_COMPLETE_EVENT,info2Handle);
			
			var num:int=infodata.showMVinfoVes.length;
			var currNum:int=0;
			for (var i:int = 0; i < num; i++) 
			{
					var info:MTVInfo=infodata.showMVinfoVes[currNum];
					var im:ImageMv=new ImageMv();
					im.setImaageMV(info.No,info.name,InfoData.MTVImage+info.image);
// 					im.setImaageMV(info.No,info.name,"/videos/606.jpg");
					mvList2.addChild(im);
					
					im.x=i*(im.width+2);
					currNum++;
			}
			//
			mvList2.x=mask1.x-(mvList2.width-147);
			//
		}
		protected function info3Handle(event:Event):void
		{
			infodata.removeEventListener(InfoData.GETMVINFOS_COMPLETE_EVENT,info3Handle);
			mvList3.x=0;
			isInit=mvList3.numChildren;
			for (var i:int = 0; i < infodata.showMVinfoVes.length; i++) 
			{
				var info:MTVInfo=infodata.showMVinfoVes[i]
				if(isInit){
					(mvList3.getChildAt(i) as ImageMv).setImaageMV(info.No,info.name,InfoData.MTVImage+info.image)
				}else{
					var im:ImageMv=new ImageMv();
					im.setImaageMV(info.No,info.name,InfoData.MTVImage+info.image);
					mvList3.addChild(im);
					im.x=i*(im.width+2);
				}
			}
			//
//			setList3(mvList3);
			//
		}
		
		//utils
//		private function setList1(listsp:Sprite):void{
//			var xmove:int=-1*(listsp.width-mask1.width-mask1.x);
//			tm1=TweenMax.to(listsp,80,{x:xmove,yoyo:true,repeat:-1,ease:Linear.easeNone});
//			tm1.play();
			
//		} 
//		private function setList2(listsp:Sprite):void{
//			var xmove:int=-1*(listsp.width-mask1.width-mask1.x);
//			tm2=TweenMax.to(listsp,80,{x:xmove,yoyo:true,repeat:-1,ease:Linear.easeNone});
//			tm2.play();
//		} 
		private function setList3(listsp:Sprite):void{
			var xmove:int=listsp.width>195?-1*(listsp.width-195):-100;
			tm3=TweenMax.to(listsp,40,{x:xmove,yoyo:true,repeat:-1,ease:Linear.easeNone});
			tm3.play();
		} 
		
	
		protected function intervalHandle(event:TimerEvent):void
		{
			if(currIntervalStep>=29){
				currIntervalStep=0;
				aspect=-1*aspect;
			}
			var movex:int=mvList1.x+aspect*149;
			tm1=TweenMax.to(mvList1,1,{x:movex});
			tm1.play();
			
			var movex2:int=mvList2.x-aspect*149;
			tm2=TweenMax.to(mvList2,1,{x:movex2});
			tm2.play();
			
			currIntervalStep++;
		}
		
		private static var _instant:SelectBoard;
		
		
		public static function get instant():SelectBoard
		{
			if( null == _instant )
			{
				_instant = new SelectBoard();
			}
			return _instant;
		}
	}
}