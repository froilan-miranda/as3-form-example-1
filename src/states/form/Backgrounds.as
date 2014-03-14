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
	
	import audio.Audio;	
	import interfaces.IFormState;
	import objects.Background;
	import objects.Logo;
	import states.app.Form;
	import user.UserData;
	
	public class Backgrounds extends Sprite implements IFormState
	{
		private var form:Form;
		private var xml_data:XML;
		private var txt_copy:TextField;
		private var arr_backgrounds:Array;
		private var bmp_continue:Bitmap;
		private var bttn_continue:Sprite;
		private var user_selected:Boolean = false;
		private var selected_logo:Logo;
		
		public function Backgrounds(form:Form, xmlData:XML)
		{
			trace("backgrounds initiated");
			this.form = form;
			this.xml_data = xmlData;
			loadCopy();
			loadOptions();
			loadBttn();
			loadSelectedLogo();
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
			txt_copy.text = "Please choose your background.";
			txt_copy.border = true;
			txt_copy.wordWrap = true;
			txt_copy.width = 200;
			txt_copy.height = 200;
			txt_copy.x = 20;
			txt_copy.y = 20;
			this.addChild(txt_copy);
			
			txt_format = null;
		}
		private function loadSelectedLogo():void
		{
			var logo_xml:XMLList = new XMLList(xml_data.Logos.Logo.(Id == UserData.company));
			
			var id:uint = uint(logo_xml.Id);
			var url:String = logo_xml.Url;
			var name:String = logo_xml.Name;
			selected_logo = new Logo(id, url, name);
			selected_logo.x = 680;
			selected_logo.y = 0;
			this.addChild(selected_logo);
		}
		private function loadOptions():void
		{
			var background_xml:XMLList = new XMLList(xml_data.Backgrounds);
			var numBgs:uint = background_xml.Background.length();
			arr_backgrounds = new Array();
			
			for(var i:int = 0; i<numBgs; i++){
				var id:uint = uint(background_xml.Background[i].Id);
				var url:String = background_xml.Background[i].Url;
				arr_backgrounds[i] = new Background(id, url);
				arr_backgrounds[i].x = 480;
				arr_backgrounds[i].y = (i * 120) + 20;
				arr_backgrounds[i].addEventListener(MouseEvent.MOUSE_UP, onBgUp);
				this.addChild(arr_backgrounds[i]);
			}
		}
		
		private function onBgUp(event:MouseEvent):void
		{
			var userBg:Background = Background(event.currentTarget);
			UserData.background = userBg.bg_id;
			user_selected = true;
			userBg.removeEventListener(MouseEvent.MOUSE_UP, onBgUp);
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
				form.changeState(Form.SIGN_STATE);
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
			
			for each(var bg:Background in arr_backgrounds){
				bg.destroy();
				bg = null;
			}
			
			this.parent.removeChild(this);
		}
	}//class
}//package