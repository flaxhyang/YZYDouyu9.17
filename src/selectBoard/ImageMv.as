package selectBoard
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class ImageMv extends Sprite
	{
		private var loader:Loader;
		
	
		
		private var nametx:TextField;
		private var numtx:TextField;
		
		
		private const thisw:int=147;
		
		public function ImageMv()
		{
			super();
			this.cacheAsBitmap=true;
			//
			nametx=new TextField();
//			nametx.border=true;
//			nametx.borderColor=0xffffff;
			nametx.width=thisw-2;
			nametx.height=38;
			nametx.wordWrap=true;
//			nametx.x=1;
			nametx.y=107;
			nametx.wordWrap=true;
			var ntf:TextFormat=new TextFormat();
			ntf.align=TextFormatAlign.CENTER;
			ntf.bold=true;
			ntf.color=0xfffff9;
			ntf.size=14;
			this.addChild(nametx);
			nametx.defaultTextFormat=ntf;
			//
			numtx=new TextField();
			numtx.background=true;
			numtx.backgroundColor=0xffff00;
//			numtx.border=true;
//			numtx.borderColor=0xffffff;
			numtx.width=50;
			numtx.height=25;
			numtx.x=thisw-numtx.width;
			numtx.y=80;
			var otf:TextFormat=new TextFormat();
			otf.color=0xff0000;
			otf.size=18;
			otf.bold=true;
			otf.align=TextFormatAlign.CENTER;
			this.addChild(numtx);
			numtx.defaultTextFormat=otf;
			//
			loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completehandle);
			
		}
		protected function completehandle(event:Event):void
		{
			this.addChildAt(loader,0);
			loader.width=thisw;
			loader.height=103;
		}
		
		public function setImaageMV(num:int,names:String,url:String):void{
			nametx.text=names;
			numtx.text=""+num;
			loader.load(new URLRequest(url));
		}
	}
}