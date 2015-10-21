package top
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import database.DataBase;
	
	import textboard.TextBoard;
	
	import vo.InfoData;
	import vo.SelectMTVPeople;
	
	
	public class TopList extends Sprite
	{
		public static var txHeight:int;
		
		[Embed(source="/videos/listTopback.png")]
		protected static const tiaoback:Class;
		
		
		private static const showROW:int=10;//显示20个排队的
		
		private var db:DataBase=DataBase.instant;
		private var infodate:InfoData=InfoData.instant;
		
		private var tabs:Vector.<Tab>=new Vector.<Tab>();
		
		private var movesp:Sprite;
		
		private var tm1:TweenMax;
		
		private var tiaobackbitdata:BitmapData;
		
		public function TopList()
		{
			super();
			this.mouseChildren=false;
			this.mouseEnabled=false;
			this.addEventListener(Event.ADDED_TO_STAGE,addTostageHandle);
		}
		
		protected function addTostageHandle(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,addTostageHandle);
			
			var tiaobitmap:Bitmap=new tiaoback();
			tiaobackbitdata=tiaobitmap.bitmapData;
			
			txHeight=tiaobackbitdata.height-1;
			
			movesp=new Sprite();
			this.addChild(movesp);
			
			for (var i:int = 0; i < showROW; i++) 
			{
				var tab:Tab=new Tab(tiaobackbitdata);
				movesp.addChild(tab)
				tab.setText(String(i+1),"","","");
				tab.y=i*txHeight;
				tabs.push(tab);
			}
			
			var masksp:Shape=new Shape();
			masksp.graphics.beginFill(0,0);
			masksp.graphics.drawRect(0,0,movesp.width,txHeight*6);
			masksp.graphics.endFill();
			this.addChild(masksp);
			movesp.mask=masksp;
		}
		
		public function getTopList():void{
			db.addEventListener(DataBase.GET_SELECTMTV_TOP_COMPLETE,getTopDataComplete);
			db.getTopMTVSForTopList(showROW);
		}
		
		protected function getTopDataComplete(event:Event):void
		{
			db.removeEventListener(DataBase.GET_SELECTMTV_TOP_COMPLETE,getTopDataComplete);
			if(tm1)tm1.kill();
			for (var i:int = 0; i < showROW; i++) 
			{
				if(i<infodate.TopSelectPeoples.length){
					var tempsp:SelectMTVPeople=infodate.TopSelectPeoples[i];
					tabs[i].setText(String(i+1),tempsp.name,String(int(tempsp.currYw*100)),tempsp.MTVids);
				}else{
					tabs[i].setText(String(i+1),"","","");
				}
			}
			
			var moveYstep:int=infodate.TopSelectPeoples.length-6;
			if(moveYstep>0){
			    var timer:int=moveYstep*1;
				var ymove:int=-moveYstep*txHeight;
				movesp.y=0;
				tm1=TweenMax.from(movesp,4,{y:ymove,yoyo:true,repeat:-1,repeatDelay:2,ease:Linear.easeNone});
			}else{
				if(tm1)tm1.kill();
				movesp.y=0;
			}
		}		
		
		private static var _instant:TopList;
		
		public static function get instant():TopList
		{
			if( null == _instant )
			{
				_instant = new TopList();
			}
			return _instant;
		}
	}
}

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import top.TopList;


class Tab extends Sprite{
	
	private var NoTx:TextField;
	private var nameTx:TextField;
	private var YWTx:TextField;
	private var MVNumTx:TextField;
	
	private var tf:TextFormat;
	private var tf2:TextFormat;
	
	
	
	public function Tab(bitmapdata:BitmapData)
	{
		this.addEventListener(Event.ADDED_TO_STAGE,addedToStage);
		this.graphics.beginBitmapFill(bitmapdata);
		this.graphics.drawRect(0,0,bitmapdata.width,bitmapdata.height);
		this.graphics.endFill();
		this.mouseChildren=false;
		this.mouseEnabled=false;
		this.cacheAsBitmap=true;
	}
	
	protected function addedToStage(event:Event):void
	{
		this.removeEventListener(Event.ADDED_TO_STAGE,addedToStage);
		NoTx=new TextField();
		nameTx=new TextField();
		YWTx=new TextField();
		MVNumTx=new TextField();
		
//		NoTx.border=true;
//		nameTx.border=true;
//		YWTx.border=true;
//		MVNumTx.border=true;
		
		NoTx.width=15;
		NoTx.height=TopList.txHeight;
		nameTx.width=50;
		nameTx.height=TopList.txHeight;
		YWTx.width=40;
		YWTx.height=TopList.txHeight;
		MVNumTx.width=50;
		MVNumTx.height=TopList.txHeight;
		
		this.addChild(NoTx);
		this.addChild(nameTx);
		this.addChild(YWTx);
		this.addChild(MVNumTx);
		
		nameTx.x=15;
		YWTx.x=65;
		MVNumTx.x=105;
		
		tf=new TextFormat();
		tf.align=TextFormatAlign.CENTER;
		tf.color=0xffffff;
//		tf.bold=true;
		tf.size=12;
		nameTx.defaultTextFormat=MVNumTx.defaultTextFormat=NoTx.defaultTextFormat=YWTx.defaultTextFormat=tf;
		NoTx.wordWrap=MVNumTx.wordWrap=YWTx.wordWrap=nameTx.wordWrap=true;
//		MVNumTx.autoSize=nameTx.autoSize=TextFieldAutoSize.CENTER;
		
	}
	
	public function setText(no:String,names:String,yw:String,mvNum:String):void{
		NoTx.text="      "+no;
		nameTx.text=names;
		switch(nameTx.numLines)
		{
			case 1:
			{
				nameTx.text="\n"+names;
				break;
			}
			default:
			{
				break;
			}
		}
		YWTx.text=yw;
		switch(YWTx.numLines)
		{
			case 1:
			{
				YWTx.text="\n"+yw;
				break;
			}
			case 2:
			{
				YWTx.text="\n"+yw;
				break;
			}	
			default:
			{
				break;
			}
		}
		MVNumTx.text=mvNum;	
		switch(MVNumTx.numLines)
		{
			case 1:
			{
				MVNumTx.text="\n"+mvNum;
				break;
			}
			
			default:
			{
				break;
			}
		}
	}
	
}