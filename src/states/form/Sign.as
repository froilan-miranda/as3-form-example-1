package states.form
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import audio.Audio;
	import interfaces.IFormState;
	import objects.Logo;
	import objects.vk.VirtualKeyboard;
	import states.app.Form;
	import user.UserData;
	
	public class Sign extends Sprite implements IFormState
	{
		private var form:Form;
		private var xml_data:XML;
		private var bmp_fin:Bitmap;
		private var bttn_fin:Sprite;
		private var user_selected:Boolean = true;
		private var txt_copy:TextField;
		private var selected_logo:Logo;
		private var field_first:TextField;
		private var label_first:TextField;
		private var field_last:TextField;
		private var label_last:TextField;
		private var field_email:TextField;
		private var label_email:TextField;
		private var keyboard:VirtualKeyboard;

		public function Sign(form:Form, xmlData:XML)
		{
			trace("Sign initiated");
			this.form = form;
			this.xml_data = xmlData;
			loadCopy();
			loadBttn();
			loadSelectedLogo();
			loadFirstField();
			loadLastField();
			loadEmailField();
			loadKeyBoard();
		}

		private function loadKeyBoard():void
		{
			trace("making keyboard");
			keyboard = new VirtualKeyboard();
			keyboard.hide();
			this.addChild(keyboard);
		}

		private function onFieldFocus(event:FocusEvent):void
		{
			var field:TextField = TextField(event.currentTarget);
			keyboard.targetField = field;
			keyboard.show();
			trace(field + " is in focus");
		}

		private function loadFirstField():void
		{
			var txt_format:TextFormat = new TextFormat();
			txt_format.size = 12;
			txt_format.align = TextFormatAlign.LEFT;
			txt_format.color = 0xaaaaaa;
			txt_format.bold = false;
			txt_format.font = "Verdana";

			label_first = new TextField();
			label_first.defaultTextFormat = txt_format;
			label_first.text = "First Name";
			label_first.border = false;
			label_first.wordWrap = false;
			label_first.width = 100;
			label_first.height = 25;
			label_first.x = 20;
			label_first.y = 300;
			this.addChild(label_first);

			field_first = new TextField();
			field_first.defaultTextFormat = txt_format;
			field_first.border = true;
			field_first.borderColor = 0xaaaaaa;
			field_first.wordWrap = true;
			field_first.width = 100;
			field_first.height = 25;
			field_first.x = 120;
			field_first.y = 300;
			field_first.addEventListener(FocusEvent.FOCUS_IN, onFieldFocus);
			this.addChild(field_first);

			txt_format = null;
		}

		private function loadLastField():void
		{
			var txt_format:TextFormat = new TextFormat();
			txt_format.size = 12;
			txt_format.align = TextFormatAlign.LEFT;
			txt_format.color = 0xaaaaaa;
			txt_format.bold = false;
			txt_format.font = "Verdana";

			label_last = new TextField();
			label_last.defaultTextFormat = txt_format;
			label_last.text = "Last Name";
			label_last.border = false;
			label_last.wordWrap = false;
			label_last.width = 100;
			label_last.height = 25;
			label_last.x = 20;
			label_last.y = 350;
			this.addChild(label_last);

			field_last = new TextField();
			field_last.defaultTextFormat = txt_format;
			field_last.border = true;
			field_last.borderColor = 0xaaaaaa;
			field_last.wordWrap = true;
			field_last.width = 100;
			field_last.height = 25;
			field_last.x = 120;
			field_last.y = 350;
			field_last.addEventListener(FocusEvent.FOCUS_IN, onFieldFocus);
			this.addChild(field_last);

			txt_format = null;
		}

		private function loadEmailField():void
		{
			var txt_format:TextFormat = new TextFormat();
			txt_format.size = 12;
			txt_format.align = TextFormatAlign.LEFT;
			txt_format.color = 0xaaaaaa;
			txt_format.bold = false;
			txt_format.font = "Verdana";

			label_email = new TextField();
			label_email.defaultTextFormat = txt_format;
			label_email.text = "Email Address";
			label_email.border = false;
			label_email.wordWrap = false;
			label_email.width = 100;
			label_email.height = 25;
			label_email.x = 20;
			label_email.y = 400;
			this.addChild(label_email);

			field_email = new TextField();
			field_email.defaultTextFormat = txt_format;
			field_email.border = true;
			field_email.borderColor = 0xaaaaaa;
			field_email.wordWrap = true;
			field_email.width = 100;
			field_email.height = 25;
			field_email.x = 120;
			field_email.y = 400;
			field_email.addEventListener(FocusEvent.FOCUS_IN, onFieldFocus);
			this.addChild(field_email);

			txt_format = null;
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
			txt_copy.text = "Please enter your name and email address.";
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
		
		private function loadBttn():void
		{
			var url:String = "assets/images/bttn_temp.png";
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, bttnFin);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			var request:URLRequest  = new URLRequest(url);
			
			loader.load(request);
		}
		
		private function bttnFin(event:Event):void
		{
			var loader:Loader = event.target.loader;
			loader.removeEventListener(Event.COMPLETE, bttnFin);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			bmp_fin = new Bitmap(BitmapData(event.target.content.bitmapData));
			bttn_fin = new Sprite();
			bttn_fin.buttonMode = true;
			bttn_fin.addEventListener(MouseEvent.CLICK, continueOnClick);
			bttn_fin.addChild(bmp_fin);
			bttn_fin.x = 400;
			bttn_fin.y = 300;
			this.addChild(bttn_fin);
			
			loader.unload();
			loader = null;
		}
		
		private function continueOnClick(event:MouseEvent):void
		{
			if(user_selected){
				UserData.firstName = field_first.text;
				UserData.lastName = field_last.text;
				UserData.email = field_email.text;
				bttn_fin.removeEventListener(MouseEvent.CLICK, continueOnClick);
				Audio.playBttn1Sound(1);
				form.finished();
			}
		}

		private function ioErrorHandler(err:IOErrorEvent):void
		{
			trace("Unable to load image: ");
		}
		
		public function destroy():void
		{
			this.removeChild(label_first);
			label_first = null;

			this.removeChild(field_first);
			field_first = null;

			this.removeChild(label_last);
			label_last = null;

			this.removeChild(field_last);
			field_last = null;

			this.removeChild(label_email);
			label_email = null;

			this.removeChild(field_email);
			field_email = null;

			keyboard.destroy();
			keyboard = null;

			this.parent.removeChild(this);
		}
	}//class
}//package