package objects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Logo extends Sprite
	{
		private var bmp_logo:Bitmap;
		private var logo_url:String;
		private var base_dir:String;
		private var logo_name:String;
		private var txt_name:TextField;
		private var _logo_id:uint;
		
		public function Logo(logo_id:uint, logo_url:String, logo_name:String):void
		{
			this._logo_id = logo_id;
			this.logo_url = logo_url;
			this.logo_name = logo_name;
			this.base_dir = "assets/images/";
			loadBg();
			loadName();
		}
		private function loadName():void
		{
			var txt_format:TextFormat = new TextFormat();
			txt_format.size = 12;
			txt_format.align = TextFormatAlign.LEFT;
			txt_format.color = 0xaaaaaa;
			txt_format.bold = false;
			txt_format.font = "Verdana";
			
			txt_name = new TextField();
			txt_name.defaultTextFormat = txt_format;
			txt_name.text = logo_name;
			txt_name.border = true;
			txt_name.wordWrap = true;
			txt_name.width = 200;
			txt_name.height = 200;
			txt_name.x = 125;
			txt_name.y = 0;
			this.addChild(txt_name);
			
			txt_format = null;

		}
		private function loadBg():void
		{	
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, logoComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			var request:URLRequest = new URLRequest(base_dir + logo_url);
			
			loader.load(request);
		}
		private function logoComplete(event:Event):void
		{
			var loader:Loader = event.target.loader;
			loader.removeEventListener(Event.COMPLETE, logoComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			bmp_logo = new Bitmap(BitmapData(event.target.content.bitmapData));
			bmp_logo.x = 0;
			bmp_logo.y = 0;
			this.addChild(bmp_logo);
			//this.setChildIndex(bmp_logo, 0);
			
			loader.unload();
			loader = null;
		}
		private function ioErrorHandler(err:IOErrorEvent):void
		{
			trace("Unable to load image: ");
		}
		public function destroy():void
		{
			this.removeChild(bmp_logo);
			bmp_logo = null;
			this.removeChild(txt_name);
			txt_name = null;
			logo_url = null;
			logo_name = null;
			base_dir = null;
			
			this.parent.removeChild(this);
		}
		
		public function get logo_id():uint
		{
			return _logo_id;
		}
	}//class
}//package