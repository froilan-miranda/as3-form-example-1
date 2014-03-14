package states.form
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
	
	import interfaces.IFormState;
	import states.app.Form;
	import audio.Audio;
	
	public class Intro extends Sprite implements IFormState
	{
		private var form:Form;
		private var xml_data:XML;
		private var txt_copy:TextField;
		private var bmp_bg:Bitmap;
		private var bmp_continue:Bitmap;
		private var bttn_continue:Sprite;
		
		public function Intro(form:Form, xmlData:XML)
		{
			this.form = form;
			this.xml_data = xmlData;
			loadCopy();
			loadBg();
			loadBttn();
		}
		private function loadCopy():void
		{
			var sText:String = xml_data.PalmOil.Copy;
			
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
		private function loadBg():void
		{
			var base_url:String = "assets/images/";
			var url:String = xml_data.PalmOil.Background.Url;
			
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
			
			bmp_continue = new Bitmap(BitmapData(event.target.content.bitmapData));
			bttn_continue = new Sprite();
			bttn_continue.buttonMode = true;
			bttn_continue.addEventListener(MouseEvent.CLICK, continueOnClick);
			bttn_continue.addChild(bmp_continue);
			bttn_continue.x = 400;
			bttn_continue.y = 300;
			this.addChild(bttn_continue);
			
			loader.unload();
			loader = null;
		}
		private function continueOnClick(event:MouseEvent):void
		{
			bttn_continue.removeEventListener(MouseEvent.CLICK, continueOnClick);
			Audio.playBttn1Sound(1);
			form.changeState(Form.COMPANY_STATE);
		}
		
		private function ioErrorHandler(err:IOErrorEvent):void
		{
			trace("Unable to load image: ");
		}
		public function destroy():void
		{
			this.removeChild(txt_copy);
			txt_copy = null;
			
			this.removeChild(bmp_bg);
			bmp_bg = null;
			
			bttn_continue.removeChild(bmp_continue);
			bmp_continue = null;
			
			this.removeChild(bttn_continue);
			bttn_continue = null;
			
			this.parent.removeChild(this);
		}
	}//class
}//package