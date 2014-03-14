package states.app
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import core.App;
	import interfaces.IState;
	import audio.Audio;
	
	public class Standby extends Sprite implements IState
	{
		private var app:App;
		private var xml_data:XML;
		private var txt_copy:TextField;
		private var bmp_bg:Bitmap;
		private var bmp_start:Bitmap;
		private var arr_logos:Array = new Array();
		private var bttn_start:Sprite = new Sprite();

		public function Standby(app:App):void
		{
			trace("standby initialized");
			this.app = app;
			this.xml_data = app.assets_xml.xmlData;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			//initialize any settings here
			
			loadCopy();
			loadLogos();
			loadBg();
			loadBttn();
		}

		private function loadCopy():void
		{
			var sText:String = xml_data.Standby.Copy;
			
			var txt_format:TextFormat = new TextFormat();
			txt_format.size = 12;
			txt_format.align = TextFormatAlign.LEFT;
			txt_format.color = 0xaaaaaa;
			txt_format.bold = false;
			txt_format.font = "Verdana";
			
			txt_copy = new TextField();
			txt_copy.defaultTextFormat = txt_format;
			txt_copy.text = sText;
			txt_copy.border = true;
			txt_copy.wordWrap = true;
			txt_copy.width = 200;
			txt_copy.height = 200;
			txt_copy.x = 20;
			txt_copy.y = 20;
			this.addChild(txt_copy);
			
			txt_format = null;
		}
		private function loadLogos():void
		{
			var logo_xml:XMLList = new XMLList(xml_data.Standby.Logos);
			var base_dir:String = "assets/images/";
			var numLogos:uint = logo_xml.Logo.length();

			for(var i:int = 0; i<numLogos; i++){
				var url:String = logo_xml.Logo[i].Url;
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, logoComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				var request:URLRequest = new URLRequest(base_dir+url);
				loader.load(request);
			}
		}
		private function logoComplete(event:Event):void
		{
			var loader:Loader = event.target.loader;
			loader.removeEventListener(Event.COMPLETE, logoComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			arr_logos.push(new Bitmap(BitmapData(event.target.content.bitmapData)));
			arr_logos[arr_logos.length - 1].x = 680;
			arr_logos[arr_logos.length - 1].y = ((arr_logos.length - 1) * 120) + 20;
			this.addChild(arr_logos[arr_logos.length - 1]);
			
			loader.unload();
			loader = null;
		}
		private function loadBg():void
		{
			var base_url:String = "assets/images/";
			var url:String = xml_data.Standby.Background.Url;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, bgComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			var request:URLRequest = new URLRequest(base_url + url);
			
			loader.load(request);
		}
		private function bgComplete(event:Event):void
		{
			var loader:Loader = event.target.loader;
			loader.removeEventListener(Event.COMPLETE, bgComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			bmp_bg = new Bitmap(BitmapData(event.target.content.bitmapData));
			this.addChild(bmp_bg);
			this.setChildIndex(bmp_bg, 0);
			
			loader.unload();
			loader = null;
		}
		private function loadBttn():void
		{
			var url:String = "assets/images/bttn_temp.png";
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, bttnComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			var request:URLRequest  = new URLRequest(url);
			
			loader.load(request);
		}
		private function bttnComplete(event:Event):void
		{
			var loader:Loader = event.target.loader;
			loader.removeEventListener(Event.COMPLETE, bttnComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			bmp_start = new Bitmap(BitmapData(event.target.content.bitmapData));
			bttn_start = new Sprite();
			bttn_start.buttonMode = true;
			bttn_start.addEventListener(MouseEvent.CLICK, startOnClick);
			bttn_start.addChild(bmp_start);
			bttn_start.x = 400;
			bttn_start.y = 300;
			this.addChild(bttn_start);
			
			loader.unload();
			loader = null;
		}
		private function startOnClick(event:MouseEvent):void
		{
			Audio.playBttn1Sound(1);
			app.changeState(App.FORM_STATE);
		}
		private function ioErrorHandler(err:IOErrorEvent):void
		{
			trace("Unable to load image: ");
		}
		public function destroy():void
		{
			this.removeChild(bmp_bg);
			bmp_bg = null;
			bttn_start.removeChild(bmp_start);
			bmp_start = null;
			this.removeChild(bttn_start);
			bttn_start = null;
			this.removeChild(txt_copy);
			txt_copy = null;
			xml_data = null;
			
			for each(var logo:Bitmap in arr_logos){
				this.removeChild(logo);
				logo = null;
			}
			this.parent.removeChild(this);
		}
	}//class
}//package