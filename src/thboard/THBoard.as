package thboard
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import database.DataBase;
	
	import textboard.TextBoard;
	
	import vo.InfoData;
	
	public class THBoard extends Sprite
	{
		private var textArr:Vector.<tioa>=new Vector.<tioa>();
		private var dataBase:DataBase;
		private var infoData:InfoData;
		
		private var thsp:Sprite;
		
		private var tm1:TweenMax;
		private var moveY:int;
		
		public function THBoard()
		{
			super();
			this.mouseChildren=false;
			this.mouseEnabled=false;
			
		}
		
		public function init():void{
			if(!infoData){
				infoData=InfoData.instant;
			}
			
			var title2:tioa=new tioa(-1,18);
			this.addChild(title2);
			title2.init();
			title2.setText("No","土豪","鱼丸","留言",false);
//			title2.y=14;
			
			thsp=new Sprite();
			this.addChild(thsp);
			
			for (var i:int = 0; i < 10; i++) 
			{
				var currt:tioa=new tioa(i);
				thsp.addChild(currt);
				currt.init();
				currt.y=i*24;
				textArr.push(currt);	
			}
			
			var masksp:Shape=new Shape();
			masksp.graphics.beginFill(0,0);
			masksp.graphics.drawRect(0,0,title2.width+2,115);
			masksp.graphics.endFill();
			this.addChild(masksp);
			masksp.y=thsp.y=19;
			
			thsp.mask=masksp;
			
			moveY=-105;
			tm1=TweenMax.to(thsp,10,{y:moveY,yoyo:true,repeat:-1,repeatDelay:3,ease:Linear.easeNone});
		}
		
		
		public function getData():void{
			if(!dataBase){
				dataBase=DataBase.instant;
			}
			dataBase.addEventListener(DataBase.GET_TOPYW_COMPLETE,topYWComplete);
			dataBase.addEventListener(DataBase.GET_TOPYW_ERROR,topYWError);
			dataBase.getTopYWPeople();
		}
		
		
		protected function topYWComplete(event:Event):void
		{
			dataBase.removeEventListener(DataBase.GET_TOPYW_COMPLETE,topYWComplete);
			dataBase.removeEventListener(DataBase.GET_TOPYW_ERROR,topYWError);
			for (var i:int = 0; i < textArr.length; i++)
			{
				textArr[i].setText(String(i+1),infoData.topYWVector[i].name,String(infoData.topYWVector[i].sumYW),infoData.topYWVector[i].leaveWord);
			}
		}
		
		protected function topYWError(event:Event):void
		{
			dataBase.removeEventListener(DataBase.GET_TOPYW_COMPLETE,topYWComplete);
			dataBase.removeEventListener(DataBase.GET_TOPYW_ERROR,topYWError);
		}
		
		private static var _instant:THBoard;
		
		public static function get instant():THBoard
		{
			if( null == _instant )
			{
				_instant = new THBoard();
			}
			return _instant;
		}
	}
}
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import textboard.TextBoard;

class tioa extends Sprite{
	private var No1tf:TextFormat;
	private var No2tf:TextFormat;
	private var No3tf:TextFormat;
	private var tf2:TextFormat;
	private	var NumText:TextField;
	private var nameText:TextField;
	private var ywText:TextField;
	private var lyText:TextField;
	
	private var th:int;
	private var thisNo:int;
	
	public function tioa(No:int,height:int=24){
		th=height;
		thisNo=No;
		this.mouseEnabled=false;
		this.mouseChildren=false;
		this.cacheAsBitmap=true;
	}
	
	public function init():void
	{
		No1tf=new TextFormat(TextBoard.fontNames,12,0x00ff00,true);
		No1tf.align=TextFormatAlign.CENTER;
		
		No2tf=new TextFormat(TextBoard.fontNames,12,0xffff00,true);
		No2tf.align=TextFormatAlign.CENTER;
		
		No3tf=new TextFormat(TextBoard.fontNames,12,0xffff00,true);
		No3tf.align=TextFormatAlign.CENTER;
		
		tf2=new TextFormat(TextBoard.fontNames,12,0xffffff,true);
		tf2.align=TextFormatAlign.CENTER;
		
		NumText=new TextField();
		this.addChild(NumText);
		NumText.width=20;
		NumText.height=th;
		NumText.border=true;
		NumText.borderColor=0x000000;
		NumText.background=true;
		NumText.backgroundColor=0x262b2d;
		NumText.wordWrap=true;
		
		nameText=new TextField();
		this.addChild(nameText);
		nameText.width=80;
		nameText.height=th;
		nameText.x=20;
		nameText.border=true;
		nameText.borderColor=0x000000;
		nameText.background=true;
		nameText.backgroundColor=0x262b2d;
		
		
		nameText.wordWrap=true;
		
		ywText=new TextField();
		this.addChild(ywText);
		ywText.width=70;
		ywText.height=th;
		ywText.x=100;
		ywText.border=true;
		ywText.borderColor=0x000000;
		ywText.background=true;
		ywText.backgroundColor=0x262b2d;
		ywText.wordWrap=true;
		
		lyText=new TextField();
		this.addChild(lyText);
		lyText.width=205;
		lyText.height=th;
		lyText.x=170;
		lyText.border=true;
		lyText.borderColor=0x000000;
		lyText.background=true;
		lyText.backgroundColor=0x262b2d;
		lyText.defaultTextFormat=tf2;
		lyText.wordWrap=true;
		
		switch(thisNo)
		{
			case 0:
			{
				NumText.defaultTextFormat=No1tf;
				nameText.defaultTextFormat=No1tf;
				ywText.defaultTextFormat=No1tf;
				break;
			}
			case 1:
			{
				NumText.defaultTextFormat=No2tf;
				nameText.defaultTextFormat=No2tf;
				ywText.defaultTextFormat=No2tf;	
				break;
			}
			case 2:
			{
				NumText.defaultTextFormat=No3tf;
				nameText.defaultTextFormat=No3tf;
				ywText.defaultTextFormat=No3tf;	
				break;
			}
			default:
			{
				NumText.defaultTextFormat=tf2;
				nameText.defaultTextFormat=tf2;
				ywText.defaultTextFormat=tf2;
				break;
			}
		}
	}	
	
	public function setText(no:String,names:String,yw:String,ly:String,iswrap:Boolean=true):void{
//		if(!iswrap){
//			NumText.text=no;
//			nameText.text=names;
//			ywText.text=yw;
//			lyText.text=ly;
//			return;
//		}
		NumText.text="";
		nameText.text="";
		ywText.text="";
		lyText.text="";
		//
//		NumText.text="\n"+no;
		NumText.text=no;
		//
		nameText.text=names;
//		if(nameText.numLines==1){
//			nameText.text="\n"+names;	
//		}
		//
//		ywText.text="\n"+yw;
		if(iswrap){
			ywText.text=String(Number(yw)*100);
		}else{
			ywText.text=yw;
		}
		//
		if(ly){
			lyText.text=ly;
//			if(lyText.numLines==1){
//				lyText.text="\n"+ly;	
//			}	
		}
	}
}