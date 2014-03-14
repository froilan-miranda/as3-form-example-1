package objects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class Background extends Sprite
	{
		private var bmp_bg:Bitmap;
		private var bg_url:String;
		private var base_dir:String;
		private var bg_name:String;
		private var _bg_id:uint;

		public function Background(bg_id:uint, bg_url:String)
		{
			this._bg_id = bg_id;
			this.bg_url = bg_url;
			this.bg_name = bg_name;
			this.base_dir = "assets/images/";
			loadBg();
		}
		private function loadBg():void
		{	
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, logoComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			var request:URLRequest = new URLRequest(base_dir + bg_url);
			loader.load(request);
		}
		private function logoComplete(event:Event):void
		{
			var loader:Loader = event.target.loader;
			loader.removeEventListener(Event.COMPLETE, logoComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			bmp_bg = new Bitmap(BitmapData(event.target.content.bitmapData));
			bmp_bg.x = 0;
			bmp_bg.y = 0;
			this.addChild(bmp_bg);
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
			this.removeChild(bmp_bg);
			bmp_bg = null;
			bg_url = null;
			bg_name = null;
			base_dir = null;
			this.parent.removeChild(this);
		}
		public function get bg_id():uint
		{
			return _bg_id;
		}
	}//class
}//package