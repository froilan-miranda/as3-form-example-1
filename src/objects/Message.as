package objects
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Message extends Sprite
	{
		private var _mess_id:uint;
		private var mess_copy:String;
		private var txt_mess:TextField;
		
		public function Message(mess_id:uint, mess_copy:String)
		{
			this._mess_id = mess_id;
			this.mess_copy = mess_copy;
			
			loadMessage();
		}
		private function loadMessage():void
		{
			var txt_format:TextFormat = new TextFormat();
			txt_format.size = 12;
			txt_format.align = TextFormatAlign.LEFT;
			txt_format.color = 0xaaaaaa;
			txt_format.bold = false;
			txt_format.font = "Verdana";
			
			txt_mess = new TextField();
			txt_mess.defaultTextFormat = txt_format;
			txt_mess.text = mess_copy;
			txt_mess.border = true;
			txt_mess.wordWrap = true;
			txt_mess.width = 200;
			txt_mess.height = 200;
			txt_mess.x = 125;
			txt_mess.y = 0;
			this.addChild(txt_mess);
			
			txt_format = null;
		}
		public function destroy():void
		{
			this.removeChild(txt_mess);
			txt_mess = null;
			mess_copy = null;
			this.parent.removeChild(this);
		}
		public function get mess_id():uint
		{
			return _mess_id;
		}
	}
}