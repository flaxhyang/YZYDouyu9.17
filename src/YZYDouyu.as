package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import database.DataBase;
	
	import mmBoard.MMBoard;
	
	import selectBoard.Notice;
	import selectBoard.SelectBoard;
	
	import textboard.TextBoard;
	
	import thboard.THBoard;
	
	
	import video.Stagevideo;
	
	import vo.InfoData;
	import vo.MTVInfo;
	import vo.SelectMTVPeople;
	import vo.TTHVo;
	
	
	[SWF(width="1470", height="827",backgroundColor="0x000000")]
	public class YZYDouyu extends Sprite
	{
		
		private var sv:Stagevideo;
		private var isContinuityPlay:Boolean=false;
		private var db:DataBase;
		
		private var infoData:InfoData;
		
		private var currSelectMTVInfo:SelectMTVPeople;
		
		private var sBoard:SelectBoard;
		private var textBoard:TextBoard;
		
		private var currPlaySP:SelectMTVPeople=new SelectMTVPeople();
		private var playMVid:int;
		
		private var times:Timer;
		private const showTopYWTimeNum:int=600;//600秒土豪榜
		private const showListTimeNum:int=300;//300秒mvlist
		private const topListTimeNum:int=10;//10秒点歌榜
		private const stopMVInterval:int=10;//切歌 间隔
		private var currTopYWTime:int=595;
		private var currShowListTime:int=0;
		private var currTopListTime:int=0;
		private var stopMVTimer:int=0;
		//
		private var isBeginStopMvTimer:Boolean=false;
		
		private var linkTestTF:TextField;
			
		private var thboardsp:THBoard;
		private var mmb:MMBoard;
		
		//系统播放的当前num
		private var randomMVCurrNum:int=0;
		
		
		private var backmsg:String;
		
		private var socket:Link=Link.instant;
		
		
		private var checkTimer:Timer;
		
		public function YZYDouyu()
		{
			//---------------------------------------------2015.08.24 
			infoData=InfoData.instant;
			infoData.getAUTOMvlist();
			initData();
		}
		
		private function initData():void
		{
			db=	DataBase.instant;
			db.addEventListener(DataBase.LINK_DATABASE_COMPLETE,databaseComplete);
			db.openDatabase();
		}
		
		protected function databaseComplete(event:Event):void
		{
			initBoard();//初始化界面
			initVideo();//初始化video
			//测试是否断线
			checkLink();//
			initLinkDOUYU();//连接斗鱼设置 
			initTextLayer();//点歌名称 祝福语设置
			initTHBoard();//土豪榜 设置
			initTimer();//计时 刷新列表设置
			initAuthority();//权限设置
			initNotice();//
			initmmBoard();
			///////////////////////////////////////
			setAutoThank();//自动答谢
			setAutoMsg();//自动弹幕
			checkTimer.start();//
			//
			videoTest();
			
			//
			//
//			test();
		}
		
		private function checkLink():void
		{
			checkTimer=new Timer(180000);
			checkTimer.addEventListener(TimerEvent.TIMER_COMPLETE,checkLinkHandle);
		}
		
		protected function checkLinkHandle(event:TimerEvent):void
		{
			checkTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,checkLinkHandle);
			initLinkDOUYU();
			checkLink();
		}
		
		private function initmmBoard():void
		{
			mmb=MMBoard.instant;
			this.addChild(mmb);
			mmb.y=this.stage.stageHeight-200;
			mmb.x=this.stage.stageWidth-462;
		}
		
		private function initNotice():void
		{
			var notice:Notice=Notice.instant;
			notice.init();
			this.addChild(notice);
			notice.x=this.stage.stageWidth-notice.width-6;
			notice.y=36
		}
		
		private function initAuthority():void
		{
			var textload:URLLoader=new URLLoader();
			var txtURLRequest:URLRequest=new URLRequest(InfoData.AuthorityURL);
			textload.addEventListener(Event.COMPLETE,authorityHandle);
			textload.load(txtURLRequest);	
		}
		
		protected function authorityHandle(evt:Event):void
		{
			var autArr:Array=String(evt.target.data).split(",");
			for (var i:int = 0; i < autArr.length; i++) 
			{
				infoData.GMIDVec.push(int(autArr[i]));
			}
		}
		
		private function initTHBoard():void
		{
			//test
//			var t1:SelectMTVPeople=new SelectMTVPeople();
//			t1.currYw=100;
//			t1.message="祝福大鸡鸡长命百岁！";
//			t1.name="flaxhyang";
//			var t2:MTVInfo=new MTVInfo();
//			t2.name="Wiggle Wiggle Hello Venus";
//			t2.No=324;
//			titleWord(null,t1,t2);
			
//			textBoard.setText(t1,t2);
			
			thboardsp=THBoard.instant;
			thboardsp.init();
			this.addChild(thboardsp);
			thboardsp.x=this.stage.stageWidth-InfoData.TopListWidth-thboardsp.width+8;
			thboardsp.y=1;
		}
		
		protected function isLinkHandle(event:Event):void
		{
			socket.removeEventListener(Link.LINK_OK,isLinkHandle);
			linkTestTF.visible=false;
			//socket.sendMsg(String(Tools.getRandom(3001,3348)));
		}
		
		private function initTextLayer():void
		{
			textBoard=TextBoard.instant;
			this.addChild(textBoard);
		}
		
		private function initTimer():void
		{
			times=new Timer(1000);			
			times.addEventListener(TimerEvent.TIMER,timerHandle);
			times.start();
		}
		
		protected function timerHandle(event:TimerEvent):void
		{
			currTopYWTime++;
//			currShowListTime++;	
			currTopListTime++;
			if(currTopYWTime>showTopYWTimeNum){
				currTopYWTime=0;
				thboardsp.getData();
			}
//			if(currShowListTime>showListTimeNum){
//				currShowListTime=0;
//				sBoard.get1info();
//			}
			if(currTopListTime>topListTimeNum){
				currTopListTime=0;
				sBoard.changeTopList();
			}
			
			if(isBeginStopMvTimer){
				stopMVTimer++;
				if(stopMVTimer>stopMVInterval){
					stopMVTimer=0;
					isBeginStopMvTimer=false;
				}
			}
		
		}
		
		private function initBoard():void
		{
			sBoard=	SelectBoard.instant;
			this.addChild(sBoard);
			sBoard.x=this.stage.stageWidth-sBoard.width;
			//每天开始刷新一次
			sBoard.get1info();
		}
		
		
		private function initVideo():void
		{
			sv=	Stagevideo.instant;
//			sv.STREAM_URL="http://he.yinyuetai.com/uploads/videos/common/8B8B014B53A49BC9D27E1C9B84ED7785.flv";
			sv.STREAM_URL="/videos/begin.mp4";
//			sv.STREAM_URL="/videos/t2.mp4";
			sv.addEventListener(Stagevideo.STOP_VIDEO_EVENT,stopVideoHanlde);
			this.addChild(sv);
		}
		
		protected function stopVideoHanlde(event:Event=null):void
		{
			if(isContinuityPlay){
				playMVid=currPlaySP.MTVisVec.shift();
				infoData.addEventListener(InfoData.PLAY_MV_COMPLETE,playMtvHandle);
				db.getMVInfo(playMVid);
				//
				textBoard.setText(currPlaySP,infoData.currGetMTV);
				mmb.titleWord(null,currPlaySP,infoData.currGetMTV);
				
				if(currPlaySP.MTVisVec.length<=0){
					isContinuityPlay=false;
				}
			}else{
				infoData.addEventListener(InfoData.TOP_SELECTMTV_COMPLETE,topdataHandle);
				db.getTopMTVSForPlay();
			}
		}		
		
		protected function topdataHandle(event:Event):void
		{
			infoData.removeEventListener(InfoData.TOP_SELECTMTV_COMPLETE,topdataHandle);
			if(infoData.TopSelectPeoples.length>0){
				currPlaySP=infoData.TopSelectPeoples[0];
				
				if(currPlaySP.MTVisVec.length>1){
					isContinuityPlay=true;
				}else{
					isContinuityPlay=false;
				}
				playMVid=currPlaySP.MTVisVec.shift();
				infoData.addEventListener(InfoData.PLAY_MV_COMPLETE,playMtvHandle);
				db.getMVInfo(playMVid);
				//
				
			}else{
				//随机播放一首
//				infoData.addEventListener(InfoData.SELECT_TOP_MV,function selectComplete(evt:Event):void{
//					infoData.removeEventListener(InfoData.SELECT_TOP_MV,selectComplete);
//					var scMtv:MTVInfo=infoData.selectTopMvVector[Tools.getRandom(0,infoData.selectTopMvVector.length-1)];
//					sv.PlayMTV(InfoData.MTVURL+scMtv.url);
//					textBoard.setText();
//				})
				
//				if(infoData.selectTopMvVector.length>0){
//					var scMtv:MTVInfo=infoData.selectTopMvVector[randomMVCurrNum];
//					sv.PlayMTV(InfoData.MTVURL+scMtv.url);
//					textBoard.setText(null,scMtv);
//					mmb.titleWord(null,null,scMtv);
//					
//					randomMVCurrNum++;
//					if(randomMVCurrNum>=infoData.selectTopMvVector.length){
//						randomMVCurrNum=0;
//					}
//				}else{
//					infoData.addEventListener(InfoData.SELECT_TOP_MV,function selectComplete(evt:Event):void{
//						infoData.removeEventListener(InfoData.SELECT_TOP_MV,selectComplete);
//						var scMtv:MTVInfo=infoData.selectTopMvVector[randomMVCurrNum];
//						sv.PlayMTV(InfoData.MTVURL+scMtv.url);
//						textBoard.setText(null,scMtv);
//						mmb.titleWord(null,null,scMtv);
//						randomMVCurrNum++;
//					})
//					db.getTopSelectMV();
//				}
				
				infoData.addEventListener(InfoData.SELECT_TOP_MV,autoPlayMvInfoComplete);
				db.getAutoSelectMV();
			}
		}
		
		protected function autoPlayMvInfoComplete(event:Event):void
		{
			var scMtv:MTVInfo=infoData.AutoPlayMvInfo;
			sv.PlayMTV(InfoData.MTVURL+scMtv.url);
			textBoard.setText(null,scMtv);
			mmb.titleWord(null,null,scMtv);
		}
		
		protected function playMtvHandle(event:Event):void
		{
			try
			{
				sv.PlayMTV(InfoData.MTVURL+infoData.currGetMTV.url);
				textBoard.setText(currPlaySP,infoData.currGetMTV);
				mmb.titleWord(null,currPlaySP,infoData.currGetMTV);
				db.updataMvInfo(playMVid);
				//
				if(currPlaySP.currYw){
					//------------------------------------------- temp : 房管组里的id 点歌不扣 鱼丸
					if(infoData.isGM(currPlaySP.id)){
						db.addEventListener(DataBase.UPDATA_CURRYW_COMPLETE,currYWHandle);
						db.updataSelectPeopleCurrYWTemp(currPlaySP.id);
					}else{
						db.addEventListener(DataBase.UPDATA_CURRYW_COMPLETE,currYWHandle);
						db.updataSelectPeopleCurrYW(currPlaySP.id);
					}
				}else{
					if(!isContinuityPlay){
						infoData.delSelectPeople();
					}
					sBoard.changeTopList();
				}
			} 
			catch(error:Error) 
			{
				stopVideoHanlde();
			}
		
		}		
		
		protected function currYWHandle(event:Event):void
		{
			db.removeEventListener(DataBase.UPDATA_CURRYW_COMPLETE,currYWHandle);
			sBoard.changeTopList();
		}		
        //---------------------------------------------------------------------------------------
		//自动弹幕
		private function setAutoMsg():void{
			var wordsVec:Array;
			var sendMsgTimer:Timer;
			var currwordNum:int=0;
			var textload:URLLoader=new URLLoader();
			var txtURLRequest:URLRequest=new URLRequest(InfoData.AUTOMSGURL);
			textload.addEventListener(Event.COMPLETE,function wordHandle(evt:Event):void{
				wordsVec=String(textload.data).split("\r\n");
				sendMsgTimer=new Timer(60000);
				sendMsgTimer.addEventListener(TimerEvent.TIMER,function sendmsgHandle(event:TimerEvent):void
				{
					if(currwordNum>=wordsVec.length){
						currwordNum=0;
					}
					backMsg(wordsVec[currwordNum]);
					currwordNum++;			
				});
				sendMsgTimer.start();
				
			});
			textload.load(txtURLRequest);
		}
		//---------------------------------------------------------------------------------
		//自动答谢鱼丸的
		private var TankTimer:Timer;
		private var THTempVec:Vector.<TTHVo>=new Vector.<TTHVo>();
		private var currTankNum:uint=0;
		private function setAutoThank():void
		{
			TankTimer=new Timer(3000);
			TankTimer.addEventListener(TimerEvent.TIMER,function tankTimerHandle(event:TimerEvent):void{
				if(THTempVec.length<=0){
					TankTimer.stop();
					return;
				}
				var currth:TTHVo=THTempVec.shift();
				var msg:String;
				if(currTankNum>1){
					currTankNum=0;
				}
				if(currth.yuNum>10){
					if(currTankNum){
						msg="哭天！喊地！感谢！"+currth.thName+" 大土豪的"+int(currth.yuNum*100)+"鱼丸！[emot:grief]";
					}else{
						msg="哭天！喊地！感谢！"+currth.thName+" 大土豪的"+int(currth.yuNum*100)+"鱼丸[emot:grief][emot:grief]";
					}
				}else if(currth.yuNum>5){
					if(currTankNum){
						msg="热泪感谢！"+currth.thName+" 大土豪的"+int(currth.yuNum*100)+"鱼丸！[emot:kx]";
					}else{
						msg="热泪感谢！"+currth.thName+" 大土豪的"+int(currth.yuNum*100)+"鱼丸[emot:kx][emot:kx]";
					}
				}else{
					if(currTankNum){
						msg="感谢！ "+currth.thName+" 土豪的 "+int(currth.yuNum*100)+"鱼丸！[emot:excited]";
					}else{
						msg="感谢！ "+currth.thName+" 土豪的 "+int(currth.yuNum*100)+"鱼丸[emot:excited][emot:excited]";
					}
				}
				
				backMsg(msg);
				currTankNum++;		
			});
		}	
		private function giftTank(playerid:int,nick:String,ywMum:Number):void{
			if(!THTempVec.length){
				pushNewth(playerid,nick,ywMum);
			}else{
				var isnew:Boolean=true;
				for (var i:int = 0; i < THTempVec.length; i++) 
				{
					if(playerid==THTempVec[i].id){
						THTempVec[i].yuNum+=ywMum;
						isnew=false;
						break;
					}
				}
				if(isnew){
					pushNewth(playerid,nick,ywMum);	
				}
			}
			
			if(TankTimer.running){
				TankTimer.reset();
			}
			
			TankTimer.start();
			
		}
		private function pushNewth(id:int,nick:String,ywNum:Number):void{
			var thvo:TTHVo=new TTHVo();
			thvo.id=id;
			thvo.thName=nick;
			thvo.yuNum+=ywNum;
			THTempVec.push(thvo);
		}
		//---------------------------------------------------------------------------------link
		private function initLinkDOUYU():void
		{
			
			linkTestTF=new TextField();
			this.addChild(linkTestTF);
			linkTestTF.defaultTextFormat=new TextFormat("",24,0xff0000);
			linkTestTF.text="没有连接弹幕！！！！！！！";
			socket.addEventListener(Link.LINK_OK,isLinkHandle)
//			infoData.addEventListener(InfoData.DM_IS_LINK,isLinkHandle);
			

			//test 17732
			//xi 67604
			//29 55126
			//二科 78622
			//卡卡 60843
			//longlong 194257
			//yifan 163843
			//me 193466

			
			socket.initService(193466,msg_decode,gift_fish);
			
		
		}
		
		private var backflag:int=0;
		private function msg_decode(id:String,name:String,msg:String):void{
			trace("name="+name,"msg="+msg,"id="+id);
			if(name=="猫小胖杂货铺"){
				checkTimer.reset();
				checkTimer.start();
				return
			};
			
			var tempnum:int=int(msg);
			if(tempnum){
				if(tempnum>200){
					var ones:String = msg.charAt(0)
					if(ones!="2" && ones!="3" && ones!="4" && ones!="5" && ones!="6"){
						if(backflag>0){
							backflag=0;
							backmsg="编号错误！请查看直播详情里的地址连接哦";
						}else{
							backmsg="你输入的编号不是歌曲编号，请查看直播详情里的地址连接哦";
							backflag++;
						}
						backMsg(backmsg);
					}else{
						selectMV(tempnum,name,id);
						return;
					}
				}else{
					if(backflag>0){
						backflag=0;
						backmsg="编号错误！请查看直播详情里的地址连接哦";
					}else{
						backmsg="你输入的编号不是歌曲编号，请查看直播详情里的地址连接哦";
						backflag++;
					}
					backMsg(backmsg);
				}
				
				
			}
			
			var tempArr:Array=msg.split("*",msg.length);
			if(!tempArr)return;
			if(tempArr.length<2)return;
			if(tempArr.length>3)return;
			if(tempArr[0]!=""&&tempArr[0]!="点歌" && tempArr[0]!="连播" && tempArr[0]!="留言" && tempArr[0]!="切歌")return;
			//
			if(tempArr[0]=="点歌" ||tempArr[0]==""){
				//-------------------------------------temp authority
				var mvid:int=int(tempArr[1]);
				if(!mvid)return;
				if(mvid<300){
					if(!infoData.isGM(int(id))){
						backmsg="不是房间的超管，不能点播隐藏歌曲哦！[emot:grief]";
						backMsg(backmsg);
						return;
					}					
				}
				//
				currSelectMTVInfo=new SelectMTVPeople();
				currSelectMTVInfo.id=int(id);
				currSelectMTVInfo.MTVids=String(mvid);
				currSelectMTVInfo.name=name;
				if(tempArr.length==3){
					currSelectMTVInfo.message=tempArr[2]
				}
				infoData.setSelectQueueArr(currSelectMTVInfo);
				
			}else if(tempArr[0]=="连播"){
				currSelectMTVInfo=new SelectMTVPeople();
				currSelectMTVInfo.id=int(id);
				currSelectMTVInfo.name=name;
				currSelectMTVInfo.MTVids=tempArr[1];
				if(tempArr.length==3){
					currSelectMTVInfo.message=tempArr[2]
				}
				infoData.continuity(currSelectMTVInfo);
			}else if(tempArr[0]=="留言"){
				currSelectMTVInfo=new SelectMTVPeople();
				currSelectMTVInfo.id=int(id);
				currSelectMTVInfo.leaveWord=tempArr[1];
				infoData.leaveWord(currSelectMTVInfo);
			}else if(tempArr[0]=="切歌"){
				if(isBeginStopMvTimer)return;
				//---------------------------------------temp authority
				if(infoData.isGM(int(id))){				
					isBeginStopMvTimer=true;
					sv.stopMTV();
				}
			}
		}
		
		//直接输入数字点歌
		private function selectMV(mvid:int,nick:String,playerid:String):void{
			if(!mvid)return;
			if(mvid<300){
				if(!infoData.isGM(int(playerid))){
					backmsg="不是房间的超管，不能点播隐藏歌曲哦！[emot:grief]";
					backMsg(backmsg);
					return;
				}					
			}
			//
			currSelectMTVInfo=new SelectMTVPeople();
			currSelectMTVInfo.id=int(playerid);
			currSelectMTVInfo.MTVids=String(mvid);
			currSelectMTVInfo.name=nick;
			
			infoData.setSelectQueueArr(currSelectMTVInfo);
		}
		
		private function gift_fish(id:String,nick:String,num:int):void{
			//trace("鱼丸：=id"+id+"; nick="+nick);
			var ywNum:Number=num/100;
			currSelectMTVInfo=new SelectMTVPeople();
			currSelectMTVInfo.id=int(id);
			currSelectMTVInfo.name=nick;
			currSelectMTVInfo.currYw=ywNum;
			
			infoData.addGiftQueue(currSelectMTVInfo);
			
			giftTank(int(id),nick,ywNum);
			
		}
		
		private function backMsg(s:String):void
		{
			socket.sendMsg(s);
			//TextBoard.instant.setZhufu(s);
		}
		
		//-------------------------------------------------------------------------------utils
		private function getchatNum(s:String,beginChar:String,endChar:String):String{
			var chars:String=null;
			var begincharNum:int=s.indexOf(beginChar);
			if(begincharNum==-1)return null;
			var beginNum:int=begincharNum+beginChar.length;
			if(beginNum>=s.length)return null;
			var endNum:int=-1;
			var slength:int=s.length;
			for (var i:int = beginNum; i <slength ; i++) 
			{
				if(s.charAt(i)==endChar){
					endNum=i;
					break;
				}
			}
			if(endNum<=beginNum)return null;
			
			return chars=s.slice(beginNum,endNum);
		}
		
		
		
		
		//video test
		private var vurl:int=700;
		private function videoTest():void{
			var but:Sprite=new Sprite();
			but.graphics.beginFill(0xff0000,0);
			but.graphics.drawRect(0,0,100,50);
			but.graphics.endFill();
			but.addEventListener(MouseEvent.CLICK,clickHandle);
			this.addChild(but);
			but.buttonMode=true;
		}
		
		protected function clickHandle(event:MouseEvent):void
		{
			sv.stopMTV();
//			vurl++;
//			trace(vurl);
//			sv.PlayMTV(InfoData.MTVURL+vurl+".flv");
		}
		//test
		private var step:int=0;
		
		private function test():void{
			
//			var but1:Sprite=new Sprite();
//			but1.graphics.beginFill(0xff0000);
//			but1.graphics.drawCircle(0,0,100);
//			but1.graphics.endFill();
//			this.addChild(but1);
//			but1.addEventListener(MouseEvent.CLICK,testclickhandl);
			
			
			step++;
			switch(step)
			{
				case 5:
				{
					
//					mmb.titleWord("男巫！");
//					var t1:SelectMTVPeople=new SelectMTVPeople();
//					t1.currYw=10;
//					t1.message="祝福大鸡鸡长命百岁！";
//					t1.name="flaxhyang";
//					var t2:MTVInfo=new MTVInfo();
//					t2.name="Wiggle Wiggle Hello Venus";
//					t2.No=324;
//					titleWord(null,t1,t2);
					
					
//					msg_decode("连点*1&2&3&306这样","flaxhyang","212467");
//					msg_decode("连播*301&302&303&304&305&306","8888","8888");
//					currSelectMTVInfo=new SelectMTVPeople();
//					currSelectMTVInfo.id=1087863;
//					currSelectMTVInfo.name="咸豚";
//					currSelectMTVInfo.MTVids="501";
//					currSelectMTVInfo.message="421祝兮兮么么哒";
//					infoData.setSelectQueueArr(currSelectMTVInfo);
//					
//					
//					var currSelectMTVInfo2:SelectMTVPeople=new SelectMTVPeople();
//					currSelectMTVInfo2.id=421;
//					currSelectMTVInfo2.name="zjy0015";
//					currSelectMTVInfo2.MTVids="324";
//					currSelectMTVInfo2.message="421祝兮兮么么哒";
//					infoData.setSelectQueueArr(currSelectMTVInfo2);
					//
					currSelectMTVInfo=new SelectMTVPeople();
					currSelectMTVInfo.id=421;
					currSelectMTVInfo.name="zjy0015";
					infoData.addGiftQueue(currSelectMTVInfo);
					//
					
					break;
				}
				case 6:
				{
					
//					currSelectMTVInfo=new SelectMTVPeople();
//					currSelectMTVInfo.id=421;
//					currSelectMTVInfo.name="大大大大大大大大大啊";
//					infoData.addGiftQueue(currSelectMTVInfo);
				
//					currSelectMTVInfo=new SelectMTVPeople();
//					currSelectMTVInfo.id=422;
//					currSelectMTVInfo.name="大大大大大大大大大啊";
//					currSelectMTVInfo.MTVids="501";
//					currSelectMTVInfo.message="421祝兮兮么么哒";
//					infoData.setSelectQueueArr(currSelectMTVInfo);
					
//					currSelectMTVInfo=new SelectMTVPeople();
//					currSelectMTVInfo.id=321;
//					currSelectMTVInfo.name="321";
//					infoData.addGiftQueue(currSelectMTVInfo);
					break;
				}
				case 7:
				{
//					currSelectMTVInfo=new SelectMTVPeople();
//					currSelectMTVInfo.id=321;
//					currSelectMTVInfo.name="321";
//					currSelectMTVInfo.MTVids="501";
//					currSelectMTVInfo.message="321祝兮兮么么哒";
//					infoData.setSelectQueueArr(currSelectMTVInfo);
					break;
				}
				case 8:
				{
//					currSelectMTVInfo=new SelectMTVPeople();
//					currSelectMTVInfo.id=421;
//					currSelectMTVInfo.name="大大大大大大大大大啊";
//					infoData.addGiftQueue(currSelectMTVInfo);
					
//					currSelectMTVInfo=new SelectMTVPeople();
//					currSelectMTVInfo.id=322;
//					currSelectMTVInfo.name="321";
//					currSelectMTVInfo.MTVids="301";
//					currSelectMTVInfo.message="321祝兮兮么么哒";
//					infoData.setSelectQueueArr(currSelectMTVInfo);
					
//					msg_decode("连播*301&302&303&304&305&306*这是测试","521","521");
					break;
				}
				case 9:
				{
//					currSelectMTVInfo=new SelectMTVPeople();
//					currSelectMTVInfo.id=323;
//					currSelectMTVInfo.name="321";
//					currSelectMTVInfo.MTVids="501";
//					currSelectMTVInfo.message="321祝兮兮么么哒";
//					infoData.setSelectQueueArr(currSelectMTVInfo);
					break;
				}
				case 10:
				{
//					currSelectMTVInfo=new SelectMTVPeople();
//					currSelectMTVInfo.id=324;
//					currSelectMTVInfo.name="321";
//					currSelectMTVInfo.MTVids="501";
//					currSelectMTVInfo.message="321祝兮兮么么哒";
//					infoData.setSelectQueueArr(currSelectMTVInfo);
					break;
				}
				case 11:
				{
//					currSelectMTVInfo=new SelectMTVPeople();
//					currSelectMTVInfo.id=325;
//					currSelectMTVInfo.name="321";
//					currSelectMTVInfo.MTVids="501";
//					currSelectMTVInfo.message="321祝兮兮么么哒";
//					infoData.setSelectQueueArr(currSelectMTVInfo);
					break;
				}	
				case 30:
				{
//					currSelectMTVInfo=new SelectMTVPeople();
//					currSelectMTVInfo.id=326;
//					currSelectMTVInfo.name="326";
//					currSelectMTVInfo.MTVids="501";
//					currSelectMTVInfo.message="321祝兮兮么么哒";
//					infoData.setSelectQueueArr(currSelectMTVInfo);
					break;
				}		
				case 1000:
				{
					step=0;
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		protected function testclickhandl(event:MouseEvent):void
		{
			var ywNum:Number=Number("9999")/100;
			currSelectMTVInfo=new SelectMTVPeople();
			currSelectMTVInfo.id=212467;
			currSelectMTVInfo.name="flaxhyang";
			currSelectMTVInfo.currYw=ywNum;
			infoData.addGiftQueue(currSelectMTVInfo);
			
		}
		
	}
}