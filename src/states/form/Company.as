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
	import objects.Logo;
	import states.app.Form;
	import user.UserData;
	import audio.Audio;

	
	public class Company extends Sprite implements IFormState
	{
		private var form:Form;
		private var xml_data:XML;
		private var txt_copy:TextField;
		private var arr_logos:Array;
		private var bmp_continue:Bitmap;
		private var bttn_continue:Sprite;
		private var user_selected:Boolean = false;
		
		public function Company(form:Form, xmlData:XML)
		{
			this.form = form;
			this.xml_data = xmlData;
			loadCopy();
			loadOptions();
			loadBttn();
		}
		
		private function loadCopy():void
		{
			var txt_format:TextFormat = new TextFormat();
			txt_format.size = 12;
			txt_format.align = TextFormatAlign.LEFT;
			txt_format.color = 0xaaaaaa;
			txt_format.bold = false;
			txt_format.font = "Verdana";
			
			txt_copy = new TextField();
			txt_copy.defaultTextFormat = txt_format;
			txt_copy.text = "Please choose a company that you would like to send a message to that encourages them to be transparent about their palm oil policies and progress.";
			txt_copy.border = true;
			txt_copy.wordWrap = true;
			txt_copy.width = 200;
			txt_copy.height = 200;
			txt_copy.x = 20;
			txt_copy.y = 20;
			this.addChild(txt_copy);
			
			txt_format = null;
		}
		
		private function loadOptions():void
		{
			var logo_xml:XMLList = new XMLList(xml_data.Logos);
			var numLogos:uint = logo_xml.Logo.length();
			arr_logos = new Array();
			
			for(var i:int = 0; i<numLogos; i++){
				var id:uint = uint(logo_xml.Logo[i].Id);
				var url:String = logo_xml.Logo[i].Url;
				var name:String = logo_xml.Logo[i].Name;
				arr_logos[i] = new Logo(id, url, name);
				arr_logos[i].x = 480;
				arr_logos[i].y = (i * 120) + 20;
				arr_logos[i].addEventListener(MouseEvent.MOUSE_UP, onLogoUp);
				this.addChild(arr_logos[i]);
			}
		}
		
		private function onLogoUp(event:MouseEvent):void
		{
			var userLogo:Logo = Logo(event.currentTarget);
			UserData.company = userLogo.logo_id;
			user_selected = true;
			userLogo.removeEventListener(MouseEvent.MOUSE_UP, onLogoUp);
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
			if(user_selected){
				bttn_continue.removeEventListener(MouseEvent.CLICK, continueOnClick);
				Audio.playBttn1Sound(1);
				form.changeState(Form.MESSAGE_STATE);
			}
		}
		private function ioErrorHandler(err:IOErrorEvent):void
		{
			trace("Unable to load image: ");
		}
		public function destroy():void
		{
			this.removeChild(txt_copy);
			txt_copy = null;
			bttn_continue.removeChild(bmp_continue);
			bmp_continue = null;
			this.removeChild(bttn_continue);
			bttn_continue = null;
			
			for each(var logo:Logo in arr_logos){
				logo.destroy();
				logo = null;
			}
			
			this.parent.removeChild(this);
		}
	}//class
}//package