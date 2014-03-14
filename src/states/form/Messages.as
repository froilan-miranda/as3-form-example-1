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
	import objects.Logo;
	import objects.Message;
	import states.app.Form;
	import user.UserData;
	
	public class Messages extends Sprite implements IFormState
	{
		private var form:Form;
		private var xml_data:XML;
		private var txt_copy:TextField;
		private var selected_logo:Logo;
		private var arr_messages:Array;
		private var user_selected:Boolean;
		private var bmp_continue:Bitmap;
		private var bttn_continue:Sprite;
		
		public function Messages(form:Form, xmlData:XML)
		{
			this.form = form;
			this.xml_data = xmlData;
			loadCopy();
			loadSelectedLogo();
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
			txt_copy.text = "Please choose your message.";
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
			selected_logo.x = 480;
			selected_logo.y = 0;
			this.addChild(selected_logo);
		}
		
		private function loadOptions():void
		{
			var mess_xml:XMLList = new XMLList(xml_data.Messages);
			var numMessages:uint = mess_xml.Message.length();
			arr_messages = new Array();
			
			for(var i:int = 0; i<numMessages; i++){
				var id:uint = uint(mess_xml.Message[i].Id);
				var copy:String = mess_xml.Message[i].Copy;
				arr_messages[i] = new Message(id, copy);
				arr_messages[i].x = 480;
				arr_messages[i].y = (i * 120) + 20;
				arr_messages[i].addEventListener(MouseEvent.MOUSE_UP, onMessUp);
				this.addChild(arr_messages[i]);
			}
		}
		private function onMessUp(event:MouseEvent):void
		{
			var userMess:Message = Message(event.currentTarget);
			UserData.message = userMess.mess_id;
			user_selected = true;
			userMess.removeEventListener(MouseEvent.MOUSE_UP, onMessUp);
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
				form.changeState(Form.BACKGROUND_STATE);
			}
		}
		private function ioErrorHandler(err:IOErrorEvent):void
		{
			trace("Unable to load image: ");
		}

		public function destroy():void
		{
			xml_data = null;
			this.removeChild(txt_copy);
			txt_copy = null;
			selected_logo.destroy();
			selected_logo = null;
			for each(var mess:Message in arr_messages){
				mess.destroy();
				mess = null;
			}
			arr_messages = null;
			
			bttn_continue.removeChild(bmp_continue);
			bmp_continue = null;
			this.removeChild(bttn_continue);
			bttn_continue = null;
			
			this.parent.removeChild(this);
		}
	}
}